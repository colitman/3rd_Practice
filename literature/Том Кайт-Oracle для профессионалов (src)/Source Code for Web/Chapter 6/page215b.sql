dro table stocks;

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
