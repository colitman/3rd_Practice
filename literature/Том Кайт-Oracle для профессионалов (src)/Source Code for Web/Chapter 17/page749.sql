set echo on

select indextype_name, implementation_name
  from user_indextypes;


select library_name, file_spec, dynamic from user_libraries;


select operator_name, number_of_binds from user_operators;


select distinct method_name, type_name from user_method_params order by
type_name;


drop index mytext_idx;


select table_name
  from user_tables
 where table_name like '%MYTEXT%';


create index mytext_idx
on mytext( thetext )
indextype is ctxsys.context
/


select table_name
  from user_tables
 where table_name like '%MYTEXT%';


 desc dr$mytext_idx$i;


 desc dr$mytext_idx$k;


 desc dr$mytext_idx$n;


 desc dr$mytext_idx$r;