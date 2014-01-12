set echo on

create or replace package overloaded
as
        function foo( x in varchar2 ) return number;
        function foo( x in raw ) return number;
end;
/

select overloaded.foo( 'hello' ) from dual;
select overloaded.foo( hextoraw( 'aa' ) ) from dual;