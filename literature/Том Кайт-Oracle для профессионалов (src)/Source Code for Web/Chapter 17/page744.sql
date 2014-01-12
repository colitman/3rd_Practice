set echo on


drop table purchase_order;


create table purchase_order
( id                  number primary key,
  description         varchar2(100),
  line_item_body      char(1)
)
/


drop table line_item;


create table line_item
( po_id            number,
  po_sequence      number,
  line_item_detail varchar2(1000)
)
/


insert into purchase_order ( id, description )
values( 1, 'Many Office Items' )
/


insert into line_item( po_id, po_sequence, line_item_detail )
values( 1, 1, 'Paperclips to be used for many reports')
/


insert into line_item( po_id, po_sequence, line_item_detail )
values( 1, 2, 'Some more Oracle letterhead')
/


insert into line_item( po_id, po_sequence, line_item_detail )
values( 1, 3, 'Optical mouse')
/


commit;


begin
 ctx_ddl.create_preference( 'po_pref', 'DETAIL_DATASTORE' );
 ctx_ddl.set_attribute( 'po_pref', 'detail_table', 'line_item' );
 ctx_ddl.set_attribute( 'po_pref', 'detail_key', 'po_id' );
 ctx_ddl.set_attribute( 'po_pref', 'detail_lineno', 'po_sequence' );
 ctx_ddl.set_attribute( 'po_pref', 'detail_text', 'line_item_detail' );
end;
/


drop index po_index;


create index po_index on purchase_order( line_item_body )
indextype is ctxsys.context
parameters( 'datastore po_pref' )
/


select id
  from purchase_order
 where contains( line_item_body, 'Oracle' ) > 0
/