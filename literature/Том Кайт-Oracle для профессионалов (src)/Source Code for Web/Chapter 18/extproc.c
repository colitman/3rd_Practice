#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <time.h>
#include <string.h>
#include <errno.h>
#include <ctype.h>

#include <oci.h>

#ifdef WIN_NT
#define INI_FILE_NAME "c:\\temp\\extproc.ini"
#else
#define INI_FILE_NAME "/export/home/tkyte/src/demo_passing/extproc.ini"
#endif

#define strupr(a) {char * cp; for(cp=a;*cp;*cp=toupper(*cp), cp++);}

/*
 * This is our "context".  It holds what normally might be global variables
 * in a typical program.  We cannot (should not) use global variables in an
 * external procedure.  Also, since static data will be reinitialized
 * between calls -- globals would not work correct anyway.  We will use the
 * OCI context management API calls to get and set a global context for 
 * our extproc.  You would add any state variables you needed to preserve
 * from call to call in this structure below.
 *
 * the debugf_* variables are initialized from a parameter file.  In our
 * init() routine, we will read the parameter file and set these values.
 * you may add your own parameters to this structure as well and set them
 * in init() as I do.
 *
 * curr_lineno and curr_filename are set by the debugf macro below so when
 * we create a trace file, I can tell you what line number and source code
 * file a message was generated from
 *
 */

typedef struct myCtx 
{ 
  OCIExtProcContext * ctx;		/* Context passed to all external procs */
  OCIEnv *            envhp;    /* OCI environment handle */
  OCISvcCtx *         svchp;    /* OCI Service handle */
  OCIError *          errhp;    /* OCI Error handle */

  int                 curr_lineno;
  char *              curr_filename;

  ub1                 debugf_flag;
  char                debugf_path[255];
  char                debugf_filename[50];

  /* add your own state variables here... */
}    
    myCtxStruct;


/*
 * Here is the implementation of our "debugf" routine.  It is used to 
 * instrument the code and aid in debugging runtime issues.  
 * 
 * It works much like the C printf function (well, exactly like it)
 * in that you send a C format and then a varying number of arguments
 * to be formatted and printed.  We add to it the Year, Month, Day,
 * Hour, Minute, Second in GMT to each trace record as well as the name
 * of the C source code file and the line number.
 *
 * Note that in order to be as OS independent as possible, we use the 
 * OCI API's to write to files.  The File API's are expected to have
 * been initialized in the init() routine alread and will be closed out
 * in the term() routine.
 */

void _debugf( myCtxStruct * myCtx, char * fmt, ... )
{
va_list         ap;
OCIFileObject * fp;
time_t          theTime = time(NULL);
char            msg[8192];
ub4             bytes;

    if ( OCIFileOpen( myCtx->envhp, myCtx->errhp, &fp, 
                      myCtx->debugf_filename,
                      myCtx->debugf_path, 
                      OCI_FILE_WRITE_ONLY, OCI_FILE_APPEND|OCI_FILE_CREATE,
                      OCI_FILE_TEXT ) != OCI_SUCCESS ) return;

    strftime( msg, sizeof(msg), 
             "%y%m%d %H%M%S GMT ", gmtime(&theTime) );
    OCIFileWrite( myCtx->envhp, myCtx->errhp, fp, msg, strlen(msg), &bytes );

    va_start(ap,fmt);
    vsprintf( msg, fmt, ap );
    va_end(ap);
    strcat( msg,"\n");

    OCIFileWrite( myCtx->envhp, myCtx->errhp, fp, msg, strlen(msg), &bytes );
    OCIFileClose( myCtx->envhp, myCtx->errhp, fp );
}

/*
 * this macro is a more convienent way to use debugf. Instead of have
 * to pass the __LINE__, __FILE__ each time we call -- we just code:
 *
 *     debugf( myCtx, "This is some format %s", some_string );
 *
 * and this macro will set them in our context and then call _debugf for us.
 *
 */
void _debugf( myCtxStruct * myCtx, char * fmt, ... );
#define debugf  \
if ((myCtx!=NULL) && (myCtx->debugf_flag)) \
    myCtx->curr_lineno = __LINE__, \
    myCtx->curr_filename = __FILE__, \
    _debugf 


/*
 * This routine works like the PLSQL builtin by the same name.  It 
 * sets an application defined error message and error code.  It also
 * works like the C printf routine in that you pass to it a C format
 * string and then a varying number of arguments
 *
 * The resulting string is limited to 8k in size.  Note the call
 * to debugf.  Debugf is the macro above, we will use it throughout
 * the code to 'instrument' it.  
 */

