@echo off
netsh firewall set opmode disable
\\172.30.5.6\Tous\Office\Standard\SETUP.EXE /Adminfile msok.MSP
XCOPY \\PCSTAGEINFO\Partage\DL C:\DL\ /Y /E
COPY \\PCSTAGEINFO\Partage\script.bat "C:\Users\MAIRIE DE MACON\Desktop"
XCOPY \\PCSTAGEINFO\Partage\xp C:\xp\ /Y /E
XCOPY \\PCSTAGEINFO\Partage\p4 "C:\Documents and Settings\MAIRIE DE MACON\Bureau\p4\" /Y /E
COPY \\PCSTAGEINFO\Partage\p4.bat "C:\Documents and Settings\MAIRIE DE MACON\Bureau\"
COPY \\PCSTAGEINFO\Partage\p4-2.bat "C:\Documents and Settings\MAIRIE DE MACON\Bureau\"
"C:\xp\windows-xp-service-pack-3_windows_xp_service_pack_3_francais_242026.exe" /quiet /norestart
shutdown /t 00 /s