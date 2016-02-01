@echo off
set VERSION=2101
set OCSSERVER=http://192.168.****.****/ocsinventory
set INSTALLSERVER= **********\Applis\OCSINSTALL\
set DEPLOYE=OFF
IF %PROCESSOR_ARCHITECTURE%==x86 SET INSTALLDIR=%ProgramFiles%
IF %PROCESSOR_ARCHITECTURE%==AMD64 SET INSTALLDIR=%ProgramFiles(x86)%
IF EXIST "%INSTALLDIR%\OCS Inventory agent\OCSInventory.exe" goto upgrade

:install 
	\\%INSTALLSERVER%\OCS-NG-Windows-Agent-Setup /S /SERVER=%OCSSERVER%/ocsinventory /NOSPLASH /DEBUG /NOW
	cd "%INSTALLDIR%\OCS Inventory agent\"
	echo pwouet > %VERSION%.txt
	net stop "OCS Inventory Service"
	del OcsSystray.exe
	net start "OCS Inventory Service"
	goto end
	
:upgrade
	IF EXIST "%INSTALLDIR%\OCS Inventory agent\%VERSION%.txt" goto end
	\\%INSTALLSERVER%\OCS-NG-Windows-Agent-Setup /S /SERVER=%OCSSERVER%/ocsinventory /NOSPLASH /DEBUG /NOW
	cd "%INSTALLDIR%\OCS Inventory agent\"
	echo pwouet > %VERSION%.txt
	net stop "OCS Inventory Service"
	del OcsSystray.exe
	net start "OCS Inventory Service"
	:end
	
IF NOT %DEPLOYE%==ON goto endend
IF EXIST "%INSTALLDIR%\OCS Inventory NG\Agent\cacert.pem" goto endend
xcopy \\%INSTALLSERVER%\cacert.pem "%ALLUSERSPROFILE%\OCS Inventory agent\" /Y
net stop "OCS Inventory Service"
del OcsSystray.exe
net start "OCS Inventory Service"
:endend