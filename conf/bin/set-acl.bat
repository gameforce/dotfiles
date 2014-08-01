 :begin
@echo off
IF "%1"==""  goto error ELSE
xcacls d:\RV\SFTP\%2 /G %2:C /Y /E /T /C
xcacls d:\rv\sandboxes\%1 /E /G %2:C /C /Y
xcacls d:\rv\sandboxes\%1\scripts /E /G %2:rw /C /Y
xcacls d:\rv\sandboxes\%1\scripts\*.* /E /G %2:xr /C /Y
xcacls d:\rv\sandboxes\%1\logs /P %2:CXEW /C /T /E /Y
xcacls d:\rv\sandboxes\%1\Templates /P %2:CXEW /C /T /E /Y
xcacls d:\rv\sandboxes\%1\ManagementConsole /P %2:CXEW /C /T /E /Y
xcacls d:\rv\sandboxes\%1\bin /P %2:CXEW /C /T /E /Y
xcacls d:\rv\sandboxes\%1\scripts\user /P %2:CXEW /C /T /E /Y
xcacls d:\rv\sandboxes\%1\scripts\system /P %2:XEW /T /C /E /Y
xcacls d:\rv\sandboxes\%1\scripts\site-packages /P %2:XEW /T /C /E /Y
net localgroup perflib %2 /ADD
sc config "%1 QuazalRendezVous" obj= .\%2 password= %3 start= demand
goto fin
:error
echo --------------
echo syntax error
echo set-acl.bat sandboxnodename username(windows) password(windows)
echo --------------
:fin
