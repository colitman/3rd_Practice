set echo on

@connect sys/manager

drop user tkyte cascade;

create user tkyte identified by tkyte
default tablespace data
temporary tablespace temp;

grant connect, resource to tkyte;

-- minimum privs needed to setup fine grained access control.
-- the role execute_catalog may be used in place of execute
-- on dbms_rls.

grant execute on dbms_rls to tkyte;

grant create any context to tkyte;

-- needed to create the database trigger ON logon...
grant administer database trigger to tkyte;

-- create the employee/managers accounts to represent application users
-- Every user in the EMP table will have an account named  after them

begin
    for x in (select ename
           from scott.emp  where ename <> 'SCOTT')
    loop
        execute immediate 'grant connect to ' || x.ename  ||
                ' identified by ' || x.ename;
    end loop;
end;
/

@connect scott/tiger
grant select on emp to tkyte;
grant select on dept to tkyte;

@connect tkyte/tkyte

-- create the demo schema.  it is based on the EMP & DEPT tables
-- owned by scott.  We add declaritive referential
-- integrity to the schema as well as the HR_REPS table.

create table dept as select * from scott.dept;

alter table dept add constraint dept_pk primary key(deptno);

create table emp_base_table as select * from scott.emp;

alter table emp_base_table add constraint emp_pk primary key(empno);

alter table emp_base_table add constraint emp_fk_to_dept
foreign key (deptno) references dept(deptno);

-- create indexes that will be used by our application context
-- functions for performance.  We need to find if a specific
-- user is a mgr of a department quickly.

create index emp_mgr_deptno_idx on emp_base_table(mgr);

-- Also we need to convert a username into an empno quickly
-- and enforce uniqueness of usernames in this application
alter table emp_base_table
add constraint
emp_ename_unique unique(ename);

-- Also, we create a view EMP as select * from the emp_base_table.
-- This VIEW is what we will place our policy on and what our
-- applications will use to query/insert/update etc.

create view emp as select * from emp_base_table;

-- create the table that manages our assigned HR_REPS. We use
-- an IOT -- INDEX ORGANIZED TABLE (see the chapter on TABLES 
-- for info on IOTs) for this since we always just query
-- "select * from hr_reps where username = X and deptno = Y".
-- no need for a table, just need the index.

create table hr_reps
(  username    varchar2(30),
      deptno      number,
      primary key(username,deptno)
)
organization index;

-- Make our assignments of HR Reps

insert into hr_reps values ( 'KING', 10 );
insert into hr_reps values ( 'KING', 20 );
insert into hr_reps values ( 'KING', 30 );
insert into hr_reps values ( 'BLAKE', 10 );
insert into hr_reps values ( 'BLAKE', 20 );

commit;


    -- Because we need to use it so frequently, the empno for
    -- the current user will be stored in this context as well
    -- we use SESSION user, not CURRENT user here.  SESSION user
    -- is the name of the currently logged in user.  CURRENT user
    -- is the username of the person whose privs the query is
    -- executing with, it would be the owner of this procedure
    -- not the currently logged in user!!!

create or replace 
procedure set_app_role( p_username in varchar2 
                             default sys_context('userenv','session_user') )
as
    l_empno    number;
    l_cnt      number;
	l_ctx      varchar2(255) default 'Hr_App_Ctx';
begin
     dbms_session.set_context( l_ctx, 'UserName', p_username );
     begin
        select empno into l_empno
          from emp_base_table
         where ename = p_username;
        dbms_session.set_context( l_ctx, 'Empno', l_empno );
     exception
        when NO_DATA_FOUND then
           -- Person not in emp table - might be an HR rep.
           NULL;
     end;


    -- First, let's see if this person is a HR_REP, if not, then
    -- try MGR, if not, then set EMP role on.

    select count(*) into l_cnt
      from dual
     where exists
      ( select NULL
          from hr_reps
         where username = p_username
      );

    if ( l_cnt <> 0 )
    then
        dbms_session.set_context( l_ctx, 'RoleName', 'HR_REP' );
        else
        -- Lets see if this person is a MGR, if not, give them
        -- the EMP role.

        select count(*) into l_cnt
          from dual
         where exists
          ( select NULL
              from emp_base_table
             where mgr = to_number(sys_context(l_ctx,'Empno'))
          );
        if ( l_cnt <> 0 )
        then
           dbms_session.set_context(l_ctx, 'RoleName', 'MGR');
        else
        -- Everyone may use the EMP role.
           dbms_session.set_context( l_ctx, 'RoleName', 'EMP' );
        end if;
    end if;
end;
/

-- This is our application context.  the name of the
-- context is HR_APP_CTX. The Procedure it is bound to, in this case
-- is SET_HR_APP_ROLE

create or replace context Hr_App_Ctx using SET_APP_ROLE
/

- Run this procedure upon logon to the database46

create or replace trigger APP_LOGON_TRIGGER
after logon on database
begin
        set_app_role;
end;
/

begin
   dbms_session.set_context( 'Hr_App_Ctx', 
                             'RoleName', 'MGR' );
end;
/
