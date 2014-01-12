set echo on

select deptno,
           max(decode(seq,1,ename,null)) highest_paid,
           max(decode(seq,2,ename,null)) second_highest,
           max(decode(seq,3,ename,null)) third_highest
  from ( SELECT deptno, ename,
                row_number() OVER
                   (PARTITION BY deptno
                        ORDER BY sal desc NULLS LAST ) seq
           FROM emp )
where seq <= 3
group by deptno
/