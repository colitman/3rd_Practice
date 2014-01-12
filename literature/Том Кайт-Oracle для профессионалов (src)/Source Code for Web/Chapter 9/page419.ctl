LOAD DATA
INFILE *
INTO TABLE T
replace
fields terminated by ","
(
  x,
  y_cnt               FILLER,
  y                   varray count (y_cnt)
  (
    y   
  )
)

BEGINDATA
1,2,3,4
2,10,1,2,3,4,5,6,7,8,9,10
3,5,5,4,3,2,1
