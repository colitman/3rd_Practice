LOAD DATA
INFILE *
REPLACE
INTO TABLE LOB_DEMO
( owner      position(40:61),
  timestamp  position(1:18) "to_date(:timestamp||'m','mm/dd/yyyy  hh:miam')",
  filename   position(63:80),
  text LOBFILE(filename) TERMINATED BY EOF
)
BEGINDATA
04/14/2001  12:36p               1,697 BUILTIN\Administrators demo10.log
04/14/2001  12:42p               1,785 BUILTIN\Administrators demo11.log
04/14/2001  12:47p               2,470 BUILTIN\Administrators demo12.log
04/14/2001  12:56p               2,062 BUILTIN\Administrators demo13.log
04/14/2001  12:58p               2,022 BUILTIN\Administrators demo14.log
04/14/2001  01:38p               2,091 BUILTIN\Administrators demo15.log
04/14/2001  04:29p               2,024 BUILTIN\Administrators demo16.log
04/14/2001  05:31p               2,005 BUILTIN\Administrators demo17.log
04/14/2001  05:40p               2,005 BUILTIN\Administrators demo18.log
04/14/2001  07:19p               2,003 BUILTIN\Administrators demo19.log
04/14/2001  07:29p               2,011 BUILTIN\Administrators demo20.log
04/15/2001  11:26a               2,047 BUILTIN\Administrators demo21.log
04/14/2001  11:17a               1,612 BUILTIN\Administrators demo4.log
