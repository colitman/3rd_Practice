LOAD DATA
INFILE demo21.dat "str X'7C0D0A'"
INTO TABLE DEPT
REPLACE
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(DEPTNO,
  DNAME        "upper(:dname)",
  LOC          "upper(:loc)",
  LAST_UPDATED "my_to_date( :last_updated )",
  COMMENTS     char(1000000)
)