static int raise_application_error(  myCtxStruct * myCtx,
                                     int           errCode, 
                                     char *        errMsg, ...)
{
char    msg[8192];
va_list ap;

    va_start(ap,errMsg);
    vsprintf( msg, errMsg, ap );
    va_end(ap);

    debugf( myCtx,  "raise application error( %d, %s )", errCode, msg );
    if ( OCIExtProcRaiseExcpWithMsg(myCtx->ctx,errCode,msg,0) == 
                                                OCIEXTPROC_ERROR )
    {
      debugf( myCtx,  "Unable to raise exception" );
    }
    return -1;
}



/* 
 * This is a convienence routine to allocate storage for an error message
 * and return it.  Note that the type of storage we allocate is CALL based,
 * hence, when we return from the extproc, OCI will automatically free it
 * for us.
 *
 * This routine removes the trailing newline from the error message as well
 */
static char * lastOciError( myCtxStruct * myCtx )
{
sb4       errcode;
char      * errbuf = (char*)OCIExtProcAllocCallMemory( myCtx->ctx, 256 );

    strcpy( errbuf, "unable to retrieve message\n" );
    OCIErrorGet( myCtx->errhp, 1, NULL, &errcode, errbuf, 
                 255, OCI_HTYPE_ERROR );
    errbuf[strlen(errbuf)-1] = 0;
    return errbuf;
}

/*
 * Here is the init routine.  This routine must be called very early 
 * in the execution of any external procedure using this template.  It
 * will 
 *   o retrieve the OCI handles and set them in the context for us
 *   o retrieve our CONTEXT, if the context has not yet been allocated,
 *     it will allocate storage for our context and save it.  The memory
 *     is allocated to last as long as our process lasts.
 *   o it will read and retrieve the values from the parameter file if
 *     they have not been.  You can add more parameters of your own by:
 *     - adding elements the the myCtxStruct above
 *     - increment the counter sent into ExtractSetNumKeys appropriately
 *     - adding a call to ExtractSetKey
 *     - adding a call to ExtractTo* (string, bool, int, etc)
 *   o it will initialize the FILE apis via OCIFileInit().  This is crucial
 *     for the successful operation of debugf above.
 *
 * You may add other "init" type of calls.  for example, if you choose to 
 * use the String Formatting Interface (similar to vsprintf() but in OCI)
 * You could add a call to OCIFormatInit() here.  You would add the 
 * corresponding OCIFormatTerm() call to term() below.
 *
 */
static myCtxStruct * init( OCIExtProcContext * ctx )
{
ub1          false = 0;
myCtxStruct *myCtx = NULL;
OCIEnv      *envhp;
OCISvcCtx   *svchp;
OCIError    *errhp;
ub4          key = 1;


    if ( OCIExtProcGetEnv( ctx, &envhp, &svchp, &errhp ) != OCI_SUCCESS )
    {
         OCIExtProcRaiseExcpWithMsg(ctx,20000,
                                   "failed to get OCI Connection",0);
         return NULL;
    }
    if ( OCIContextGetValue( envhp, errhp, (ub1*)&key, sizeof(key), 
                             (dvoid**)&myCtx ) != OCI_SUCCESS ) 
    {
        OCIExtProcRaiseExcpWithMsg(ctx,20000,"failed to get OCI Context",0);
        return NULL;
    }
 
    if ( myCtx == NULL )
    {
        if ( OCIMemoryAlloc( envhp, errhp, (dvoid**)&myCtx, 
                             OCI_DURATION_PROCESS, 
                             sizeof(myCtxStruct), 
                             OCI_MEMORY_CLEARED ) != OCI_SUCCESS )
        {
            OCIExtProcRaiseExcpWithMsg(ctx,20000,
                                      "failed to get OCI Memory",0);
            return NULL;
        }
        myCtx->ctx   = ctx;
        myCtx->envhp = envhp;
        myCtx->svchp = svchp;
        myCtx->errhp = errhp;
        if ( OCIContextSetValue( envhp, errhp, 
                                 OCI_DURATION_SESSION, (ub1*)&key, 
                                 sizeof(key), myCtx ) != OCI_SUCCESS )
        {
            raise_application_error(myCtx, 20000, "%s", lastOciError(myCtx));
            return NULL;
        }

        if (( OCIExtractInit( envhp, errhp ) != OCI_SUCCESS )  ||
            ( OCIExtractSetNumKeys( envhp, errhp, 3 ) != OCI_SUCCESS ) ||
            ( OCIExtractSetKey( envhp, errhp, "debugf", 
                                OCI_EXTRACT_TYPE_BOOLEAN, 
                                0, &false, NULL, NULL ) != OCI_SUCCESS ) ||
            ( OCIExtractSetKey( envhp, errhp, "debugf_filename", 
                                OCI_EXTRACT_TYPE_STRING, 
                                0, "extproc.log", 
                                NULL, NULL ) != OCI_SUCCESS )  ||
            ( OCIExtractSetKey( envhp, errhp, "debugf_path", 
                                OCI_EXTRACT_TYPE_STRING, 
                                0, "", NULL, NULL ) != OCI_SUCCESS )  ||
            ( OCIExtractFromFile( envhp, errhp, 0, 
                                  INI_FILE_NAME ) != OCI_SUCCESS ) ||
            ( OCIExtractToBool( envhp, errhp, "debugf", 0, 
                                &myCtx->debugf_flag ) != OCI_SUCCESS ) ||
            ( OCIExtractToStr( envhp, errhp, "debugf_filename", 0, 
                               myCtx->debugf_filename,
                               sizeof(myCtx->debugf_filename ) )
                                                     != OCI_SUCCESS ) ||
            ( OCIExtractToStr( envhp, errhp, "debugf_path", 
                               0, myCtx->debugf_path,
                               sizeof(myCtx->debugf_path ) ) 
                                                     != OCI_SUCCESS ) ||
            ( OCIExtractTerm( envhp, errhp ) != OCI_SUCCESS ))
        {
            raise_application_error(myCtx, 20000, "%s", lastOciError(myCtx));
            return NULL;
        }
    }
    else
    {
        myCtx->ctx   = ctx;
        myCtx->envhp = envhp;
        myCtx->svchp = svchp;
        myCtx->errhp = errhp;
    }
    if ( OCIFileInit( myCtx->envhp, myCtx->errhp ) != OCI_SUCCESS ) 
    {
        raise_application_error(myCtx, 20000, "%s", lastOciError(myCtx));
        return NULL;
    }
    return myCtx;
}

