set echo on

@connect tkyte/tkyte


create or replace function rls_examp
( p_schema in varchar2, p_object in varchar2 )
return varchar2
as
begin
    return 'x = nonexistent_column';
end;
/

select * from t;

@gettrace
