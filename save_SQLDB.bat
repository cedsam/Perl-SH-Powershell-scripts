@echo off
cd C:\xampp\mysql\bin
mysqldump.exe > mysqldump --user='*****' --password=****** ocsweb > \\servm-data-2011\d$\data\SvgApplis\OCS\ocs.sql
mysqldump.exe > mysqldump --user='******' --password=****** glpi > \\servm-data-2011\d$\data\SvgApplis\GLPI\glpi.sql
cd \\servm-data-2011\d$\data\SvgApplis\OCS\
SET date=%DATE:/=%
rename ocs.sql OCS%date%.sql
forfiles /s /m *.* /d -30 /c "cmd /c del @FILE"
cd \\servm-data-2011\d$\data\SvgApplis\GLPI\
SET date=%DATE:/=%
rename glpi.sql GLPI%date%.sql
forfiles /s /m *.* /d -30 /c "cmd /c del @FILE"
