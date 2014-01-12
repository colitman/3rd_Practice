set echo on

drop table log;

create table log ( what varchar2(15), -- will be no trigger, after or before
                   op varchar2(10),   -- will be insert/update or delete
                   rowsize int,       -- will be the size of Y
                   redo_size int,     -- will be the redo generated
                   rowcnt int )      -- will be the count of rows affected
;

create or replace procedure do_work( p_what in varchar2 )
as
  l_redo_size number;
  l_cnt       number := 200;

  procedure report( l_op in varchar2 )
  is
  begin
     select value-l_redo_size into l_redo_size from redo_size;
     dbms_output.put_line(l_op || ' redo size = ' || l_redo_size ||
                           ' rows = ' || l_cnt || ' ' ||
                           to_char(l_redo_size/l_cnt,'99,999.9') ||
                           ' bytes/row' );
    insert into log
    select p_what, l_op, data_length, l_redo_size, l_cnt
      from user_tab_columns
     where table_name = 'T'
       and column_name = 'Y';
   end;
begin
  select value into l_redo_size from redo_size;
  insert into t
  select object_id, object_name, created
    from all_objects
   where rownum <= l_cnt;
  l_cnt := sql%rowcount;
  commit;
  report('insert');

  select value into l_redo_size from redo_size;
  update t set y=lower(y);
  l_cnt := sql%rowcount;
  commit;
  report('update');

  select value into l_redo_size from redo_size;
  delete from t;
  l_cnt := sql%rowcount;
  commit;
  report('delete');
end;
/

truncate table t;

exec do_work( 'no trigger' );

create or replace trigger before_insert_update_delete
before insert or update or delete on T for each row
begin
        null;
end;
/

truncate table t;

exec do_work( 'before trigger' );

drop trigger before_insert_update_delete;

create or replace trigger after_insert_update_delete
after insert or update or delete on T
for each row
begin
        null;
end;
/

truncate table t;

exec do_work( 'after trigger' );

break on op skip 1
set numformat 999,999

select op, rowsize, no_trig, before_trig-no_trig, after_trig-no_trig
from ( select op, rowsize,
           sum(decode( what, 'no trigger', redo_size/rowcnt,0 ) ) no_trig,
           sum(decode( what, 'before trigger', redo_size/rowcnt, 0 ) ) before_trig,
           sum(decode( what, 'after trigger', redo_size/rowcnt, 0 ) ) after_trig
         from log
        group by op, rowsize
     )
 order by op, rowsize
/