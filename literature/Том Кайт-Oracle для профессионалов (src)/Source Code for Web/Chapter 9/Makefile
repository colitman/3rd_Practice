CPU=i386

WORK_DIR         = .\     

!include <\msdev\include\win32.mak>

OBJDIR    = $(WORK_DIR)\    #
EXEDIR  =   $(WORK_DIR)\    #  dir where all the .exe will be put


TARGET   = $(EXEDIR)genctl.exe


SAMPLEOBJS   = genctl.obj

LOCAL_DEFINE = -DWIN_NT

SYSLIBS         = c:\msdev\lib\msvcrt.lib \
		  c:\msdev\lib\oldnames.lib \
		  c:\msdev\lib\kernel32.lib  \
		  c:\msdev\lib\advapi32.lib  

NTUSER32LIBS    = c:\msdev\lib\user32.lib \
		  c:\msdev\lib\advapi32.lib \
		  c:\msdev\lib\libc.lib


INCLS   = -Ic:\msdev\include 

CFLAGS = $(cdebug) $(cflags) $(INCLS) $(LOCAL_DEFINE)

$(TARGET): $(SAMPLEOBJS) $(SQLLIB)
    $(link) $(LINKOPT) \
	-out:$(TARGET) $(SAMPLEOBJS) \
        $(NTUSER32LIBS) \
        $(SYSLIBS) \
        $(SQLLIB) 