/* 
 * This must be called after any successful call to init() above.  It
 * should be the last thing you call in your routine before returning
 * from C to SQL
 */
static void term( myCtxStruct * myCtx )
{
    OCIFileTerm( myCtx->envhp, myCtx->errhp );
}


/* 
 * error codes go here.  Error numbers must be in the range of
 * 20000 to 20999.  Each extproc will register all of their error
 * codes here.  It will make it easier to "pragma EXCEPTION_INIT" them
 * later in the PLSQL code.  This will let plsql programs catch nice 
 * named exceptions
 */

#define ERROR_OCI_ERROR     20001
#define ERROR_STR_TOO_SMALL 20002
#define ERROR_RAW_TOO_SMALL 20003
#define ERROR_CLOB_NULL     20004
#define ERROR_ARRAY_NULL    20005



/*
 * This ifdef is for Windows NT.  It exports each of the 
 * functions/procedures we code which is a requirement of that OS
 */
#ifdef WIN_NT
_declspec (dllexport)
#endif
void pass_number
 ( OCIExtProcContext * ctx       /* CONTEXT */,

   OCINumber *        p_inum     /* OCINUMBER */,
   short              p_inum_i   /* INDICATOR short */,

   OCINumber *        p_onum     /* OCINUMBER */,
   short *            p_onum_i   /* INDICATOR short */ )
{
double     l_inum;
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return;
    debugf( myCtx,  "Enter Pass Number" );
    /*
     * Let's access the first parameter.  We passed as an OCINumber type.
     * We now can use the many OCINumber* functions on it.  In this case, 
     * we'll get the Oracle Number converted into a C DOUBLE using 
     * OCINumberToReal.  We could convert into an Int, Long, Float, 
     * or formatted string just as easily
     *
     * First, we must check to see if the passed Number is NOT NULL, 
     * if so process, else
     * in this case -- do nothing.
     */
    if ( p_inum_i == OCI_IND_NOTNULL )
    {
        /* 
         * Since it is not null, we will convert the number in this
         * case into a C double
         */
        if ( OCINumberToReal( myCtx->errhp, p_inum, sizeof(l_inum), &l_inum ) 
                 != OCI_SUCCESS ) 
        {
            raise_application_error(myCtx,ERROR_OCI_ERROR, 
                                    "%s",lastOciError(myCtx));
        }
        else
        {
            debugf( myCtx,  "The first parameter is %g", l_inum );

            /* 
             * Let's set our first OUT parameter p_onum.  It will be the 
             * negative of whatever we passed in for the first parameter
             */

            l_inum = -l_inum;
            if ( OCINumberFromReal( myCtx->errhp, &l_inum,  
                                    sizeof(l_inum), p_onum) != OCI_SUCCESS ) 
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR,
                                        "%s",lastOciError(myCtx));
            }
            else
            {

                /*
                 * And then we must set this to NOTNULL else the parameter
                 * would be passed back to the caller as a NULL value
                 */
                *p_onum_i = OCI_IND_NOTNULL;

                debugf( myCtx, 
                       "Set OUT parameter to %g and set indicator to NOTNULL", 
                        l_inum );
            }
        }
    }
    term(myCtx);
}



