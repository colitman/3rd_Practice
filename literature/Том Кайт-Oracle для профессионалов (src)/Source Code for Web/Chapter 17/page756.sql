set echo on


select id from mytext where contains(thetext,'about(databases)') > 0;


select id from mytext where contains(thetext,'about(simply)') > 0;


select id from mytext where contains(thetext,'simply') > 0;