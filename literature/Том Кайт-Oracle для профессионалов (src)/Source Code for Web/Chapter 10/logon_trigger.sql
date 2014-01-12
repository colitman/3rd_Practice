set echo on

-- change name of user to reflect your own user.......

create or replace trigger logon_trigger
after logon on database
begin
  if ( user = 'TKYTE' ) then
    execute immediate
    'ALTER SESSION SET EVENTS ''10046 TRACE NAME CONTEXT FOREVER, LEVEL 4''';
  end if;
end;
/