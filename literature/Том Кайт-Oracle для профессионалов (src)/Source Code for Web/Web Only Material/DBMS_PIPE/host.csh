#!/bin/csh -f

#
# If the first argument is supplied, then this is the
# name of the pipe on which to write the answer back to the client.
# The answer they are waiting for is in the file
# $$.dat - $$ will be the pid (process id) of our csh
# script. We use EXEC to ensure the pid stays the same
# from call to call.

if ( "$1" != "" ) then

    #
    # If we get here, we will get the 'head' or beginning
    # of our result. We'll send just enough back so the client
    # can get the gist of our success or failure.
    #
    set x="`head $$.dat | sed s/\'/\'\'/g`"

    #
    # We are going to use SQL*PLUS only to interact with
    # the database. Here, we will feed SQL*PLUS a script
    # inline. We want the $x and $1 to be 'replaced' with
    # the corresponding environment variables, so we redirect
    # in from EOF. Later, we don't want this replacement
    # so we use 'EOF'.
    #
    # In this block of code, we simply write out the result
    # and send it on the pipe the client asked us to. The
    # pipe name is carried along as a parameter to this script.
    #
    # Note how to use CURSOR_SHARING=FORCE to make use of
    # bind variables. Since cursor sharing does not happen inside
    # of PL/SQL, we use a temporary table and insert our 'parameters'
    # into the temp table. PL/SQL reads those values out. This ensures
    # we do not overload our shared pool with all of the
    # character string literals we would otherwise. You need to have issued
    # create global temporary table host_tmp(msg varchar2(4000), pipe
    # varchar2(255) ); prior to executing this script.
    #
    SQL*PLUS / <<EOF
    alter session set cursor_sharing=force;
    insert into host_tmp (msg,pipe) values ( '$x','$1' );
    declare
        status      number;
        l_msg       varchar2(4000);
        l_pipe      varchar2(255);
    begin
        select msg, pipe into l_msg, l_pipe from host_tmp;
        dbms_pipe.pack_message( l_msg );
        status := dbms_pipe.send_message( l_pipe);
        if ( status <> 0 )
        then
          raise_application_error( -20001, 'Pipe error' );
        end if;
    end;
/
EOF

endif

#
# Now we go into 'server' mode. We will run and wait
# for something to be written on the pipe to us. We
# start by creating a private pipe. If one already exists,
# this does nothing. If one does not exist, the 'server' creates
# a private pipe for us.
#
# Then, we block indefinitely in received message, waiting for
# a request.
#
# Then we get the components of the message. Ours has 2 pieces:
# - the pipe to write back on
# - the command to execute
# We simply echo this out using dbms_output. If we receive
# any sort of timeout or error, we write out 'exit' which will
# cause us to exit.
#
# The command we run, SQL*PLUS / .... > tmp.csh is set up to do the
# following:
# SQL*PLUS /  -> run SQL*PLUS
# <<"EOF"     -> get the input inline, 'EOF' means don't do shell expansions
# | grep '^#' -> we'll keep only lines that begin with #
# | sed 's/^.//' -> get rid of that # in the real script
# > tmp.csh -> put that output from SQL*PLUS into tmp.csh
#
SQL*PLUS / <<"EOF" | grep '^#' | sed 's/^.//' > tmp.csh

set serveroutput on

whenever sqlerror exit

declare
        status      number;
        answer_pipe varchar2(255);
        command     varchar2(255);
begin
        status := dbms_pipe.create_pipe( pipename => 'HOST_PIPE',
                                         private  => TRUE );

        status := dbms_pipe.receive_message( 'HOST_PIPE');
        if ( status <> 0 ) then
                dbms_output.put_line( '#exit' );
        else
                dbms_pipe.unpack_message( answer_pipe );
                dbms_pipe.unpack_message( command );
                dbms_output.put_line( '##!/bin/csh -f' );
                dbms_output.put_line( '#' || command );
                dbms_output.put_line( '#exec host.csh ' || answer_pipe );
        end if;
end;
/
spool off
"EOF"

#
# Lastly, we make the script we just created executable
# and run it. We use EXEC in order to reuse the same pid.
# The last line in tmp.csh always re-runs this script using
# exec host.csh so we are in a loop of sorts...
#
chmod +x tmp.csh
exec tmp.csh >& $$.dat