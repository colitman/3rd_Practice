set echo on


drop table mynews;


create table mynews
( id number primary key,
  date_created date,
  news_text varchar2(4000) )
/


insert into mynews
values( 1, '01-JAN-1990', 'Oracle is doing well' )
/


insert into mynews
values( 2, '01-JAN-2001', 'I am looking forward to 9i' )
/


commit;


begin
    ctx_ddl.create_index_set( 'news_index_set' );
    ctx_ddl.add_index( 'news_index_set', 'date_created' );
end;
/


drop index news_idx;


create index news_idx on mynews( news_text )
indextype is ctxsys.ctxcat
parameters( 'index set news_index_set' )
/


select id
  from mynews
 where catsearch( news_text, 'Oracle', null ) > 0
   and date_created < sysdate
/


select id
  from mynews
 where catsearch( news_text, 'Oracle', 'date_created < sysdate' ) > 0
/