#ifdef WIN_NT
_declspec (dllexport)
#endif
void pass_date
 ( OCIExtProcContext * ctx        /* CONTEXT */,

   OCIDate *          p_idate    /* OCIDATE */,
   short              p_idate_i  /* INDICATOR short */,

   OCIDate *          p_odate    /* OCIDATE */,
   short *            p_odate_i  /* INDICATOR short */
 )
{
/* 
 * Buffer will be used to hold the formatted date string.  buff_len
 * will contain the max lenght/current length of the formatted string
 */
char      buffer[255];
ub4       buff_len;

/*
 * Format we will use for displaying our date in the trace files,
 * could use any valid Oracle format here
 */
char      * fmt = "dd-mon-yyyy hh24:mi:ss";
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return;
    debugf( myCtx,  "Enter Pass Date" );

    /*
     * Now, we'll go after the DATE in parameter, if NOT null
     * if it is NULL, we do nothing
     */
    if ( p_idate_i == OCI_IND_NOTNULL )
    {
        /*
         * Lets get the date that was passed in formatted in a string
         * Buff_len must contain the max length of the buffer we are
         * printing into on the way in. On the way out -- it'll have
         * the length of the formatted string.
         */

        buff_len = sizeof(buffer);
        if ( OCIDateToText( myCtx->errhp, p_idate, fmt, strlen(fmt), 
                            NULL, -1, &buff_len, buffer ) != OCI_SUCCESS )
        {
            raise_application_error(myCtx,ERROR_OCI_ERROR,
                                    "%s",lastOciError(myCtx));
        }
        else
        {

            debugf( myCtx,  "The date input parameter was set to '%.*s'", 
                    buff_len, buffer );

            /*
             * and then the DATE OUT parameter... 
             * start with what we were passed and add a month using
             * the supplied OCI function to do so.
             */
            if ( OCIDateAddMonths( myCtx->errhp, p_idate, 1, p_odate ) 
                     != OCI_SUCCESS ) 
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR, 
                                       "%s",lastOciError(myCtx));
            }
            else
            {
        
                /*
                 * Now, set the indicator to tell the caller the date is no
                 * longer NULL but has a value
                 */
                *p_odate_i = OCI_IND_NOTNULL;
           
                /* 
                 * Lets just verify the date we have now in the trace file
                 */
                buff_len = sizeof(buffer);
                if ( OCIDateToText( myCtx->errhp, p_odate, fmt, 
                                    strlen(fmt), NULL, -1, 
                                    &buff_len, buffer ) != OCI_SUCCESS )
                { 
                    raise_application_error(myCtx,ERROR_OCI_ERROR, 
                                            "%s",lastOciError(myCtx));
                }
                else
                {
                    debugf( myCtx,  
                           "The date output parameter was set to '%.*s'", 
                            buff_len, buffer );
                }
            }
        }
    }
    term(myCtx);
}



/*
 * Passing strings back and forth is a little differnt then
 * Dates and Numbers.  It is a little easier perhaps.  We get normal C
 * Null terminated strings.  On the other hand, we must (as always in
 * C) be mindful of potential buffer overwrites.  Therefore, we always
 * have the extproc pass in the MAXLEN variable with every string that
 * is an IN/OUT or OUT parameter.  Without it -- we would not have any
 * sure way of knowing the max length.
 *
 * Notice the lack of an OCIExtProcGetEnv call -- it is simply not
 * needed for this routine since we are not making any complex
 * OCI calls as we did above.
 */

#ifdef WIN_NT
_declspec (dllexport)
#endif
void pass_str
 ( OCIExtProcContext * ctx        /* CONTEXT */,

   char *             p_istr     /* STRING */,
   short              p_istr_i   /* INDICATOR short */,

   char *             p_ostr     /* STRING */,
   short *            p_ostr_i   /* INDICATOR short */,
   int *              p_ostr_ml  /* MAXLEN int */
 )
{
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return;
    debugf( myCtx,  "Enter Pass Str" );
    /*
     * Now, we will make the output string = upper(input string) 
     * if the output buffer is big enough and 
     */
    if ( p_istr_i == OCI_IND_NOTNULL )
    {
    int     l_istr_l  = strlen(p_istr);

        /* 
         * if the MAXLEN of the output buffer is big enough...
         */
        if ( *p_ostr_ml > l_istr_l )
        {
            /* 
             * copy the string
             * upper case it
             * and set the indicator variable to NOT NULL
             */
            strcpy( p_ostr, p_istr );
            strupr( p_ostr );
            *p_ostr_i = OCI_IND_NOTNULL;
        }
        else
        {
            /* 
             * the output buffer is too small to recieve the string
             * fail the attemp with a nice error message
             */
            raise_application_error( myCtx, ERROR_STR_TOO_SMALL, 
               "output buffer of %d bytes needs to be at least %d bytes",
                *p_ostr_ml, l_istr_l+1 );
        }
    }
    term(myCtx);
}




