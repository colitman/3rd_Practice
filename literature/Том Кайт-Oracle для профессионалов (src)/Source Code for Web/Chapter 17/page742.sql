set echo on


drop index mytext_idx;


create index mytext_idx
on mytext( thetext )
indextype is CTXSYS.CONTEXT
/


select id
  from mytext
 where contains( thetext, 'near((Oracle,Corporation),10)') > 0;


select score(1), id
  from mytext
 where contains( thetext, 'oracle or california', 1 ) > 0
 order by score(1) desc
/


select id
  from mytext
 where contains( thetext, '$train') > 0;
