set echo on


drop table my_urls;


create table my_urls
( id number primary key,
  theurl varchar2(4000)
)
/


drop index my_url_idx;


create index my_url_idx on my_urls( theurl )
indextype is ctxsys.context
parameters( 'datastore ctxsys.url_datastore' )
/


update my_urls
   set theurl = theurl
 where id = 1
/