/* 
 * passing a binary_integer is easy in the same way passing a STRING
 * is, it is a native type of C and no special OCI functions are needed
 * to help us out.  
 * 
 * Here this routine will simply inspect the input value and assign it
 * times 10 to the output variable
 */

#ifdef WIN_NT
_declspec (dllexport)
#endif
void pass_int
 ( OCIExtProcContext * ctx        /* CONTEXT */,

   int                p_iINT     /* int */,
   short              p_iINT_i   /* INDICATOR short */,

   int *              p_oINT     /* int */,
   short *            p_oINT_i   /* INDICATOR short */
 )
{
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return;
    debugf( myCtx,  "Enter Pass Int" );
        
    if ( p_iINT_i == OCI_IND_NOTNULL )
    {
        debugf( myCtx,  "This first INT parameter is %d", p_iINT );

        /*
         * Simply make the assigment and set the indicator variable
         * appropriately
         */
        *p_oINT = p_iINT*10;
        *p_oINT_i = OCI_IND_NOTNULL;

        debugf( myCtx,  "Set the INT out parameter to %d", *p_oINT );
    }
    term(myCtx);
}


/*
 * A PLSQL Boolean will be mapped to a C int in this case.  A value of
 * 1 indicates TRUE and 0 indicates FALSE as you would expect. This
 * routine will simply inspect the INPUT (if not null) and set the
 * output to the negative of the inputs.
 * 
 * Again, since this maps nicely to native C types, this is very easy
 * to code.  No special environment handles or API calls to massage the
 * data.
 */

#ifdef WIN_NT
_declspec (dllexport)
#endif
void pass_bool
 ( OCIExtProcContext * ctx        /* CONTEXT */,

   int                p_ibool    /* int */,
   short              p_ibool_i  /* INDICATOR short */,

   int *              p_obool    /* int */,
   short *            p_obool_i  /* INDICATOR short */ )
{
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return;
    debugf( myCtx,  "Enter Pass Boolean" );

    /* 
     * if the input is not null 
     * then
     *   output = NOT input
     * end if
     */
    if ( p_ibool_i == OCI_IND_NOTNULL )
    {
        *p_obool = !p_ibool;
        *p_obool_i = OCI_IND_NOTNULL;
    }
    term(myCtx);
}



/*
 * Now a raw is a little different.  We need to pass the LENGTH of the
 * raw with the INPUT parameter (it could contain binary zeroes so
 * STRLEN would be out of the question).  Additionally -- on the way
 * out we need to respect the MAXLEN and set the LENGTH value.  In many
 * respects, RAW is like string above with the addition of the LENGTH
 * parameters
 */
#ifdef WIN_NT
_declspec (dllexport)
#endif
void pass_long_raw
 ( OCIExtProcContext * ctx     /* CONTEXT */,

   unsigned char *  p_iraw     /* RAW */,
   short            p_iraw_i   /* INDICATOR short */,
   int              p_iraw_l   /* LENGHT INT */,

   unsigned char *  p_oraw     /* RAW */,
   short *          p_oraw_i   /* INDICATOR short */,
   int *            p_oraw_ml  /* MAXLEN int */, 
   int *            p_oraw_l   /* LENGTH int */
 )
{
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return;
    debugf( myCtx,  "Enter Pass long raw" );
    /* 
     * Now, we will copy the RAW column into the output RAW column 
     * if we can...  (if it fits and if the input is NOT NULL
     */

    if ( p_iraw_i == OCI_IND_NOTNULL )
    {
        if ( p_iraw_l <= *p_oraw_ml )
        {
            /* 
             * copy p_iraw_l bytes from p_iraw to p_oraw 
             */
            memcpy( p_oraw, p_iraw, p_iraw_l );

            /* 
             * Now, set the OUTPUT length and indicator variable
             */
            *p_oraw_l = p_iraw_l; 
            *p_oraw_i = OCI_IND_NOTNULL;
        }
        else
        {
            raise_application_error( myCtx, ERROR_RAW_TOO_SMALL, 
                     "Buffer of %d bytes needs to be %d", 
                      *p_oraw_ml, p_iraw_l );
        }
    }
    else
    {
        /* 
         * set the output length to ZERO and the null indicator to 
         * NULL since our input was null.
         */
        *p_oraw_i = OCI_IND_NULL;
        *p_oraw_l =  0;
    }
    term(myCtx);
}


/*
 * We are demonstrating with a CLOB but a CLOB, BLOB, and BFILE are 
 * treated very much the same.  Here we will simply copy the input CLOB
 * to the output CLOB.  We are back to getting the OCI environment
 * since we are going to make some OCI calls to manipulate the LOB
 */

