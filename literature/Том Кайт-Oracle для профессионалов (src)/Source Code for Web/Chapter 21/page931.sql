@connect tkyte/tkyte

create or replace package hr_predicate_pkg
as
   function select_function( p_schema in varchar2,
                    p_object in varchar2 ) return varchar2;

   function update_function( p_schema in varchar2,
                    p_object in varchar2 ) return varchar2;

   function insert_delete_function( p_schema in varchar2,
                       p_object in varchar2 ) return varchar2;
end;
/


create or replace package body hr_predicate_pkg
as

g_app_ctx constant varchar2(30) default 'Hr_App_Ctx';

g_sel_pred     varchar2(1024) default NULL;
g_upd_pred     varchar2(1024) default NULL;
g_ins_del_pred varchar2(1024) default NULL;


function select_function( p_schema in varchar2,
                          p_object in varchar2) return varchar2
is
begin

     if ( g_sel_pred is NULL )
     then
         if ( sys_context( g_app_ctx, 'RoleName' ) = 'EMP' )
         then
           g_sel_pred:= 
               'empno=sys_context('''||g_app_ctx||''',''EmpNo'')';
         elsif ( sys_context( g_app_ctx, 'RoleName' ) = 'MGR' )
         then
            g_sel_pred :=
             'empno in ( select empno
                   from emp_base_table
                  start with empno =
                         sys_context('''||g_app_ctx||''',''EmpNo'')
                connect by prior empno = mgr)';

         elsif ( sys_context( g_app_ctx, 'RoleName' ) = 'HR_REP' )
         then
            g_sel_pred := 'deptno in
                     ( select deptno
                         from hr_reps
                        where username =
                          sys_context('''||g_app_ctx||''',''UserName'') )';

         else
            raise_application_error( -20005, 'No Role Set' );
         end if;
     end if;

     return g_sel_pred;
end;

function update_function( p_schema in varchar2,
                          p_object in varchar2 ) return varchar2
is
begin
     if ( g_upd_pred is NULL )
     then
         if ( sys_context( g_app_ctx, 'RoleName' ) = 'EMP' )
         then
             g_upd_pred := '1=0';

         elsif ( sys_context( g_app_ctx, 'RoleName' ) = 'MGR' )
         then
             g_upd_pred :=
                ' empno in ( select empno
                               from emp_base_table
                              where mgr =
                              sys_context('''||g_app_ctx||
                                          ''',''EmpNo'') )';

         elsif ( sys_context( g_app_ctx, 'RoleName' ) = 'HR_REP' )
         then
            g_upd_pred := 'deptno in
                     ( select deptno
                         from hr_reps
                        where username =
                          sys_context('''||g_app_ctx||''',''UserName'') )';

         else
             raise_application_error( -20005, 'No Role Set' );
         end if;
     end if;

     return g_upd_pred;
end;

function insert_delete_function( p_schema in varchar2,
                      p_object in varchar2) return varchar2
is
begin
     if ( g_ins_del_pred is NULL )
     then
         if ( sys_context(g_app_ctx, 'RoleName' ) in ( 'EMP', 'MGR' ) )
         then
            g_ins_del_pred := '1=0';
         elsif ( sys_context( g_app_ctx, 'RoleName' ) = 'HR_REP' )
         then
            g_upd_pred := 'deptno in
                  ( select deptno
                      from hr_reps
                     where username =
                 sys_context('''||g_app_ctx||''',''UserName'') )';
         else
            raise_application_error( -20005, 'No Role Set' );
         end if;
     end if;
     return g_ins_del_pred;
end;

end;
/
