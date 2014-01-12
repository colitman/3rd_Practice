set termout off
spool examp04
set echo on

drop table t;
create table t ( x int, y char(2000), z date ); 

create or replace view redo_size
as
select value 
  from v$mystat, v$statname 
 where v$mystat.statistic# = v$statname.statistic# 
   and v$statname.name = 'redo size';

set autotrace traceonly statistics
insert into t values ( 1, user, sysdate );

insert into t
select object_id, object_name, created
  from all_objects
 where rownum <= 10;

insert into t
select object_id, object_name, created
  from all_objects
 where rownum <= 200
/

declare
  l_redo_size number;
  l_cnt       number := 0;
begin
   select value into l_redo_size from redo_size;
   for x in ( select * from all_objects where rownum <= 200 )
   loop
      insert into t values
      ( x.object_id, x.object_name, x.created );
	  l_cnt := l_cnt+1;
   end loop;
   select value-l_redo_size into l_redo_size from redo_size;
   dbms_output.put_line( 'redo size = ' || l_redo_size || 
                         ' rows = ' || l_cnt );
end;
/

update t set y=lower(y) where rownum = 1;

update t set y=lower(y) where rownum <= 10;

update t set y=lower(y) where rownum <= 200;

declare
  l_redo_size number;
  l_cnt       number := 0;
begin
  select value into l_redo_size from redo_size;
  for x in ( select rowid r from t where rownum <= 200 ) 
  loop
     update t set y=lower(y) where rowid = x.r;
	 l_cnt := l_cnt+1;
  end loop;
  select value-l_redo_size into l_redo_size from redo_size;
  dbms_output.put_line( 'redo size = ' || l_redo_size || 
                        ' rows = ' || l_cnt );
end;
/

delete from t where rownum = 1;

delete from t where rownum <= 10;

delete from t where rownum <= 200;

declare
  l_redo_size number;
  l_cnt       number := 0;
begin
   select value into l_redo_size from redo_size;
   for x in ( select rowid r from t where rownum <= 200 ) loop
      delete from t where rowid = x.r;
	  l_cnt := l_cnt+1;
   end loop;
   select value-l_redo_size into l_redo_size from redo_size;
   dbms_output.put_line( 'redo size = ' || l_redo_size || 
                         ' rows = ' || l_cnt );
end;
/

spool off
set termout on