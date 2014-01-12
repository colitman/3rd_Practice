begin
  for i in 1 .. 10 loop
     dbms_alert.signal( 'MyAlert', 'Message ' || i );
     commit;
  end loop;
end;
/