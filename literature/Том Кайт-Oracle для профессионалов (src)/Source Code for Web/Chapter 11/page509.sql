create or replace trigger tkyte_logon
after logon on database
begin
   if ( user = 'TKYTE' ) then
      execute immediate
             'alter session set use_stored_outlines = mycategory';
   end if;
end;
/

