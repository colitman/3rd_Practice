set echo on

create or replace
     function enqueue_decode( l_p1 in number ) return varchar2
     as
         l_str varchar2(25);
     begin
         select chr(bitand(l_p1,-16777216)/16777215)||
                chr(bitand(l_p1, 16711680)/65535)  || ' ' ||
                decode( bitand(l_p1, 65535),
                          0, 'No lock',
                          1, 'No lock',
                          2, 'Row-Share',
                          3, 'Row-Exclusive',
                          4, 'Share',
                          5, 'Share Row-Excl',
                          6, 'Exclusive' )
           into l_str
           from dual;
   
         return l_str;
     end;
 /


 select enqueue_decode( 1415053318  ) from dual;
