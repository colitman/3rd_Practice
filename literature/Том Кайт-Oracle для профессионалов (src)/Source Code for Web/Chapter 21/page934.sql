-- Add our policy to the EMP view.  This associates each of the
-- HR_PREDICATE_PKG functions with the table for each of SELECT/INSERT/
-- UPDATE/DELETE.
-- On INSERT and UPDATE, we set the 'update_check' flag to TRUE.  This
-- is very much like creating a view with the 'CHECK OPTION'.  It
-- ensures data we create in the database is data we can see in
-- the database.

begin
    dbms_rls.add_policy
    ( object_name     => 'EMP',
      policy_name     => 'HR_APP_SELECT_POLICY',
      policy_function => 'HR_PREDICATE_PKG.SELECT_FUNCTION',
      statement_types => 'select' );
end;
/

begin
    dbms_rls.add_policy
    ( object_name       => 'EMP',
      policy_name       => 'HR_APP_UPDATE_POLICY',
      policy_function   => 'HR_PREDICATE_PKG.UPDATE_FUNCTION',
      statement_types   => 'update' ,
      update_check      => TRUE );
end;
/

begin
    dbms_rls.add_policy
    ( object_name      => 'EMP',
      policy_name      => 'HR_APP_INSERT_DELETE_POLICY',
      policy_function  => 'HR_PREDICATE_PKG.INSERT_DELETE_FUNCTION',
      statement_types  => 'insert, delete' ,
      update_check     => TRUE );
end;
/

