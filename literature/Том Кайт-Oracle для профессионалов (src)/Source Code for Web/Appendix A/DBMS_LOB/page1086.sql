set echo on

create global temporary table lob_temp
( id    int primary key,
  c_lob clob,
  b_lob blob
)
/

create sequence lob_temp_seq;

create or replace
function to_blob( p_cname in varchar2,
                  p_tname in varchar2,
                  p_rowid in rowid ) return blob
as
    l_blob blob;
    l_id   int;
begin
    select lob_temp_seq.nextval into l_id from dual;

    execute immediate
       'insert into lob_temp (id,b_lob)
        select :id, to_lob( ' || p_cname || ' )
          from ' || p_tname ||
       ' where rowid = :rid '
     using IN l_id, IN p_rowid;

    select b_lob into l_blob from lob_temp where id = l_id ;

    return l_blob;
end;
/

create or replace
function to_clob( p_cname in varchar2,
                  p_tname in varchar2,
                  p_rowid in rowid ) return clob
as
    l_clob clob;
    l_id   int;
begin
    select lob_temp_seq.nextval into l_id from dual;

    execute immediate
       'insert into lob_temp (id,c_lob)
        select :id, to_lob( ' || p_cname || ' )
          from ' || p_tname ||
       ' where rowid = :rid '
     using IN l_id, IN p_rowid;

    select c_lob into l_clob from lob_temp where id = l_id ;

    return l_clob;
end;
/

declare
    l_blob    blob;
    l_rowid rowid;
begin
    select rowid into l_rowid from long_raw_table;
    l_blob := to_blob( 'data', 'long_raw_table', l_rowid );
    dbms_output.put_line( dbms_lob.getlength(l_blob) );
    dbms_output.put_line(
         utl_raw.cast_to_varchar2(
             dbms_lob.substr(l_blob,41,1)
                                 )
                        );
end;
/

declare
    l_clob    clob;
    l_rowid rowid;
begin
    select rowid into l_rowid from long_table;
    l_clob := to_clob( 'data', 'long_table', l_rowid );
    dbms_output.put_line( dbms_lob.getlength(l_clob) );
    dbms_output.put_line( dbms_lob.substr(l_clob,41,1) );
end;
/