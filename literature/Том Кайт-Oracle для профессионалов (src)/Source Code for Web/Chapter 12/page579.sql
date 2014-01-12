set echo on

create or replace package my_pkg
as
    type refcursor is ref cursor;
    type array is table of varchar2(30);

    procedure pivot( p_max_cols       in number   default NULL,
                     p_max_cols_query in varchar2 default NULL,
                     p_query          in varchar2,
                     p_anchor         in array,
                     p_pivot          in array,
                     p_cursor in out refcursor );
end;
/

create or replace package body my_pkg
as

procedure pivot( p_max_cols          in number   default NULL,
                 p_max_cols_query in varchar2 default NULL,
                 p_query          in varchar2,
                 p_anchor         in array,
                 p_pivot          in array,
                 p_cursor in out refcursor )
as
    l_max_cols number;
    l_query    long;
    l_cnames   array;
begin
    -- figure out the number of columns we must support
    -- we either KNOW this or we have a query that can tell us
    if ( p_max_cols is not null )
    then
        l_max_cols := p_max_cols;
    elsif ( p_max_cols_query is not null )
    then
        execute immediate p_max_cols_query into l_max_cols;
    else
        raise_application_error(-20001, 'Cannot figure out max cols');
    end if;

    -- Now, construct the query that can answer the question for us...
    -- start with the C1, C2, ... CX columns:

    l_query := 'select ';
    for i in 1 .. p_anchor.count
    loop
        l_query := l_query || p_anchor(i) || ',';
    end loop;

    -- Now add in the C{x+1}... CN columns to be pivoted:
    -- the format is "max(decode(rn,1,C{X+1},null)) cx+1_1"

    for i in 1 .. l_max_cols
    loop
        for j in 1 .. p_pivot.count
        loop
            l_query := l_query ||
                'max(decode(rn,'||i||','||
                            p_pivot(j)||',null)) ' ||
                            p_pivot(j) || '_' || i || ',';
        end loop;
    end loop;

    -- Now just add in the original query
    l_query := rtrim(l_query,',')||' from ( '||p_query||') group by ';

    -- and then the group by columns...

    for i in 1 .. p_anchor.count
    loop
        l_query := l_query || p_anchor(i) || ',';
    end loop;
    l_query := rtrim(l_query,',');

    -- and return it
    execute immediate 'alter session set cursor_sharing=force';
    open p_cursor for l_query;
    execute immediate 'alter session set cursor_sharing=exact';
end;

end;
/

variable x refcursor
set autoprint on

begin
my_pkg.pivot
(p_max_cols_query => 'select max(count(*)) from emp 
                      group by deptno,job',
 p_query => 'select deptno, job, ename, sal, 
 row_number() over (partition by deptno, job
                    order by sal, ename)
 rn from emp a',
     
   p_anchor => my_pkg.array('DEPTNO','JOB'),
   p_pivot  => my_pkg.array('ENAME', 'SAL'),
   p_cursor => :x );
end;
/

begin
    my_pkg.pivot
    ( p_max_cols_query => 'select max(count(*)) from emp group by mgr',
      p_query => 'select a.ename mgr, b.ename, 
                         row_number() over ( partition by a.ename order by b.ename ) rn
                    from emp a, emp b
                   where a.empno = b.mgr',
      p_anchor => my_pkg.array( 'MGR' ),
      p_pivot  => my_pkg.array( 'ENAME' ),
      p_cursor => :x );
end;
/

begin
  my_pkg.pivot
  (p_max_cols => 4,
   p_query => 'select job, count(*) cnt, deptno,
                  row_number() over (partition by job order by deptno) rn
                  from emp 
                  group by job, deptno',
   p_anchor => my_pkg.array('JOB'),
   p_pivot  => my_pkg.array('DEPTNO', 'CNT'),
   p_cursor => :x );
end;
/