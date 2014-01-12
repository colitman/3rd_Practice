set echo on

declare
    l_prev_addresses   address_Array_Type;
  begin
          select p.previous_addresses into l_prev_addresses
            from people p
           where p.name = 'Tom Kyte';

          l_prev_addresses.extend;
          l_prev_addresses(l_prev_addresses.count) :=
           Address_Type( '123 Main Street', null,
                         'Reston', 'VA', 45678 );

          update people
             set previous_addresses = l_prev_addresses
           where name = 'Tom Kyte';
  end;
/


select name, prev.city, prev.state, prev.zip_code
    from people p, table( p.previous_addresses ) prev
/

