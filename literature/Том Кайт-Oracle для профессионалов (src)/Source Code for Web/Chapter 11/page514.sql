set echo on

create or replace trigger tkyte_logon
after logon on database
begin
   if ( user = 'TKYTE' ) then
      execute immediate
             'alter session set create_stored_outlines = KillerApp';
   end if;
end;
/

