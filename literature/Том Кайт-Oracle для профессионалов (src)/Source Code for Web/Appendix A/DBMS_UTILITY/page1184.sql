set echo on
set serverout on

declare
    l_start  number;
    n         number := 0;
begin

    l_start := dbms_utility.get_time;

    for x in 1 .. 100000
    loop
        n := n+1;
    end loop;

    dbms_output.put_line( ' it took ' ||
      round( (dbms_utility.get_time-l_start)/100, 2 ) ||
      ' seconds...' );
end;
/

select hsecs, dbms_utility.get_time
from v$timer;