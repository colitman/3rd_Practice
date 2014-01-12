drop table temp;
drop table t;


create table t
( serial_no varchar2(20),
  date_time varchar2(50),
  location  varchar2(100),
  status    varchar2(100)
)
/


create table temp
( seqno int primary key, 
   text varchar2(4000) )
organizarion index
overflow tablespace data;


create or replace procedure reformat
as
    l_serial_no t.serial_no%type;
    l_date_time t.date_time%type;
    l_location  t.location%type;
    l_status    t.status%type;
    l_temp_date date;
begin
    for x in ( select * from temp order by seqno ) 
    loop
        if ( x.text like '%Detailed Report%' ) then
            l_serial_no := substr( x.text, 1, instr(x.text,'-')-1 );
        elsif ( x.text like '%Location : %' ) then
            l_location := substr( x.text, instr(x.text,':')+2 );
        elsif ( x.text like '%Status %:%' ) then
            l_status := substr( x.text, instr(x.text,':')+2 );
            insert into t ( serial_no, date_time, location, status )
            values ( l_serial_no, l_date_time, l_location, l_status );
        else
            begin
                l_temp_date := to_date( ltrim(rtrim(x.text)), 
                                      'Month dd, yyyy hh24:mi');
                l_date_time := x.text;
            exception
                when others then null;
            end;
        end if;
    end loop;
end;
/

