@connect jones/jones
set serveroutput on

-- this will show our context and data
-- we can see.  more then one row this
-- time.
select * from session_context;

exec tkyte.hr_app.listEmps

-- this will show we can update some records
-- we will run listEmps again to see which
-- rows we updated (our direct reports only)
exec tkyte.hr_app.updateSal
exec tkyte.hr_app.listEmps

-- since we are not an HR REP we cannot
-- delete anyone given our rules
exec tkyte.hr_app.deleteAll

-- since we are not an HR REP we cannot
-- insert anyone given our rules
exec tkyte.hr_app.insertNew(20)

rollback;
