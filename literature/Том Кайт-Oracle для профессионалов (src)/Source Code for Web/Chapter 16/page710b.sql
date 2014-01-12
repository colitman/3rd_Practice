set echo on

create or replace 
function update_row( p_owner    in varchar2,
                     p_newDname in varchar2,
                     p_newLoc   in varchar2,
                     p_deptno   in varchar2,
                     p_rowid    out varchar2 )
return number
is
begin
    execute immediate
                'update ' || p_owner || '.dept
                    set dname = :bv1, loc = :bv2
                  where deptno = to_number(:pk)
              returning rowid into :out'
    using p_newDname, p_newLoc, p_deptno
    returning into p_rowid;

    return sql%rowcount;
end;
/

set serveroutput on
declare
    l_rowid   varchar(50);
    l_rows    number;
begin
    l_rows := update_row( 'SCOTT', 'CONSULTING', 
                          'WASHINGTON', '10', l_rowid );

    dbms_output.put_line( 'Updated ' || l_rows || ' rows' );
    dbms_output.put_line( 'its rowid was ' || l_rowid );
end;
/

select * from dept;

rollback;

select * from dept;