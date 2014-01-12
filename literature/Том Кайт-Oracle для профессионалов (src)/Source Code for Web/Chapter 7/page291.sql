
set echo on
set server output on

create or replace package stats
as
        cnt number default 0;
end;
/

create or replace 
function my_soundex( p_string in varchar2 ) return varchar2
deterministic
as
    l_return_string varchar2(6) default substr( p_string, 1, 1 );
    l_char      varchar2(1);
    l_last_digit    number default 0;

    type vcArray is table of varchar2(10) index by binary_integer;
    l_code_table    vcArray;

begin
    stats.cnt := stats.cnt+1;

    l_code_table(1) := 'BPFV';
    l_code_table(2) := 'CSKGJQXZ';
    l_code_table(3) := 'DT';
    l_code_table(4) := 'L';
    l_code_table(5) := 'MN';
    l_code_table(6) := 'R';


    for i in 1 .. length(p_string)
    loop
        exit when (length(l_return_string) = 6);
        l_char := upper( substr( p_string, i, 1 ) );

        for j in 1 .. l_code_table.count
        loop
        if (instr(l_code_table(j), l_char ) > 0 AND j <> l_last_digit)
        then
            l_return_string := l_return_string || to_char(j,'fm9');
            l_last_digit := j;
        end if;
        end loop;
    end loop;

    return rpad( l_return_string, 6, '0' );
end;
/

