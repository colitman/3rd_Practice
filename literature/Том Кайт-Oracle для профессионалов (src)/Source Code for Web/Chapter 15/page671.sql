drop table audit_trail;

create table audit_trail
( username  varchar2(30),
  pk        number,
  attribute varchar2(30),
  dataum    varchar2(255),
  timestamp date
)
/


create or replace package audit_trail_pkg
as
    function record( p_pk in number,
                     p_attr in varchar2,
                     p_dataum in number ) return number;
    function record( p_pk in number,
                     p_attr in varchar2,
                     p_dataum in varchar2 ) return varchar2;
    function record( p_pk in number,
                     p_attr in varchar2,
                     p_dataum in date ) return date;
end;
/

create or replace package body audit_trail_pkg
as

procedure log( p_pk in number,
               p_attr in varchar2,
               p_dataum in varchar2 )
as
    pragma autonomous_transaction;
begin
    insert into audit_trail values
    ( user, p_pk, p_attr, p_dataum, sysdate );
    commit;
end;

function record( p_pk in number,
                 p_attr in varchar2,
                 p_dataum in number ) return number
is
begin
    log( p_pk, p_attr, p_dataum );
    return p_dataum;
end;

function record( p_pk in number,
                 p_attr in varchar2,
                 p_dataum in varchar2 ) return varchar2
is
begin
    log( p_pk, p_attr, p_dataum );
    return p_dataum;
end;

function record( p_pk in number,
                 p_attr in varchar2,
                 p_dataum in date ) return date
is
begin
    log( p_pk, p_attr,
         to_char(p_dataum,'dd-mon-yyyy hh24:mi:ss') );
    return p_dataum;
end;

end;
/

create or replace view emp_v
as
select empno , ename, job,mgr, 
       audit_trail_pkg.record( empno, 'sal', sal ) sal,
       audit_trail_pkg.record( empno, 'comm', comm ) comm,
       audit_trail_pkg.record( empno, 'hiredate', hiredate ) hiredate,
       deptno
  from emp
/


select empno, ename, hiredate, sal, comm, job
  from emp_v where ename = 'KING';

column username format a8
column pk format 9999
column attribute format a8
column dataum format a20

select * from audit_trail;

select empno, ename from emp_v where ename = 'BLAKE';
select * from audit_trail;


delete from audit_trail;
commit;
select avg(sal) from emp_v;
select * from audit_trail;
select ename from emp_v where sal >= 5000;
select * from audit_trail;
