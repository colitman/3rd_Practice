set echo on

truncate table t;

/
commit;

declare
  l_redo_size number;
  l_cnt       number := 200;

  procedure report
  is
  begin
     select value-l_redo_size into l_redo_size from redo_size;
     dbms_output.put_line( 'redo size = ' || l_redo_size || 
                           ' rows = ' || l_cnt || ' ' ||
                           to_char(l_redo_size/l_cnt,'99,999.9') || 
                           ' bytes/row' );
   end;
begin
  select value into l_redo_size from redo_size;
  insert into t
  select object_id, object_name, created
    from all_objects
   where rownum <= l_cnt;
  commit;
  report;

  select value into l_redo_size from redo_size;
  update t set y=lower(y);
  commit;
  report;

  select value into l_redo_size from redo_size;
  delete from t;
  commit;
  report;
end;
/

truncte table t;

declare
  l_redo_size number;
  l_cnt       number := 200;
  procedure report
  is
  begin
     select value-l_redo_size into l_redo_size from redo_size;
     dbms_output.put_line( 'redo size = ' || l_redo_size || 
                           ' rows = ' || l_cnt || ' ' ||
                           to_char(l_redo_size/l_cnt,'99,999.9') || 
                           ' bytes/row' );
   end;
begin
  select value into l_redo_size from redo_size;
  for x in ( select object_id, object_name, created
               from all_objects
              where rownum <= l_cnt ) 
  loop
          insert into t values 
        ( x.object_id, x.object_name, x.created );
        commit;
  end loop;
  report;

  select value into l_redo_size from redo_size;
  for x in ( select rowid rid from t )
  loop
      update t set y = lower(y) where rowid = x.rid;
    commit;
  end loop;
  report;

  select value into l_redo_size from redo_size;
  for x in ( select rowid rid from t )
  loop
      delete from t where rowid = x.rid;
    commit;
  end loop;
  report;
end;
/