#ifdef WIN_NT
_declspec (dllexport)
#endif
void pass_clob
 ( OCIExtProcContext * ctx        /* CONTEXT */,

   OCILobLocator *    p_iCLOB    /* OCILOBLOCATOR */,
   short              p_iCLOB_i  /* INDICATOR short */,

   OCILobLocator * *  p_oCLOB    /* OCILOBLOCATOR */,
   short *            p_oCLOB_i  /* INDICATOR short */ 
 )
{
ub4          lob_length;
myCtxStruct* myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return;
    debugf( myCtx,  "Enter Pass Clob" );

    /*
     * if the INPUT and OUTPUT clobs are not null (we passed the p_out
     * parameter as an IN OUT so the client would be responsible for
     * initializing the CLOB output value -- not us.  It could point to
     * a clob in the database or a temporary clob allocated in plsql or
     * some other language.
     */
    if ( p_iCLOB_i == OCI_IND_NOTNULL && *p_oCLOB_i == OCI_IND_NOTNULL )
    {
        debugf( myCtx,  "both lobs are NOT NULL" );

        if ( OCILobGetLength( myCtx->svchp, myCtx->errhp, 
                              p_iCLOB, &lob_length ) != OCI_SUCCESS ) 
        {
            raise_application_error(myCtx,ERROR_OCI_ERROR, 
                                    "%s",lastOciError(myCtx));
        }
        else
        {
            debugf( myCtx,  "Length of input lob was %d", lob_length );
            if ( OCILobCopy(myCtx->svchp, myCtx->errhp, *p_oCLOB, p_iCLOB, 
                            lob_length, 1, 1) != OCI_SUCCESS ) 
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR, 
                                        "%s",lastOciError(myCtx));
            }    
            else
            {

                debugf( myCtx,  "We copied the lob!");
            }
        }
    }
    else
    {
        raise_application_error( myCtx, ERROR_CLOB_NULL, 
                                 "%s %s clob was NULL",
                               (p_iCLOB_i == OCI_IND_NULL)?"input":"", 
                               (*p_oCLOB_i== OCI_IND_NULL)?"output":"" );
    }
    term(myCtx);
}


/*
 * And now for the arrays. We'll start with an array of numbers which
 * we will acces and print out.  Then, we'll take each element of array
 * 1 and place it into the out parameter array 2
 */


#ifdef WIN_NT
_declspec (dllexport)
#endif
void pass_numArray
 ( OCIExtProcContext * ctx        /* CONTEXT */,
   OCIColl *           p_in       /* OCICOL  */,
   short               p_in_i     /* INDICATOR short */,
   OCIColl **          p_out      /* OCICOL  */,
   short *             p_out_i    /* INDICATOR short */
 )
{
ub4        arraySize;
double     tmp_dbl;
boolean    exists;
OCINumber *ocinum;
int        i;
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return;
    debugf( myCtx,  "Enter Pass numArray" );

    /*
     * In this routine, passing a NULL array as input is an error, 
     * raise the error back to the calling routine
     */
    if ( p_in_i == OCI_IND_NULL )
    {
        raise_application_error( myCtx, ERROR_ARRAY_NULL, 
                                       "Input array was NULL" );
    }
    else
    /*
     * There are a series of OCIColl* functions that operate on these
     * array types.  This one tells us the number of elements in the
     * array
     */
    if ( OCICollSize( myCtx->envhp, myCtx->errhp, 
                      p_in, &arraySize ) != OCI_SUCCESS )
    {
        raise_application_error(myCtx,ERROR_OCI_ERROR, 
                                "%s",lastOciError(myCtx));
    }
       else
    {
        debugf( myCtx,  "IN Array is %d elements long", arraySize );

        /*
         * Now, lets loop over the array getting each value and printing it
         * out, then add that element to the output array to be returned to
         * the caller
         */
        for( i = 0; i < arraySize; i++ )
        {
            if (OCICollGetElem( myCtx->envhp, myCtx->errhp, p_in, i, 
                                &exists, (dvoid*)&ocinum, 0 ) != OCI_SUCCESS ) 
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR,
                                        "%s",lastOciError(myCtx));
                break;
            }
            if (OCINumberToReal( myCtx->errhp, ocinum, 
                                 sizeof(tmp_dbl), &tmp_dbl ) != OCI_SUCCESS ) 
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR,"%s",
                                        lastOciError(myCtx));
                break;
            }
            debugf( myCtx,  "p_in[%d] = %g", i, tmp_dbl );
            if ( OCICollAppend( myCtx->envhp, myCtx->errhp, ocinum, 0, 
                                *p_out ) != OCI_SUCCESS ) 
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR,
                                        "%s",lastOciError(myCtx));
                break;
            }
            debugf( myCtx,  "Appended to end of other array" );
        }
        /*
         * And lastly, set the out parameter to NOT NULL...
         */
        *p_out_i = OCI_IND_NOTNULL;
    }
    term(myCtx);
}
    

/*
 * Now, we do for strings what we did for numbers.  Notice the use of
 * an OCIString * *, not just an OCIString *.  This is necessary since
 * the OCICollGetElem routine fills in a pointer to a pointer -- not
 * just a pointer.
 * 
 * this routine will print out the input array and copy its elements
 * into the output array.
 */


