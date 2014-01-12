create user tkyte identified by tkyte;
grant create session to tkyte;
grant create procedure to tkyte;
grant create any library to tkyte;
grant create table to tkyte;
alter user tkyte default tablespace users quota unlimited on users;
grant create any directory to tkyte;
grant create type to tkyte;
