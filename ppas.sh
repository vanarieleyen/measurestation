#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking update.exe
OFS=$IFS
IFS="
"
i386-win32-ld -b pei-i386 -m i386pe  -L/usr/lib32 -L/usr/lib --gc-sections  -s --subsystem windows --entry=_WinMainCRTStartup    -o update.exe link.res
if [ $? != 0 ]; then DoExitLink update.exe; fi
IFS=$OFS
OFS=$IFS
IFS="
"
i386-win32-postw32 --subsystem gui --input update.exe --stack 16777216
if [ $? != 0 ]; then DoExitLink ; fi
IFS=$OFS
