@su tkyte
@examp09

set echo on

create outline the_outline
on select * from dual;

@su system

select owner, name from dba_outlines;

create outline the_outline
on select * from dual;

drop outline the_outline;

select owner, name from dba_outlines;

