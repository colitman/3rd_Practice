set echo on

create or replace type myScalarType
as object
( key  varchar2(4000),
  val  varchar2(4000)
);
/

create or replace type myArrayType
as varray(10000) of myScalarType;
/

create or replace type hashTableType
as object
(
    g_hash_size     number,
    g_hash_table    myArrayType,
    g_collision_cnt number,

    static function new( p_hash_size in number )
        return hashTableType,

    member procedure put( p_key in varchar2,
                          p_val in varchar2 ),

    member function get( p_key in varchar2 )
       return varchar2,

    member procedure print_stats
);
/

create or replace type body hashTableType
as

-- Our 'friendly' constructor.

static function new( p_hash_size in number )
return hashTableType
is
begin
    return hashTableType( p_hash_size, myArrayType(), 0 );
end;

member procedure put( p_key in varchar2, p_val in varchar2 )
is
    l_hash  number :=
            dbms_utility.get_hash_value( p_key, 1, g_hash_size );
begin

	if ( p_key is null ) 
	then
		raise_application_error( -20001, 'Cannot have NULL key' );
	end if;

    -- See if we need to 'grow' the table to hold
    -- this new hashed value. If we do, we grow
    -- it out big enough to hold this index.
    if ( l_hash > nvl( g_hash_table.count, 0 ) )
    then
        g_hash_table.extend( l_hash-nvl(g_hash_table.count,0)+1 );
    end if;

    -- We'll try 1000 times to put it into the table. If
    -- we hit 1000 collisions, we will fail. The table is
    -- not sized properly if this is the case.
    for i in 0 .. 1000
    loop
        -- If we are going to go past the end of the
        -- table, add another slot first.
        if ( g_hash_table.count <= l_hash+i )
        then
            g_hash_table.extend;
        end if;

        -- If no one is using this slot OR our key is in
        -- this slot already, use it and return.
        if ( g_hash_table(l_hash+i) is null OR
             nvl(g_hash_table(l_hash+i).key,p_key) = p_key )
        then
            g_hash_table(l_hash+i) := myScalarType(p_key,p_val);
            return;
        end if;

        -- Else increment a collision count and continue
        -- onto the next slot.
        g_collision_cnt := g_collision_cnt+1;
    end loop;

    -- If we get here, the table was allocate too small.
    -- Make it bigger.
    raise_application_error( -20001, 'table overhashed' );
end;


member function get( p_key in varchar2 ) return varchar2
is
    l_hash  number :=
             dbms_utility.get_hash_value( p_key, 1, g_hash_size );
begin
    -- Just look for our value. We never look more
    -- than 1000 ahead.
    for i in l_hash .. least(l_hash+1000, nvl(g_hash_table.count,0))
    loop
        -- If we hit an EMPTY slot, we KNOW our value cannot
        -- be in the table. We would have put it there.
        if ( g_hash_table(i) is NULL )
        then
            return NULL;
        end if;

        -- If we find our key, return the value.
        if ( g_hash_table(i).key = p_key )
        then
            return g_hash_table(i).val;
        end if;
    end loop;

    -- Key is not in the table. Quit.
    return null;
end;

--
-- Useful information to see how many
-- slots you've allocated, used, and how
-- many collisions we had. Note that
-- collisions can be bigger then the table itself!
--
member procedure print_stats
is
    l_used number default 0;
begin
    for i in 1 .. nvl(g_hash_table.count,0)
    loop
        if ( g_hash_table(i) is not null )
        then
            l_used := l_used + 1;
        end if;
    end loop;

    dbms_output.put_line( 'Table Extended To.....' ||
                           g_hash_table.count );
    dbms_output.put_line( 'We are using..........' ||
                           l_used );
    dbms_output.put_line( 'Collision count put...' ||
                           g_collision_cnt );
end;

end;
/

declare
    l_hashTbl hashTableType := hashTableType.new(power(2,7));
begin
    for x in ( select username, created from all_users )
    loop
        l_hashTbl.put( x.username, x.created );
    end loop;

    for x in ( select username, to_char(created) created,
                      l_hashTbl.get(username) hash
                 from all_users )
    loop
        if ( nvl( x.created, 'x') <> nvl(x.hash,'x') )
        then
            raise program_error;
        end if;
    end loop;

    l_hashTbl.print_stats;
end;
/