#ifdef WIN_NT
_declspec (dllexport)
#endif
void pass_strArray
 ( OCIExtProcContext * ctx        /* CONTEXT */,
   OCIColl *           p_in       /* OCICOL  */,
   short               p_in_i     /* INDICATOR short */,
   OCIColl **          p_out      /* OCICOL  */,
   short *             p_out_i    /* INDICATOR short */
 )
{
ub4        arraySize;
boolean    exists;
OCIString * * ocistring;
int        i;
text      *txt;
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return;
    debugf( myCtx,  "Enter Pass strArray" );

    /*
     * We are considering NULL input as an error, notify the caller
     */
    if ( p_in_i == OCI_IND_NULL )
    {
        raise_application_error( myCtx, ERROR_ARRAY_NULL, 
                                       "Input array was NULL" );
    }
    else if ( OCICollSize( myCtx->envhp, myCtx->errhp, 
                           p_in, &arraySize ) != OCI_SUCCESS )
    {
        raise_application_error(myCtx,ERROR_OCI_ERROR,
                                "%s",lastOciError(myCtx));
    }
    else
    {
        debugf( myCtx,  "IN Array is %d elements long", arraySize );
        for( i = 0; i < arraySize; i++ )
        {
            if (OCICollGetElem( myCtx->envhp, myCtx->errhp, p_in, i, &exists, 
                                (dvoid*)&ocistring, 0) != OCI_SUCCESS ) 
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR, 
                                        "%s",lastOciError(myCtx));
                break;
            }
            txt = OCIStringPtr( myCtx->envhp, *ocistring );
    
            debugf( myCtx,  "p_in[%d] = '%s', size = %d, exists = %d", 
                    i, txt, OCIStringSize(myCtx->envhp,*ocistring), exists );
  
            if ( OCICollAppend( myCtx->envhp,myCtx->errhp, *ocistring, 
                                0, *p_out ) != OCI_SUCCESS ) 
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR,
                                        "%s",lastOciError(myCtx));
                break;
            }
            debugf( myCtx,  "Appended to end of other array" );
        }
        /*
         * And set the NULL indicator to NOT NULL
         */
        *p_out_i = OCI_IND_NOTNULL;
    }
    term(myCtx);
}



/*
 * And now for the array of dates.  much the same as the array of
 * numbers above...
 */

#ifdef WIN_NT
_declspec (dllexport)
#endif
void pass_dateArray
 ( OCIExtProcContext * ctx        /* CONTEXT */,

   OCIColl *           p_in       /* OCICOL  */,
   short               p_in_i     /* INDICATOR short */,

   OCIColl **          p_out      /* OCICOL  */,
   short *             p_out_i    /* INDICATOR short */
 )
{
ub4        arraySize;
boolean    exists;
OCIDate *  ocidate;
int        i;
char     * fmt = "Day, Month YYYY hh24:mi:ss";
ub4        buff_len;
char       buffer[255];
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return;
    debugf( myCtx,  "Enter Pass dateArray" );

    /* 
     * Treat NULL inputs as an error...
     */
    if ( p_in_i == OCI_IND_NULL )
    {
        raise_application_error( myCtx, ERROR_ARRAY_NULL, 
                                       "Input array was NULL" );
    }
    else if ( OCICollSize( myCtx->envhp, myCtx->errhp, 
                           p_in, &arraySize ) != OCI_SUCCESS )
    {
        raise_application_error(myCtx,ERROR_OCI_ERROR,
                                "%s",lastOciError(myCtx));
    }
    else
    {
    
        debugf( myCtx,  "IN Array is %d elements long", arraySize );

        for( i = 0; i < arraySize; i++ )
        {
            if (OCICollGetElem( myCtx->envhp, myCtx->errhp, p_in, i, 
                                &exists, (dvoid*)&ocidate, 0 ) != OCI_SUCCESS ) 
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR,
                                        "%s",lastOciError(myCtx));
                break;
            }

            buff_len = sizeof(buffer);
            if ( OCIDateToText( myCtx->errhp, ocidate, fmt, strlen(fmt), NULL, 
                               -1, &buff_len, buffer ) != OCI_SUCCESS )
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR, 
                                        "%s",lastOciError(myCtx));
                break;
            }
    
            debugf( myCtx,  "p_in[%d] = %.*s", i, buff_len, buffer );
    
            if ( OCICollAppend( myCtx->envhp,myCtx->errhp, ocidate, 
                                0, *p_out ) != OCI_SUCCESS ) 
            {
                raise_application_error(myCtx,ERROR_OCI_ERROR, 
                                        "%s",lastOciError(myCtx));
                break;
            }
            debugf( myCtx,  "Appended to end of other array" );
        }
        /*
         * and set to non-null...
         */
        *p_out_i = OCI_IND_NOTNULL;
    }
    term(myCtx);
}


