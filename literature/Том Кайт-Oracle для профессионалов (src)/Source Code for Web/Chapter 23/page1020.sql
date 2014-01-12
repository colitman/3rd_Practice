@connect tkyte/tkyte
set echo on

host type ir_java.java

host dropjava -user tkyte/tkyte ir_java.java
host loadjava -user tkyte/tkyte -synonym -grant u1 -verbose -resolve ir_java.java

host type ir_java.java

host dropjava -user tkyte/tkyte dr_java.java
host loadjava -user tkyte/tkyte -synonym -definer -grant u1 -verbose -resolve dr_java.java

create OR replace procedure ir_ir_java
authid current_user
as language java name 'ir_java.test()';
/

grant execute on ir_ir_java to u1;

create OR replace procedure dr_ir_java
as language java name 'ir_java.test()';
/

grant execute on dr_ir_java to u1;

create OR replace procedure ir_dr_java
authid current_user
as language java name 'dr_java.test()';
/

grant execute on ir_dr_java to u1;

create OR replace procedure dr_dr_java
authid current_user
as language java name 'dr_java.test()';
/

grant execute on dr_dr_java to u1;

drop table t;

create table t ( msg varchar2(50) );

insert into t values ( 'This is T owned by ' || user  );

@connect u1/pw

drop table t;

create table t ( msg varchar2(50) );

insert into t values ( 'This is T owned by ' || user  );

set serveroutput on size 1000000
exec dbms_java.set_output(1000000);

exec tkyte.ir_ir_java
exec tkyte.dr_ir_java

exec tkyte.ir_dr_java
exec tkyte.dr_dr_java

create OR replace procedure ir_java
authid current_user
as language java name 'ir_java.test()';
/

exec ir_java

create OR replace procedure dr_java
as language java name 'dr_java.test()';
/

exec dr_java

