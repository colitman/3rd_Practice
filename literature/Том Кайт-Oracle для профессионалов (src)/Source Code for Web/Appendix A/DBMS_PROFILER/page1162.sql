set echo on

create or replace
function fact_recursive( n int ) return number
as
begin
        if ( n = 1 )
        then
                return 1;
        else
                return n * fact_recursive(n-1);
        end if;
end;
/

create or replace
function fact_iterative( n int ) return number
as
        l_result number default 1;
begin
        for i in 2 .. n
        loop
                l_result := l_result * i;
        end loop;
        return l_result;
end;
/

set serveroutput on

exec dbms_profiler.start_profiler( 'factorial recursive' )

begin
	for i in 1 .. 50 loop
		dbms_output.put_line( fact_recursive(50) );
	end loop;
end;
/

exec dbms_profiler.stop_profiler

exec dbms_profiler.start_profiler( 'factorial iterative' )

begin
	for i in 1 .. 50 loop
		dbms_output.put_line( fact_iterative(50) );
	end loop;
end;
/

exec dbms_profiler.stop_profiler