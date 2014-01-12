define _editor=vi

set serveroutput on size 1000000

set trimspool on
set long 5000
set linesize 100
set pagesize 9999

column plan_plus_exp format a80

column global_name new_value gname
set termout off
select lower(user) || '@' ||
decode(global_name, 'ORACLE8.WORLD', '8.0', 'ORA8I.WORLD',
'8i', global_name ) global_name from global_name;
set sqlprompt '&gname> '
set termout on