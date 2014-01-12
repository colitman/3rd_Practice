set autotrace traceonly explain

select owner, status
  from T
 where owner = USER;

select count(*)
  from T
 where owner = USER;
set autotrace off
