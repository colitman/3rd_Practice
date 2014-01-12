
host cls

create or replace package body demo_passing_pkg
as

    procedure pass(  p_in    in  number,
                     p_out   out number )
    as
    language C                              
    name "pass_number"                     
    library demoPassing                   
    with context                         
    parameters (                        
                 CONTEXT,              
                 p_in  OCINumber,     
                 p_in  INDICATOR short,    
                 p_out  OCINumber,        
                 p_out  INDICATOR short ); 

     --void pass_number
     --  (
     -- OCIExtProcContext  * ,  /*   1 : With-Context  */
     --         OCINumber  * ,  /*   2 : P_IN  */
     --             short    ,  /*   3 : P_IN (Indicator) */
     --         OCINumber  * ,  /*   4 : P_OUT  */
     --             short  *    /*   5 : P_OUT (Indicator) */ 
     --  );

    procedure pass( p_in in date, p_out out date )
    as 
    language C name "pass_date" library demoPassing
    with context parameters 
    ( CONTEXT,
      p_in   OCIDate, p_in   INDICATOR short,
      p_out  OCIDate, p_out  INDICATOR short );

     -- void pass_date
     --   (
     --  OCIExtProcContext  *,  /*   1 : With-Context  */
     --            OCIDate  *,  /*   2 : P_IN  */
     --              short   ,  /*   3 : P_IN (Indicator) */
     --            OCIDate  *,  /*   4 : P_OUT  */
     --              short  *   /*   5 : P_OUT (Indicator) */ 
     --   );


    procedure pass(  p_in in varchar2, p_out  out  varchar2 )
    as 
    language C name "pass_str" library demoPassing
    with context parameters 
    ( CONTEXT,
      p_in   STRING, p_in  INDICATOR short,
      p_out  STRING, p_out INDICATOR short, p_out  MAXLEN int );

     -- void pass_str
     --   (
     --  OCIExtProcContext  *,  /*   1 : With-Context  */
     --               char  *,  /*   2 : P_IN  */
     --              short   ,  /*   3 : P_IN (Indicator) */
     --               char  *,  /*   4 : P_OUT  */
     --              short  *,  /*   5 : P_OUT (Indicator) */
     --                int  *   /*   6 : P_OUT (Maxlen) */
     --   );


    procedure pass( p_in in boolean, p_out out boolean )
    as 
    language C name "pass_bool" library demoPassing
    with context parameters 
    ( CONTEXT,
      p_in  int, p_in  INDICATOR short,
      p_out int, p_out INDICATOR short );

     -- void pass_bool
     --   (
     --  OCIExtProcContext  *,  /*   1 : With-Context  */
     --                int   ,  /*   2 : P_IN  */
     --              short   ,  /*   3 : P_IN (Indicator) */
     --                int  *,  /*   4 : P_OUT  */
     --              short  *   /*   5 : P_OUT (Indicator) */
     --   );



    procedure pass( p_in in clob, p_out in out clob )
    as 
    language C name "pass_clob" library demoPassing
    with context parameters 
    ( CONTEXT,
      p_in   OCILobLocator, p_in   INDICATOR short,
      p_out  OCILobLocator, p_out  INDICATOR short );

     -- void pass_clob
     --   (
     --  OCIExtProcContext  *,  /*   1 : With-Context  */
     --      OCILobLocator  *,  /*   2 : P_IN  */
     --              short   ,  /*   3 : P_IN (Indicator) */
     --      OCILobLocator **,  /*   4 : P_OUT  */
     --              short  *   /*   5 : P_OUT (Indicator) */
     --   );

    procedure pass( p_in in numArray, p_out out numArray )
    as
    language C name "pass_numArray" library demoPassing
    with context parameters 
    ( CONTEXT, 
      p_in  OCIColl, p_in  INDICATOR short,
      p_out OCIColl, p_out INDICATOR short );
   
     -- void pass_numArray
     --   (
     --  OCIExtProcContext  *,  /*   1 : With-Context  */
     --            OCIColl  *,  /*   2 : P_IN  */
     --              short   ,  /*   3 : P_IN (Indicator) */
     --            OCIColl **,  /*   4 : P_OUT  */
     --              short  *   /*   5 : P_OUT (Indicator) */
     --   );
 
    procedure pass( p_in in dateArray, p_out out dateArray )
    as
    language C name "pass_dateArray" library demoPassing
    with context parameters 
    ( CONTEXT, 
      p_in  OCIColl, p_in  INDICATOR short,
      p_out OCIColl, p_out INDICATOR short );
   
    procedure pass( p_in in strArray, p_out out strArray )
    as
    language C name "pass_strArray" library demoPassing
    with context parameters 
    ( CONTEXT, 
      p_in  OCIColl, p_in  INDICATOR short,
      p_out OCIColl, p_out INDICATOR short );

 
    procedure pass_raw(  p_in in raw, p_out out raw )
    as 
    language C name "pass_long_raw " library demoPassing
    with context parameters 
    ( CONTEXT,
      p_in  RAW, p_in  INDICATOR short, p_in  LENGTH  int,
      p_out RAW, p_out INDICATOR short, p_out MAXLEN int, p_out LENGTH int );

     -- void pass_long_raw
     --   (
     --  OCIExtProcContext  *,  /*   1 : With-Context  */
     --      unsigned char  *,  /*   2 : P_IN  */
     --              short   ,  /*   3 : P_IN (Indicator) */
     --                int   ,  /*   4 : P_IN (Length) */
     --      unsigned char  *,  /*   5 : P_OUT  */
     --              short  *,  /*   6 : P_OUT (Indicator) */
     --                int  *,  /*   7 : P_OUT (Maxlen) */
     --                int  *   /*   8 : P_OUT (Length) */
     --   );

    procedure pass_int(  p_in in binary_integer, p_out out binary_integer )
    as 
    language C name "pass_int" library demoPassing
    with context parameters 
    ( CONTEXT,
      p_in  int, p_in  INDICATOR short,
      p_out int, p_out INDICATOR short );

     -- void pass_int
     --   (
     --  OCIExtProcContext  *,  /*   1 : With-Context  */
     --                int   ,  /*   2 : P_IN  */
     --              short   ,  /*   3 : P_IN (Indicator) */
     --                int  *,  /*   4 : P_OUT  */
     --              short  *   /*   5 : P_OUT (Indicator) */
     --   );



    function return_number return number
    as
    language C name "return_number" library demoPassing
    with context parameters 
    ( CONTEXT, RETURN INDICATOR short, RETURN OCINumber );

     -- OCINumber *return_number
     --   (
     --  OCIExtProcContext  *,  /*   1 : With-Context  */
     --              short  *   /*   2 : RETURN (Indicator) */
     --   );

    function return_date return date
    as
    language C name "return_date" library demoPassing
    with context parameters 
    ( CONTEXT, RETURN INDICATOR short, RETURN OCIDate );

     -- OCIDate *return_date
     --   (
     --  OCIExtProcContext  *,  /*   1 : With-Context  */
     --              short  *   /*   2 : RETURN (Indicator) */
     --   );

    function return_string return varchar2
    as
    language C name "return_string" library demoPassing
    with context parameters 
    ( CONTEXT, RETURN INDICATOR short, RETURN LENGTH int, RETURN STRING );

      -- char *return_string
      --   (
      --  OCIExtProcContext  *,  /*   1 : With-Context  */
      --              short  *,  /*   2 : RETURN (Indicator) */
      --                int  *   /*   3 : RETURN (Length) */
      --   );

end demo_passing_pkg;
/

