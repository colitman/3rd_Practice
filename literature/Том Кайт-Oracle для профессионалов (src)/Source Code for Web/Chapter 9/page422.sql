drop table badlog;

create table badlog( errm varchar2(4000), 
                     data varchar2(4000) );

create or replace
function  load_data( p_table     in varchar2,
                     p_cnames    in varchar2,
                     p_dir       in varchar2,
                     p_filename  in varchar2,
                     p_delimiter in varchar2 default '|' )
return number
is
    l_input         utl_file.file_type;
    l_theCursor     integer default dbms_sql.open_cursor;
    l_buffer        varchar2(4000);
    l_lastLine      varchar2(4000);
    l_status        integer;
    l_colCnt        number default 0;
    l_cnt           number default 0;
    l_sep           char(1) default NULL;
    l_errmsg        varchar2(4000);
begin
        /*
         * This will be the file we read the data from.
         * We are expecting simple delimited data.
         */
    l_input := utl_file.fopen( p_dir, p_filename, 'r', 4000 );

    l_buffer := 'insert into ' || p_table || 
                '(' || p_cnames || ') values ( ';
        /*
         * This counts commas by taking the current length
         * of the list of column names, subtracting the
         * length of the same string with commas removed, and
         * adding 1.
         */
    l_colCnt := length(p_cnames)-
                  length(replace(p_cnames,',',''))+1;

    for i in 1 .. l_colCnt
    loop
        l_buffer := l_buffer || l_sep || ':b'||i;
        l_sep    := ',';
    end loop;
    l_buffer := l_buffer || ')';

        /*
         * We now have a string that looks like:
         * insert into T ( c1,c2,... ) values ( :b1, :b2, ... )
         */
    dbms_sql.parse(  l_theCursor, l_buffer, dbms_sql.native );

    loop
       /*
        * Read data and exit when there is no more.
        */
        begin
            utl_file.get_line( l_input, l_lastLine );
        exception
            when NO_DATA_FOUND then
                exit;
        end;
        /*
         * It makes it easy to parse when the line ends
         * with a delimiter.
         */
        l_buffer := l_lastLine || p_delimiter;


        for i in 1 .. l_colCnt
        loop
            dbms_sql.bind_variable( l_theCursor, ':b'||i,
                            substr( l_buffer, 1,
                                instr(l_buffer,p_delimiter)-1 ) );
            l_buffer := substr( l_buffer,
                          instr(l_buffer,p_delimiter)+1 );
        end loop;

        /*
         * Execute the insert statement. In the event of an error
         * put it into the "bad" file.
         */
        begin
            l_status := dbms_sql.execute(l_theCursor);
            l_cnt := l_cnt + 1;
        exception
            when others then
                l_errmsg := sqlerrm;
                insert into badlog ( errm, data )
                values ( l_errmsg, l_lastLine );
        end;
    end loop;

    /*
     * close up and commit
     */
    dbms_sql.close_cursor(l_theCursor);
    utl_file.fclose( l_input );
    commit;

    return l_cnt;
exception
	when others then
    	dbms_sql.close_cursor(l_theCursor);
		if ( utl_file.is_open( l_input ) ) then
			utl_file.fclose(l_input);
		end if;
		RAISE;
end load_data;
/

drop table t1;
create table t1 ( x int, y int, z int );

host echo 1,2,3 > c:\temp\t1.dat
host echo 4,5,6 >> c:\temp\t1.dat
host echo 7,8,9 >> c:\temp\t1.dat
host echo 7,NotANumber,9 >> c:\temp\t1.dat

begin
   dbms_output.put_line(
       load_data( 'T1',
                  'x,y,z',
                  'c:\temp',
                  't1.dat',
                  ',' ) || ' rows loaded' );
end;
/

select * from badlog;

select * from t1;

