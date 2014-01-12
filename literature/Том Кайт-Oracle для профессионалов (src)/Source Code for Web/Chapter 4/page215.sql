

drop table addresses;

create table addresses
( empno     number(4) references emp(empno) on delete cascade,
  addr_type varchar2(10),
  street    varchar2(20),
  city      varchar2(20),
  state		varchar2(2),
  zip		number,
  primary key (empno,addr_type)
)
ORGANIZATION INDEX
/

drop table stocks;

create table stocks
( ticker      varchar2(10),
  day         date,
  value       number,
  change      number,
  high        number,
  low         number,
  vol         number,
  primary key(ticker,day)
)
organization index
/
