LOAD DATA
INFILE demo17.dat "fix 101"
INTO TABLE DEPT
REPLACE
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(DEPTNO,
  DNAME        "upper(:dname)",
  LOC          "upper(:loc)",
  LAST_UPDATED "my_to_date( :last_updated )",
  COMMENTS     
)
