set echo on

drop table t;

create table t
as
select * from all_users;

variable x refcursor

begin
        open :x for select * from t;
end;
/

delete from t;

commit;

print x