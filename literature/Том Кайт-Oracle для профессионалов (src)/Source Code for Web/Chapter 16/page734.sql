set echo on

create or replace function count_emp return number
as
        l_cnt number;
begin
        select count(*) into l_cnt from emp;
        return l_cnt;
end;
/

select referenced_name, referenced_type
  from user_dependencies
 where name = 'COUNT_EMP'
   and type = 'FUNCTION'
/

select referenced_name, referenced_type
  from user_dependencies
 where name = 'GET_ROW_CNTS'
   and type = 'FUNCTION'
/