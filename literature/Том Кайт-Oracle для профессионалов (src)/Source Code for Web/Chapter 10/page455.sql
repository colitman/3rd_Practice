set echo on
set server output on

show parameter timed_statistics;

alter session set sql_trace=true;


select owner, count(*)
from all_objects
group by owner;
/


select a.spid
    from v$process a, v$session b
   where a.addr = b.paddr
     and b.audsid = userenv('sessionid')
/

 
declare
  l_intval number;
  l_strval varchar2(2000);
  l_type   number;
  begin
     l_type := dbms_utility.get_parameter_value
                         ('user_dump_dest', l_intval, l_strval);
     dbms_output.put_line(l_strval );
  end;
/
