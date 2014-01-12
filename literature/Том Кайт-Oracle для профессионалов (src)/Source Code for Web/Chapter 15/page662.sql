set echo on
@su tkyte


drop table emp;
drop table audit_tab;

create table emp
as
select * from scott.emp;

grant all on emp to scott;

create table audit_tab
( username   varchar2(30) default user,
  timestamp  date default sysdate,
  msg        varchar2(4000)
)
/

create or replace trigger EMP_AUDIT
before update on emp
for each row
declare
    pragma autonomous_transaction;
    l_cnt  number;
begin

    select count(*) into l_cnt
      from dual
     where EXISTS ( select null
                      from emp
                     where empno = :new.empno
                     start with mgr = ( select empno
                                          from emp
                                         where ename = USER )
                   connect by prior  empno = mgr );

    if ( l_cnt = 0 )
    then
        insert into audit_tab ( msg )
        values ( 'Attempt to update ' || :new.empno );
        commit;

        raise_application_error( -20001, 'Access Denied' );
    end if;
end;
/

update emp set sal = sal*10;

column msg format a30 word_wrapped
select * from audit_tab;

@su scott
update tkyte.emp set sal = sal*1.05 where ename = 'ADAMS';
update tkyte.emp set sal = sal*1.05 where ename = 'SCOTT';

@su tkyte
select * from audit_tab;


create or replace trigger EMP_AUDIT
before update on emp
for each row
declare
    -- pragma autonomous_transaction;
    l_cnt  number;
begin

    select count(*) into l_cnt
      from dual
     where EXISTS ( select null
                      from emp
                     where empno = :new.empno
                     start with mgr = ( select empno
                                          from emp
                                         where ename = USER )
                   connect by prior  empno = mgr );

    if ( l_cnt = 0 )
    then
        insert into audit_tab ( msg )
        values ( 'Attempt to update ' || :new.empno );
        -- commit;

        raise_application_error( -20001, 'Access Denied' );
    end if;
end;
/

update emp set sal = sal*10;

