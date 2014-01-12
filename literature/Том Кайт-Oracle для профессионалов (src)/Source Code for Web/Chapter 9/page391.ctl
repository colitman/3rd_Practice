LOAD DATA
INFILE *
INTO TABLE DEPT
REPLACE
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(DEPTNO,
  DNAME        "upper(:dname)",
  LOC          "upper(:loc)",
  LAST_UPDATED "my_to_date( :last_updated )",
  COMMENTS     "replace(:comments,'\n',chr(10))"
)
BEGINDATA
10,Sales,Virginia,01-april-2001,This is the Sales\nOffice in Virginia
20,Accounting,Virginia,13/04/2001,This is the Accounting\nOffice in Virginia
30,Consulting,Virginia,14/04/2001 12:02:02,This is the Consulting\nOffice in Virginia
40,Finance,Virginia,987268297,This is the Finance\nOffice in Virginia
