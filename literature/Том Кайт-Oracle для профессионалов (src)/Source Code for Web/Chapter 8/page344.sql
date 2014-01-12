set echo on
set serveroutput on


drop view modified_a_column;


drop view dropped_a_column;


rename dropped_a_column_TEMP to dropped_a_column;


rename modified_a_column_TEMP to modified_a_column;
/