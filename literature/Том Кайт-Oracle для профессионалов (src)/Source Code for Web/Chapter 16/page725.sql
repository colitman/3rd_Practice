set echo on

create or replace type vcArray as table of varchar2(400)
/
create or replace type dtArray as table of date
/
create or replace type nmArray as table of number
/

create or replace package load_data
as

procedure dbmssql_array( p_tname     in varchar2,
                         p_arraysize in number default 100,
                         p_rows      in number default 500 );

procedure dbmssql_noarray( p_tname  in varchar2,
                           p_rows   in number default 500 );


procedure native_dynamic_noarray( p_tname  in varchar2,
                                  p_rows   in number default 500 );

procedure native_dynamic_array( p_tname     in varchar2,
                                p_arraysize in number default 100,
                                p_rows      in number default 500 );
end load_data;
/

create or replace package body load_data
as

procedure dbmssql_array( p_tname     in varchar2,
                         p_arraysize in number default 100,
                         p_rows      in number default 500 )
is
    l_stmt      long;
    l_theCursor integer;
    l_status    number;
    l_col1      dbms_sql.number_table;
    l_col2      dbms_sql.date_table;
    l_col3      dbms_sql.varchar2_table;
	l_cnt       number default 0;
begin
    l_stmt := 'insert into ' || p_tname ||
              ' q1 ( a, b, c ) values ( :a, :b, :c )';

    l_theCursor := dbms_sql.open_cursor;
    dbms_sql.parse(l_theCursor, l_stmt, dbms_sql.native);
        /*
         * We will make up data here. When we've made up ARRAYSIZE
         * rows, we'll bulk insert them. At the end of the loop,
         * if any rows remain, we'll insert them as well.
         */
    for i in 1 .. p_rows
    loop
		l_cnt := l_cnt+1;
        l_col1( l_cnt ) := i;
        l_col2( l_cnt ) := sysdate+i;
        l_col3( l_cnt ) := to_char(i);

        if (l_cnt = p_arraysize)
        then
        	dbms_sql.bind_array( l_theCursor, ':a', l_col1, 1, l_cnt );
        	dbms_sql.bind_array( l_theCursor, ':b', l_col2, 1, l_cnt );
        	dbms_sql.bind_array( l_theCursor, ':c', l_col3, 1, l_cnt );
        	l_status := dbms_sql.execute( l_theCursor );
			l_cnt := 0;
        end if;
    end loop;
    if (l_cnt > 0 )
    then
       	dbms_sql.bind_array( l_theCursor, ':a', l_col1, 1, l_cnt );
       	dbms_sql.bind_array( l_theCursor, ':b', l_col2, 1, l_cnt );
       	dbms_sql.bind_array( l_theCursor, ':c', l_col3, 1, l_cnt );
       	l_status := dbms_sql.execute( l_theCursor );
    end if;
    dbms_sql.close_cursor( l_theCursor );
end;

procedure dbmssql_noarray( p_tname     in varchar2,
                           p_rows      in number default 500 )
is
    l_stmt      long;
    l_theCursor integer;
    l_status    number;
begin
    l_stmt := 'insert into ' || p_tname ||
              ' q2 ( a, b, c ) values ( :a, :b, :c )';

    l_theCursor := dbms_sql.open_cursor;
    dbms_sql.parse(l_theCursor, l_stmt, dbms_sql.native);
        /*
         * We will make up data here. When we've made up ARRAYSIZE
         * rows, we'll bulk insert them. At the end of the loop,
         * if any rows remain, we'll insert them as well.
         */
    for i in 1 .. p_rows
    loop
        dbms_sql.bind_variable( l_theCursor, ':a', i );
        dbms_sql.bind_variable( l_theCursor, ':b', sysdate+i );
        dbms_sql.bind_variable( l_theCursor, ':c', to_char(i) );
        l_status := dbms_sql.execute( l_theCursor );
    end loop;
    dbms_sql.close_cursor( l_theCursor );
end;

procedure native_dynamic_noarray( p_tname  in varchar2,
                                  p_rows   in number default 500 )
is
begin
        /*
         * Here, we simply make up a row and insert it.
         * A trivial amount of code to write and execute.
         */
    for i in 1 .. p_rows
    loop
        execute immediate
              'insert into ' || p_tname ||
              ' q3 ( a, b, c ) values ( :a, :b, :c )'
        using i, sysdate+i, to_char(i);
    end loop;
end;

procedure native_dynamic_array( p_tname     in varchar2,
                                p_arraysize in number default 100,
                                p_rows      in number default 500 )
is
    l_stmt      long;
    l_theCursor integer;
    l_status    number;
    l_col1      nmArray := nmArray();
    l_col2      dtArray := dtArray();
    l_col3      vcArray := vcArray();
	l_cnt       number  := 0;
begin
        /*
         * We will make up data here. When we've made up ARRAYSIZE
         * rows, we'll bulk insert them. At the end of the loop,
         * if any rows remain, we'll insert them as well.
         */
	l_col1.extend( p_arraysize );
	l_col2.extend( p_arraysize );
	l_col3.extend( p_arraysize );
    for i in 1 .. p_rows
    loop
		l_cnt := l_cnt+1;
        l_col1( l_cnt ) := i;
        l_col2( l_cnt ) := sysdate+i;
        l_col3( l_cnt ) := to_char(i);

        if (l_cnt = p_arraysize)
        then
			execute immediate
			'begin
		    	forall i in 1 .. :n
			   	insert into ' || p_tname || ' 
               	q4 ( a, b, c ) values ( :a(i), :b(i), :c(i) );
		 	end;'
			USING l_cnt, l_col1, l_col2, l_col3;
			l_cnt := 0;
        end if;
    end loop;
    if (l_cnt > 0 )
    then
		execute immediate
		'begin
	    	forall i in 1 .. :n
		   	insert into ' || p_tname || ' 
              	q4 ( a, b, c ) values ( :a(i), :b(i), :c(i) );
	 	end;'
		USING l_cnt, l_col1, l_col2, l_col3;
    end if;
end;

end load_data;
/

drop table t;

create table t ( a int, b date, c varchar2(15) );

alter session set sql_trace=true;
truncate table t;
exec load_data.dbmssql_array( 't', 50, 10000 );

truncate table t;
exec load_data.native_dynamic_array( 't', 50, 10000 );

truncate table t;
exec load_data.dbmssql_noarray( 't', 10000 )

truncate table t;
exec load_data.native_dynamic_noarray( 't', 10000 )