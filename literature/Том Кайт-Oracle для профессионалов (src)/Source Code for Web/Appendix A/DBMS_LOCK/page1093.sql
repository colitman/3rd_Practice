set echo on

drop table demo;

create table demo ( x int primary key );

create or replace trigger demo_bifer
before insert on demo
for each row
declare
    l_lock_id   number;
    resource_busy   exception;
    pragma exception_init( resource_busy, -54 );
begin
    l_lock_id :=
       dbms_utility.get_hash_value( to_char( :new.x ), 0, 1024 );

    if ( dbms_lock.request
             (  id                => l_lock_id,
                lockmode          => dbms_lock.x_mode,
                timeout           => 0,
                release_on_commit => TRUE ) = 1 )
    then
        raise resource_busy;
    end if;
end;
/

insert into demo values (1);

set echo off
prompt goto another session and try that insert as well now
prompt then come back here and hit enter
pause
set echo on

select sid, type, id1 
  from v$lock
 where sid = ( select sid from v$mystat where rownum = 1 )
/

begin
	dbms_output.put_line
	( dbms_utility.get_hash_value( to_char(1), 0, 1024 ) );
end;
/

commit;

update demo set x = 2 where x = 1;

set echo off
prompt goto another session and try 
prompt INSERT INTO DEMO VALUES (2);
prompt that session will block until you 
prompt come back here and hit enter
pause
set echo on

commit;

create or replace trigger demo_bifer
before insert OR UPDATE OF X on demo
for each row
declare
    l_lock_id   number;
    resource_busy   exception;
    pragma exception_init( resource_busy, -54 );
begin
    l_lock_id :=
       dbms_utility.get_hash_value( to_char( :new.x ), 0, 1024 );

    if ( dbms_lock.request
             (  id                => l_lock_id,
                lockmode          => dbms_lock.x_mode,
                timeout           => 0,
                release_on_commit => TRUE ) = 1 )
    then
        raise resource_busy;
    end if;
end;
/

update demo set x = 3 where x = 2;

set echo off
prompt goto another session and try 
prompt INSERT INTO DEMO VALUES (3);
prompt come back here and hit enter
pause
set echo on

commit;