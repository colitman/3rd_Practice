set echo on
     
     
     declare
         l_number number;
     begin
         for i in 1 .. 10000
         loop
             l_number := dbms_random.random;
   
             insert into t
                     values( l_number, l_number, l_number, l_number );
         end loop;
         commit;
     end;
/



     declare
         l_number number;
     begin
         for i in 1 .. 10000
         loop
             l_number := dbms_random.random;
   
             execute immediate
             'insert into t values ( :x1, :x2, :x3, :x4 )'
                     using l_number, l_number, l_number, l_number;
         end loop;
         commit;
     end;
/