LOAD DATA                                                  
INFILE *                                                   
INTO TABLE DEPT                                            
REPLACE                                                    
FIELDS TERMINATED BY WHITESPACE
-- FIELDS TERMINATED BY x'09'
(DEPTNO,
DNAME,
LOC
)                                                          
BEGINDATA                                                 
10		Sales		Virginia
