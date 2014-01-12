create or replace type my_dbms_output_type
as table of varchar2(4000)
/

create or replace package my_dbms_output
as
    procedure enable;
    procedure disable;

    procedure put( s in varchar2 );
    procedure put_line( s in varchar2 );
    procedure new_line;

    function get return my_dbms_output_type;
    procedure flush;
    function get_and_flush return my_dbms_output_type;
end;
/

create or replace package body my_dbms_output
as

g_data       my_dbms_output_type := my_dbms_output_type();
g_enabled    boolean default TRUE;

    procedure enable
    is
    begin
        g_enabled := TRUE;
    end;

    procedure disable
    is
    begin
        g_enabled := FALSE;
    end;

    procedure put( s in varchar2 )
    is
    begin
        if ( NOT g_enabled ) then return; end if;
        if ( g_data.count <> 0 ) then
            g_data(g_data.last) := g_data(g_data.last) || s;
        else
            g_data.extend;
            g_data(1) := s;
        end if;
    end;

    procedure put_line( s in varchar2 )
    is
    begin
        if ( NOT g_enabled ) then return; end if;
        put( s );
        g_data.extend;
    end;

    procedure new_line
    is
    begin
        if ( NOT g_enabled ) then return; end if;
        put( null );
        g_data.extend;
    end;


    procedure flush
    is
       l_empty      my_dbms_output_type := my_dbms_output_type();
    begin
        g_data := l_empty;
    end;

    function get return my_dbms_output_type
    is
    begin
        return g_data;
    end;

    function get_and_flush return my_dbms_output_type
    is
       l_data       my_dbms_output_type := g_data;
       l_empty      my_dbms_output_type := my_dbms_output_type();
    begin
        g_data := l_empty;
        return l_data;
    end;
end;
/

create or replace
view my_dbms_output_peek ( text )
as
select *
  from TABLE ( cast( my_dbms_output.get()
                       as my_dbms_output_type ) )
/

create or replace
view my_dbms_output_view ( text )
as
select *
  from TABLE ( cast( my_dbms_output.get_and_flush()
                       as my_dbms_output_type ) )
/

begin
        my_dbms_output.put_line( 'hello' );
        my_dbms_output.put( 'Hey ' );
        my_dbms_output.put( 'there ' );
        my_dbms_output.new_line;

    for i in 1 .. 20
    loop
        my_dbms_output.put_line( rpad( ' ', i, ' ' ) || i );
    end loop;
end;
/

select *
  from my_dbms_output_peek
/

select *
  from my_dbms_output_peek
/

select *
  from my_dbms_output_peek
 where text like '%1%'
/

select *
  from my_dbms_output_view
/

select *
  from my_dbms_output_view
/