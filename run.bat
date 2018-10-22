@echo off
:handles
Color 6
set server=##SERVER IP WITH HELD FROM GITHUB##\backup
set back-server-folder=##SERVER IP WITH HELD FROM GITHUB##\backup\users\%username%
set server-map=T:
set installed=%appdata%\.minecraft
set V=A01
set name=Minecraft Launcher %V%
title %name%
cls

:notice
echo.
echo Please make sure you have nothing is mapped to your T drive.
echo This launcher uses this drive because it's at the center of the
echo letters and we think this letter would not be used for anything else.
echo.
echo If your ready!
pause
goto server

:again
:server
cls
NET USE %server-map% %server%\information /P:No /user:##username and password withheld##
echo.
echo Is there a server?
echo.
IF EXIST "%server-map%\is-server.txt" (goto V-Check) ELSE (goto Fail)

:V-Check
cls
echo Checking version
IF EXIST "%server-map%\%V%.txt" (echo Match) ELSE (goto GetUpdate)
goto continue

:Fail
NET USE %server-map% /DELETE /Y
cls
echo Checking of the version failed.
echo This could be due to not be connected to the internet.
echo Please check your internet connection and try again.
echo After checking your connection,
pause
goto again

:GetUpdate
cls
echo Getting the new launcher version.
echo.
IF EXIST "%server-map%\update.zip" (goto ZipDown) ELSE (goto FailUpdate)
REM .In
REM It should now be downloading the update.
REM .Out

:FailUpdate
NET USE %server-map% /DELETE /Y
cls
echo Checking of the update failed.
echo This could be due to connection problem to the internet.
echo Please check your internet connection and try again.
echo After checking your connection,
pause
goto GetUpdate

:run-backup
cls
NET USE %server-map% %back-server-folder% /P:No /P:No /user:##username and password withheld##
IF EXIST "%server-map%\auth.txt" (echo Authorised) ELSE (goto self-backup)
MD %server-map%\logs
type NUL > %server-map%\logs\backup-started--%computername%--%date:~4,2%-%date:~7,2%-%date:~-2,2%.txt
REM In. -- Folders
MD %server-map%\worlds
MD %server-map%\worlds\%date:~10%
MD %server-map%\worlds\%date:~10%\%date:~7,2%
MD %server-map%\worlds\%date:~10%\%date:~7,2%\%date:~4,2%
REM Out. -- Folders
XCOPY "%installed%\saves"/S /R /V /Y /Z "%server-map%\worlds\%date:~10%\%date:~7,2%\%date:~4,2%\"
NET USE %server-map% /DELETE /Y
exit

:self-backup
NET USE %server-map% /DELETE /Y
MD C:\Minecraft\worlds
MD C:\Minecraft\worlds\%date:~10%
MD C:\Minecraft\worlds\%date:~10%\%date:~7,2%
MD C:\Minecraft\worlds\%date:~10%\%date:~7,2%\%date:~4,2%
XCOPY "%installed%\saves"/S /R /V /Y /Z "C:\Minecraft\worlds\%date:~10%\%date:~7,2%\%date:~4,2%\"
exit

:ZipDown
cls
REM .In
REM Starting the download again
REM .Out
NET USE %server-map% /DELETE /Y
NET USE %server-map% %server%\updates\ /P:No
echo Getting the new version, depending on your internet this could be a while.
echo After it has compleated it will automatically continue!
MD C:\Minecraft\updates
XCOPY "%server-map%\update-%V%.zip" /q "C:\Minecraft\updates"
goto UnZip

:UnZip
cls
REM .In
REM Going to unzip the file.
REM .Out
Expand "C:\Minecraft\updates\update.zip"
del "C:\Minecraft\updates\update-%V%.zip"
MOVE "C:\Minecraft\updates\*.*" /q "C:\Minecraft"
RD "C:\Minecraft\updates"







:continue
cls
NET USE %server-map% /DELETE /Y
REM In.
REM Enter rest of code to start the game here
REM Out.
pause
goto run-backup

