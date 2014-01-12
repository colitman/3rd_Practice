LOAD DATA
INFILE *
INTO TABLE DEPT
REPLACE
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(DEPTNO,
  DNAME        "upper(:dname)",
  LOC          "upper(:loc)",
  LAST_UPDATED "case when length(:last_updated) <= 10 
                     then to_date(:last_updated,'dd/mm/yyyy')
		     else to_date(:last_updated,'dd/mm/yyyy hh24:mi:ss')
		end"
)
BEGINDATA
10,Sales,Virginia,1/5/2000 12:03:03
20,Accounting,Virginia,21/6/1999
30,Consulting,Virginia,5/1/2000 01:23:00
40,Finance,Virginia,15/3/2001
