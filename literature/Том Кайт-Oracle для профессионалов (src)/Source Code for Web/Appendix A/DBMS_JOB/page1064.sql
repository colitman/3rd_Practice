set echo on

drop table send_mail_data;

create table send_mail_data( id        number primary key,
                             sender    varchar2(255),
                             recipient varchar2(255),
                             message   varchar2(4000),
                             senton    date default NULL );

create or replace
PROCEDURE fast_send_mail (p_sender    IN VARCHAR2,
                          p_recipient IN VARCHAR2,
                          p_message   IN VARCHAR2)
as
        l_job   number;
begin
        dbms_job.submit( l_job, 'background_send_mail( JOB );' );
        insert into send_mail_data
        ( id, sender, recipient, message )
        values
        ( l_job, p_sender, p_recipient, p_message );
end;
/

create or replace
procedure background_send_mail( p_job in number )
as
        l_rec   send_mail_data%rowtype;
begin
        select * into l_rec
          from send_mail_data
         where id = p_job;
  
        send_mail( l_rec.sender, l_rec.recipient, l_rec.message );
        update send_mail_data set senton = sysdate where id = p_job;
end;
/

set serveroutput on
declare
        l_start number := dbms_utility.get_time;
begin
        fast_send_mail( 'anyone@outthere.com',
                        'anyone@outthere.com', 'hey there' );
        dbms_output.put_line
        ( round( (dbms_utility.get_time-l_start)/100, 2 ) ||
          ' seconds' );
end;
/
/