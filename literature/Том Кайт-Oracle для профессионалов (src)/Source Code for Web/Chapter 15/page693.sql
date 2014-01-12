drop table emp;

create table emp as select * from scott.emp;


create or replace
procedure sal_check( p_deptno in number )
is
        avg_sal number;
        max_sal number;
begin
        select avg(sal), max(sal)
          into avg_sal, max_sal
          from emp
     where deptno = p_deptno;

        if ( max_sal/2 > avg_sal )
        then
                raise_application_error(-20001,'Rule violated');
        end if;
end;
/


create or replace trigger sal_trigger
after insert or update or delete on emp
for each row
begin
        if (inserting or updating) then
                sal_check(:new.deptno);
        end if;

        if (updating or deleting) then
                sal_check(:old.deptno);
        end if;
end;
/

update emp set sal = sal*1.1;


create or replace
procedure sal_check( p_deptno in number )
is
	pragma autonomous_transaction;
        avg_sal number;
        max_sal number;
begin
        select avg(sal), max(sal)
          into avg_sal, max_sal
          from emp
     where deptno = p_deptno;

        if ( max_sal/2 > avg_sal )
        then
                raise_application_error(-20001,'Rule violated');
        end if;
end;
/

update emp set sal = sal*1.1;
commit;

update emp set sal = 99999.99 where ename = 'WARD';

commit;

exec sal_check(30);


