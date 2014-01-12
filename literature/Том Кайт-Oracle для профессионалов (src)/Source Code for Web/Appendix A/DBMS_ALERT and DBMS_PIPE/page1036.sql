begin
  for i in 1 .. 10 loop
     dbms_alert.signal( 'MyAlert', 'Message ' || i );
  end loop;
end;
/

commit;