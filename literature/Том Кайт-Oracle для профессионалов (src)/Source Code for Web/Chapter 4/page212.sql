create table keywords
( word  varchar2(50),
  position   int,
  doc_id int, 
  primary key(word,position,doc_id)
);

