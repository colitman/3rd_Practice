@connect tkyte/tkyte

create or replace
procedure desc_table( p_tname in varchar2 )
AUTHID CURRENT_USER
as
begin
    dbms_output.put_line('Datatypes for Table ' || p_tname );
    dbms_output.new_line;

    dbms_output.put_line( rpad('Column Name',31) ||
                          rpad('Datatype',20)    ||
                          rpad('Length',11) ||
                          'Nullable' );
    dbms_output.put_line( rpad('-',30,'-') || ' ' ||
                          rpad('-',19,'-') || ' ' ||
                          rpad('-',10,'-') || ' ' ||
                          '--------' );
    for x in
    ( select column_name,
             data_type,
             substr(
             decode( data_type,
                     'NUMBER', decode( data_precision, NULL, NULL,
                         '('||data_precision||','||data_scale||')' ),
                      data_length),1,11) data_length,
             decode( nullable,'Y','null','not null') nullable
        from user_tab_columns
       where table_name = upper(p_tname)
       order by column_id )
    loop
        dbms_output.put_line( rpad(x.column_name,31) ||
                              rpad(x.data_type,20)    ||
                              rpad(x.data_length,11) ||
                              x.nullable );
    end loop;

    dbms_output.put_line( chr(10) || chr(10) ||
                         'Indexes on ' || p_tname );

    for z in
    ( select a.index_name, a.uniqueness
        from user_indexes a
       where a.table_name = upper(p_tname)
         and index_type = 'NORMAL' )
    loop
        dbms_output.put( rpad(z.index_name,31) ||
                              z.uniqueness );
        for y in
        ( select decode(column_position,1,'(',', ')||
                                       column_name column_name
            from user_ind_columns b
           where b.index_name = z.index_name
           order by column_position )
        loop
            dbms_output.put( y.column_name );
        end loop;
        dbms_output.put_line( ')' || chr(10) );
    end loop;

end;
/

grant execute on desc_table to public
/

@connect scott/tiger
set serveroutput on format wrapped
exec tkyte.desc_table( 'emp' )
