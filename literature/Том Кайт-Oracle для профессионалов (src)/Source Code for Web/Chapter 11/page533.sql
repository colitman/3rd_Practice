@recreateme

set echo on

@su tkyte;
@examp09

create outline outline_1
for category CAT_1
on select * from dual
/


create outline outline_2
for category CAT_2
on select * from dual
/


create outline outline_3
for category CAT_2
on select * from dual A
/

@su sys
select owner, name from dba_outlines where owner = 'TKYTE';

drop user tkyte cascade;

select owner, name from dba_outlines where owner = 'TKYTE';


