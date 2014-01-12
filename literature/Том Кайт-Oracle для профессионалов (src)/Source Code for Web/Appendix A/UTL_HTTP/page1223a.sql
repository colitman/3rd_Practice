set echo on

create or replace procedure print_clob( p_clob in clob )
as
     l_offset number default 1;
begin
   loop
     exit when l_offset > dbms_lob.getlength(p_clob);
     dbms_output.put_line( dbms_lob.substr( p_clob, 255, l_offset ) );
     l_offset := l_offset + 255;
   end loop;
end;
/



create or replace procedure p ( p_str in varchar2 )
is
   l_str   long := p_str;
begin
   loop
      exit when l_str is null;
      dbms_output.put_line( substr( l_str, 1, 250 ) );
      l_str := substr( l_str, 251 );
   end loop;
end;
/


create or replace
procedure print_headers( p_httpHeaders correlatedArray )
as
begin
     for i in 1 .. p_httpHeaders.vals.count loop
         p( initcap( p_httpHeaders.vals(i).name ) || ': ' ||
                    p_httpHeaders.vals(i).value );
     end loop;
     p( chr(9) );
end;
/

