LOAD DATA                                                  
INFILE *                                                   
INTO TABLE DEPT                                            
REPLACE                                                    
FIELDS TERMINATED BY X'09'
(DEPTNO,
DNAME,
LOC
)                                                          
BEGINDATA                                                 
10		Sales		Virginia
