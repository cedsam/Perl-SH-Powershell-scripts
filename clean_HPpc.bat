explorer.exe "\\Sms2007\Client"
explorer.exe "\\PCSTAGEINFO\Partage"
REM "Arrêt des processus/services génants..."
cd "C:\"
tskill DPAgent
tskill coreshredder
tskill DpHostW
tskill HPAuto
tskill HPFSService
tskill HPSA_Service
net stop HPAuto
net stop FLCDLOCK
net stop hpqwmiex
net stop "HP Support Assistant Service"
REM "Désinstallation des programmes inutiles..."
MsiExec.exe /X{3677D4D8-E5E0-49FC-B86E-06541CF00BBE} /qb /quiet /norestart
MsiExec.exe /X{07FA4960-B038-49EB-891B-9F95930AA544} /qb /quiet /norestart
MsiExec.exe /X{CC4D56B7-6F18-470B-8734-ABCD75BCF4F1} /qb /quiet /norestart
MsiExec.exe /X{CA2F6FAD-D8CD-42C1-B04D-6E5B1B1CFDCC} /qb /quiet /norestart
MsiExec.exe /X{6E14E6D6-3175-4E1A-B934-CAB5A86367CD} /qb /quiet /norestart
MsiExec.exe /X{27F1E086-5691-4EB8-8BA1-5CBA87D67EB5} /qb /quiet /norestart
MsiExec.exe /X{BEBBA1A1-437E-418B-85B7-94946CF5E908} /qb /quiet /norestart
MsiExec.exe /X{10F5A72A-1E07-4FAE-A7E7-14B10CC66B17} /qb /quiet /norestart
MsiExec.exe /X{6D6ADF03-B257-4EA5-BBC1-1D145AF8D514} /qb /quiet /norestart
MsiExec.exe /X{438363A8-F486-4C37-834C-4955773CB3D3} /qb /quiet /norestart
MsiExec.exe /X{EE202411-2C26-49E8-9784-1BC1DBF7DE96} /qb /quiet /norestart
cd "C:\Windows\Installer\"
MsiExec.exe /X 3d12c.msi /qb /quiet /norestart
MsiExec.exe /X 3dca1.msi /qb /quiet /norestart
cd "C:\"
MsiExec.exe /X{55B52830-024A-443E-AF61-61E1E71AFA1B} /qb /quiet /norestart
MsiExec.exe /X{CD95F661-A5C4-44F5-A6AA-ECDD91C240CF} /qb /quiet /norestart
MsiExec.exe /X{90150000-0138-0409-0000-0000000FF1CE} /qb /quiet /norestart
MsiExec.exe /X{6FE8E073-D159-4419-93E2-CE2C5B078562} /qb /quiet /norestart
"C:\Program Files (x86)\PDF Complete\uninstall.exe" /S
"C:\Program Files\Microsoft Security Client\Setup.exe" /x /s
REM "Suppression des clés de registres obsolètes"
REG DELETE HKEY_CLASSES_ROOT\Installer\Products\8C1B7B2BB8C7C674EBC24079135C9529 /f
REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\8C1B7B2BB8C7C674EBC24079135C9529 /f
REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{B2B7B1C8-7C8B-476C-BE2C-049731C55992} /f
REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\InstallShield_{10F5A72A-1E07-4FAE-A7E7-14B10CC66B17} /f
REM "Suppression des dossiers non correctement supprimés par le desinstallateur..."
rd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\HP Help and Support" /Q /S
rd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Security and Protection" /Q /S
rd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Security and Protection" /Q /S
rd "C:\Program Files (x86)\Hewlett-Packard" /Q /S
REM "Installation des programmes nécéssaires..."
\\Sms2007\Client\ccmsetup.exe /mp:SMS2007 SMSSITECODE=MDM FSP=SMS2007
"C:\DL\vlc-media-player_vlc_media_player_2.0.4_francais_10829.exe" /S
"C:\DL\zzz92AdbeRdr1010_fr_FR.exe" /msi EULA_ACCEPT=YES /qn
"C:\DL\zzz99WG-Authentication-Client_11_6.msi"
"C:\DL\zzzFirefox_Setup_22.0.exe" /s
"C:\DL\zzzpf7-7_11-setup-fr.exe" /S
"C:\Update\zzz89PDFCreator-1_7_0_setup.exe" /VERYSILENT
"C:\DL\zzz99WG-Authentication-Client_11_6.msi"
REM "Suppression des dossiers copiés au sein de la machine..."
rd C:\DL /Q /S
REM "Arrêt de la machine..."
shutdown /r /t 00