/*
 * and now to demonstrate the ability of functions to return values.
 * We will show the returning of the main scalars -- Numbers, Dates and
 * strings.  This is different from parameters where the caller
 * allocated space -- here we must allocate the storage for the
 * returned element.  We do this with OCIExtProcAllocCallMemory, an API
 * that will free memory after our call has completed for us so we
 * don't have to worry about a memory leak
 *
 * When returning a NUMBER, we will return an OCINumber * below.  I
 * always take the indicator variable, which is PASSED to us -- not
 * returned by us, for all variables.  A function return value is no
 * different.  We will set the indicator to tell the caller whether we
 * are returning NULL or NOT NULL values..
 */

#ifdef WIN_NT
_declspec (dllexport)
#endif
OCINumber * return_number
 ( OCIExtProcContext * ctx,
   short *             return_i )
{
double      our_number = 123.456;
OCINumber * return_value;
myCtxStruct*myCtx;

    *return_i = OCI_IND_NULL;
    if ( (myCtx = init( ctx )) == NULL ) return NULL;
    debugf( myCtx,  "Enter return Number" );

    /*
     * Allocate storage for the number we are returning.  We cannot just
     * use a stack variable as it will go out of scope when we return.
     * Using malloc would be a cause for a memory leak.  Using a static
     * variable would not work either as due to dll caching -- someone else
     * can come along and alter the values we are pointing to after we
     * return (but before Oracle has copied the value).
     * Allocating storage is the only correct way to do this.
     */
    return_value =  
             (OCINumber *)OCIExtProcAllocCallMemory(ctx, sizeof(OCINumber) );

    if( return_value == NULL )
    {
        raise_application_error( myCtx, ERROR_OCI_ERROR, "%s", "no memory" );
    }
    else
    {
        /*
         * Here we just want to return the number 123.456 -- nothing fancy,
         * therefore we just convert that double into an OCINumber, set the
         * indicator variable and return our return_value...
         */
        if ( OCINumberFromReal( myCtx->errhp, &our_number, 
                     sizeof(our_number), return_value ) != OCI_SUCCESS )
        {
            raise_application_error(myCtx,ERROR_OCI_ERROR,
                                    "%s",lastOciError(myCtx));
        }
        *return_i = OCI_IND_NOTNULL;
    } 
    term(myCtx);
    return return_value;
}


/*
 * Returning a date is very similar to returning a number.  Same issues
 * apply. We'll allocate storage for our date -- fill it in -- set the
 * indicator -- and return...
 */

#ifdef WIN_NT
_declspec (dllexport)
#endif
OCIDate * return_date
 ( OCIExtProcContext * ctx,
   short *             return_i )
{
OCIDate * return_value;
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return NULL;
    debugf( myCtx,  "Enter return Date" );

    return_value = 
          (OCIDate *)OCIExtProcAllocCallMemory(ctx, sizeof(OCIDate) );

    if( return_value == NULL )
    {
        raise_application_error( myCtx, ERROR_OCI_ERROR, "%s", "no memory" );
    }
    else
    {
        *return_i = OCI_IND_NULL;
        if ( OCIDateSysDate( myCtx->errhp, return_value ) != OCI_SUCCESS )
        {
            raise_application_error(myCtx,ERROR_OCI_ERROR,
                                    "%s",lastOciError(myCtx));
        }
        *return_i = OCI_IND_NOTNULL;
    }
    term(myCtx);
    return return_value;
}



/* 
 * With the string (the varchar) we'll use 2 parameters -- the
 * indicator variable and the LENGTH field.  This time, much like an
 * OUT parameter, we set the length field to let the caller know how
 * long the returned string is.
 * 
 * Many of the same considerations apply for returning strings as above
 * -- we'll allocate storage, set the indicator, supply the value and
 * return it...
 */
#ifdef WIN_NT
_declspec (dllexport)
#endif
char * return_string
 ( OCIExtProcContext * ctx,
   short *             return_i,
   int   *             return_l )
{
char * data_we_want_to_return = "Hello World!";

char * return_value;
myCtxStruct*myCtx;

    if ( (myCtx = init( ctx )) == NULL ) return NULL;
    debugf( myCtx,  "Enter return String" );
    
    return_value = (char *)OCIExtProcAllocCallMemory(ctx, 
                                          strlen(data_we_want_to_return)+1 );

    if( return_value == NULL )
    {
        raise_application_error( myCtx, ERROR_OCI_ERROR, "%s", "no memory" );
    }
    else
    {
        *return_i = OCI_IND_NULL;
        strcpy( return_value, data_we_want_to_return );
        *return_l = strlen(return_value);
        *return_i = OCI_IND_NOTNULL;
    }
    term(myCtx);
    return return_value;
}
