set echo on

create table policy_rules_table 
( predicate_piece varchar2(255) 
);

insert into policy_rules_table values ( 'x > 0' );

create or replace function rls_examp
( p_schema in varchar2, p_object in varchar2 )
return varchar2
as
    l_predicate_piece varchar2(255);
begin
    select predicate_piece into l_predicate_piece
      from policy_rules_table;

    return l_predicate_piece;
end;
/

exec dump_t

update policy_rules_table set predicate_piece = '1=0';

exec dump_t(0)