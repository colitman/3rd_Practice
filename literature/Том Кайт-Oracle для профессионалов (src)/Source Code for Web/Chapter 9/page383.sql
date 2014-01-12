create or replace 
function my_to_date( p_string in varchar2 ) return date
as
    type fmtArray is table of varchar2(25);

    l_fmts  fmtArray := fmtArray( 'dd-mon-yyyy', 'dd-month-yyyy', 
                                  'dd/mm/yyyy',
                                  'dd/mm/yyyy hh24:mi:ss' );
    l_return date;
begin
    for i in 1 .. l_fmts.count 
    loop
        begin
            l_return := to_date( p_string, l_fmts(i) );
        exception    
            when others then null;
        end;
        EXIT when l_return is not null;
    end loop;

    if ( l_return is null ) 
    then
        l_return := 
           new_time( to_date('01011970','ddmmyyyy') + 1/24/60/60 *  
                     p_string, 'GMT', 'EST' );
    end if;

    return l_return;
end;
/
    
