set echo on

variable x refcursor
set autoprint on

begin
    open :x for
     select mgr,
            ename,
            row_number() over ( partition by mgr
                                order by ename ) rn
       from emp;
end;
/

begin
    open :x for
    'select mgr,
            ename,
            row_number() over ( partition by mgr
                                order by ename ) rn
       from emp';
end;
/

create or replace view
emp_view
as
select mgr,
       ename,
       row_number() over ( partition by mgr
                           order by ename ) rn
  from emp
/

begin
    open :x for
    'select mgr,
            ename,
            row_number() over ( partition by mgr
                                order by ename ) rn
       from emp';
end;
/