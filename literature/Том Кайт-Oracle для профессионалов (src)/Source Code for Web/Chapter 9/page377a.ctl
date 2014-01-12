LOAD DATA
INFILE *
INTO TABLE DEPT
REPLACE
( DEPTNO position(1:2),
  DNAME  position(3:16),
  LOC    position(17:29)
)
BEGINDATA
10Accounting    Virginia,USA
