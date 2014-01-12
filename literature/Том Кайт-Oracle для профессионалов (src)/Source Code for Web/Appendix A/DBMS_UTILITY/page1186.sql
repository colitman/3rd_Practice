set echo on
set serverout on

declare
    type vcArray is table of varchar2(30);
    l_types vcArray := vcArray( null, null, null, null, 'synonym',
                                null, 'procedure', 'function',
                               'package' );

    l_schema   varchar2(30);
    l_part1    varchar2(30);
    l_part2    varchar2(30);
    l_dblink   varchar2(30);
    l_type     number;
    l_obj#     number;
begin
  dbms_utility.name_resolve( name => 'DBMS_UTILITY',
                             context       => 1,
                             schema        => l_schema,
                             part1         => l_part1,
                             part2         => l_part2,
                             dblink        => l_dblink,
                             part1_type    => l_type,
                             object_number => l_obj# );
  if l_obj# IS NULL
  then
    dbms_output.put_line('Object not found or not valid.');
  else
    dbms_output.put( l_schema || '.' || nvl(l_part1,l_part2) );
    if l_part2 is not null and l_part1 is not null
    then
        dbms_output.put( '.' || l_part2 );
    end if;

    dbms_output.put_line( ' is a ' || l_types( l_type ) ||
                          ' with object id ' || l_obj# ||
                          ' and dblink "' || l_dblink || '"' );
  end if;
end;
/

select owner, object_name
from all_objects
where object_id = 2408;