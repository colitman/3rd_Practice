set echo on

@connect sys/manager
grant select on v_$mystat to tkyte;
grant select on v_$statname to tkyte;

@connect tkyte/tkyte

drop table t;

create table t 
as
select * from all_objects
/

insert into t select * from t;
insert into t select * from t;
insert into t select * from t where rownum < 12000;
commit;

create or replace procedure do_commit( p_rows in number )
as
    l_start        number;
    l_after_redo   number;
    l_before_redo  number;
begin
    select v$mystat.value into l_before_redo
      from v$mystat, v$statname
     where v$mystat.statistic# = v$statname.statistic#
       and v$statname.name = 'redo size';

    l_start := dbms_utility.get_time;
    insert into t select * from t where rownum < p_rows;
    dbms_output.put_line
    ( sql%rowcount || ' rows created' );
    dbms_output.put_line
    ( 'Time to INSERT: ' ||
       to_char( round( (dbms_utility.get_time-l_start)/100, 5 ), 
               '999.99') || 
      ' seconds' );

    l_start := dbms_utility.get_time;
    commit;
    dbms_output.put_line
    ( 'Time to COMMIT: ' ||
       to_char( round( (dbms_utility.get_time-l_start)/100, 5 ), 
               '999.99') || 
      ' seconds' );

    select v$mystat.value into l_after_redo
      from v$mystat, v$statname
     where v$mystat.statistic# = v$statname.statistic#
       and v$statname.name = 'redo size';

    dbms_output.put_line
    ( 'Generated ' || 
       to_char(l_after_redo-l_before_redo,'999,999,999,999') ||
      ' bytes of redo' );
    dbms_output.new_line;
end;
/

set serveroutput on format wrapped
begin
    for i in 1 .. 5
    loop
        do_commit( power(10,i) );
    end loop;
end;
/