set echo on


delete from mytext;


insert into mytext( id, thetext )
values( 1, 'interMedia Text is quite simple to use');


insert into mytext( id, thetext )
values( 2, 'interMedia Text is powerful, yet easy to learn');


commit;


select pnd_index_name, pnd_rowid from ctx_user_pending;


alter index mytext_idx rebuild online parameters('sync memory 20M');


select pnd_index_name, pnd_rowid from ctx_user_pending;


select id
  from mytext
 where contains( thetext, 'easy') > 0
/


select token_text, token_type from dr$mytext_idx$i;