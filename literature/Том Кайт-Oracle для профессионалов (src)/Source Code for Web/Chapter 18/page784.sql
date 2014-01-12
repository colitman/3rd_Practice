create or replace type numArray as table of number
/
create or replace type dateArray as table of date
/
create or replace type strArray as table of varchar2(255)
/

create or replace package demo_passing_pkg
as
    procedure pass( p_in in number, p_out out number );

    procedure pass( p_in in date, p_out out date );

    procedure pass( p_in in varchar2, p_out out varchar2 );

    procedure pass( p_in in boolean, p_out  out boolean );

    procedure pass( p_in in CLOB, p_out in out CLOB );

    procedure pass( p_in in numArray, p_out out numArray );

    procedure pass( p_in in dateArray, p_out out dateArray );

    procedure pass( p_in in strArray, p_out out strArray );

    procedure pass_raw( p_in in RAW, p_out out RAW );

    procedure pass_int( p_in   in binary_integer,
                        p_out  out binary_integer );


    function return_number return number;

    function return_date return date;

    function return_string return varchar2;

end demo_passing_pkg;
/
create or replace library demoPassing 
as 
'C:\demo_passing\extproc.dll'
/
