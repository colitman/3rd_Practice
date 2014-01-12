#include "stdio.h"

#include "error.h"
#include "stdlib.h"


void compute( int totlen, int * fixed, int * concatenate )
{
int	f;

	if ( totlen < 65535 ) 
	{
		*fixed = totlen;
		*concatenate = 1;
	}
	else
	{
		for( f = 65535; (totlen%f) && f > 1; f-- );

		*fixed = f;
		*concatenate = totlen/f;
	}
}

void write_ctl_file( int fixed, int concatenate, char * argv[] )
{
char	* filename = argv[1];
char	* tablename = argv[2];
char	* lr_column_name = argv[3];
char	* pk_column_name = argv[4];
char	* pk_value = argv[5];
char	* raw_char = argv[6];

	printf( "options(bindsize=%d, rows=1)\n", fixed*concatenate+500 );
	printf( "Load Data\n" );
	printf( "Infile %s \"fix %d\"\nconcatenate %d\nPreserve Blanks\n", 
					  filename, fixed, concatenate );

	printf( "Into Table %s\nappend\n(%s constant %s,%s %s(%d))\n",
					 tablename, pk_column_name, pk_value, lr_column_name,
					 raw_char, fixed*concatenate );
}



void main( int argc, char * argv[], char * environ[] )
{
FILE	* input;
char	* filename = argv[1];
int		fixed;
int		concatenate;


	if ( argc != 7 ) 
	{
		printf( "usage: %s filename tablename lr_column_name pk_column_name pk_value RAW|CHAR\n",
				argv[0] );
		exit(1);
	}

	input = fopen( filename, "rb" );
	if ( !input ) 
	{
		perror( "fopen:" );
		fprintf( stderr, "unable to open '%s' for input\n", filename );
		exit(1);
	}

	fseek( input, 0, SEEK_END );

	compute( ftell(input), &fixed, &concatenate );
	
	write_ctl_file(  fixed, concatenate, argv );

	fclose( input );
}
