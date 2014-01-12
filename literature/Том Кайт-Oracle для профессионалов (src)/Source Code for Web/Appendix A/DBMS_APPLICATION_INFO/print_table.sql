begin
   print_table( 'select b.*
                   from v$session a, v$session_longops b
                  where a.sid = b.sid
                    and a.serial# = b.serial#' );
end;
/