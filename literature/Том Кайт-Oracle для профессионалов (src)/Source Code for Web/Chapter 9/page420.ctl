LOAD DATA
INFILE *
INTO TABLE T
replace
fields terminated by ","
(
  x,
  y                   nested table count (CONSTANT 5)
  (
    y
  )
)

BEGINDATA
1,100,200,300,400,500
2,123,243,542,123,432
3,432,232,542,765,543
