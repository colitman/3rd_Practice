set echo on

create or replace type myTableType
as table of number;
/

create or replace
function str2tbl( p_str in varchar2 ) return myTableType
as
    l_str   long default p_str || ',';
    l_n        number;
    l_data    myTableType := myTabletype();
begin
    loop
        l_n := instr( l_str, ',' );
        exit when (nvl(l_n,0) = 0);
        l_data.extend;
        l_data( l_data.count ) :=
            ltrim(rtrim(substr(l_str,1,l_n-1)));
        l_str := substr( l_str, l_n+1 );
    end loop;
    return l_data;
end;
/

variable bind_variable varchar2(30)
exec :bind_variable := '1,3,5,7,99'

select *
  from TABLE ( cast ( str2tbl(:bind_variable) as myTableType ) )
/

select *
  from all_users
 where user_id in
     ( select *
         from TABLE ( cast ( str2tbl(:bind_variable) as myTableType ) )
     )
/

create or replace type myRecordType as object
( seq int,
  a int,
  b varchar2(10),
  c date
)
/

drop table t;
create table t ( x int, y varchar2(10), z date );

create or replace type myTableType
as table of myRecordType
/

create or replace function my_function return myTableType
is
    l_data myTableType;
begin
    l_data := myTableType();

    for i in 1..5
    loop
        l_data.extend;
        l_data(i) := myRecordType( i, i, 'row ' || i, sysdate+i );
    end loop;
    return l_data;
end;
/

select *
  from TABLE ( cast( my_function() as mytableType ) )
 where c > sysdate+1
 order by seq desc
/


create or replace type myScalarType
as object
( username varchar2(30),
  user_id  number,
  created  date
)
/


create or replace type myTableType as table of myScalarType
/


declare
    l_users    myTableType;
begin
    select cast( multiset(select username, user_id, created
                            from all_users
                           order by username )
                 as myTableType )
      into l_users
      from dual;

    dbms_output.put_line( 'Retrieved '|| l_users.count || ' rows');
end;
/


drop table t;
create table t as select * from all_users where 1=0;

declare
    l_users    myTableType :=
                   myTableType( myScalarType( 'tom', 1, sysdate ) );
begin
        insert into t
        select * from TABLE ( cast( l_users as myTableType ) );
end;
/

select * from t;
/
