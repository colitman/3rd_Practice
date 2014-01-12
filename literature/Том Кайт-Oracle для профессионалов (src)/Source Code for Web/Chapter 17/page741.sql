set echo on;


drop table mytext;


create table mytext
( id      number primary key,
  thetext varchar2(4000)
)
/


insert into mytext
values( 1, 'The headquarters of Oracle Corporation is ' ||
           'in Redwood Shores, California.');


insert into mytext
values( 2, 'Oracle has many training centers around the world.');


commit;


select id
  from mytext
 where instr( thetext, 'Oracle') > 0;


select id
  from mytext
 where thetext like '%Oracle%';
