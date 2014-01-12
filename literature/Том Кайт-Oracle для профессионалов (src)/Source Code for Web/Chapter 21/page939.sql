@connect king/king

-- this will show our context and data
-- we can see.  more then one row this
-- time.

select * from session_context;
exec tkyte.hr_app.listEmps


-- this will show we can update ALL records
-- in ALL departments since we are an HR
-- rep for all
-- we will run listEmps again to see which
-- rows we updated (all of them)

exec tkyte.hr_app.updateSal

exec tkyte.hr_app.listEmps

-- since we are an HR REP we can
-- delete anyone given our rules
-- delete All will not delete 'me',
-- the current user

exec tkyte.hr_app.deleteAll

-- since we are an HR REP we can
-- insert anyone given our rules

exec tkyte.hr_app.insertNew(20)

-- lets see the effect of our delete
-- and subsequent insert

exec tkyte.hr_app.listEmps


rollback;
