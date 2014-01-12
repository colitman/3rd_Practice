set echo on


drop table mydocs;


create table mydocs 
( id      number primary key,
  thetext varchar2(4000)
)
/


drop table mythemes;


create table mythemes 
( query_id number,
  theme    varchar2(2000),
  weight   number
)
/


insert into mydocs( id, thetext )
values( 1,
'Go to your favorite Web search engine, type in a frequently
occurring word on the Internet like ''database'', and wait
for the plethora of search results to return.'
)
/


commit;


create index my_idx on mydocs(thetext) indextype is ctxsys.context;


begin
    ctx_doc.themes( index_name => 'my_idx',
                    textkey    => '1',
                    restab     => 'mythemes'
    );
end;
/


select theme, weight from mythemes order by weight desc;
