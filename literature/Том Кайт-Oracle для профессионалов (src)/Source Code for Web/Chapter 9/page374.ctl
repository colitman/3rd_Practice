LOAD DATA                                                  
INFILE *                                                   
INTO TABLE DEPT                                            
REPLACE                                                    
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'        
(DEPTNO,
DNAME,
LOC
)                                                          
BEGINDATA                                                 
10,Sales,"""USA"""
20,Accounting,"Virginia,USA"
30,Consulting,Virginia
40,Finance,Virginia
50,"Finance","",Virginia
60,"Finance",,Virginia
