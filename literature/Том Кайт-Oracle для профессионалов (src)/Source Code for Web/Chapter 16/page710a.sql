set echo on

create or replace
function get_row_cnts( p_tname in varchar2 ) return number
as
   l_cnt number;
begin
        execute immediate
          'select count(*) from ' || p_tname
           into l_cnt;

        return l_cnt;
end;
/

set serveroutput on
exec dbms_output.put_line( get_row_cnts('emp') );