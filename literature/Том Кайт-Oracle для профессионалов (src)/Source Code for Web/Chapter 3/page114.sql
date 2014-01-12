update dept set deptno = deptno+10;

select username,
       v$lock.sid,
           trunc(id1/power(2,16)) rbs,
           bitand(id1,to_number('ffff','xxxx'))+0 slot,
           id2 seq,
       lmode,
           request
from v$lock, v$session
where v$lock.type = 'TX'
  and v$lock.sid = v$session.sid
  and v$session.username = USER
/


select XIDUSN, XIDSLOT, XIDSQN
  from v$transaction
/


