function fonctionprincipale
{
	do
	{
		cd C:\
		$demande=read-host -Prompt "Indiquer un mot clé"
		if ($demande -ne $null)
		{
			Remove-Item .\script.txt
			clear-host
			Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -match $demande} | Format-Table UninstallString > 1.txt
			Get-Content .\1.txt | where { $_ -notmatch "UninstallString" } > 2.txt
			Get-Content .\2.txt | where { $_ -notmatch "---------------" } > 3.txt
			Get-Content .\3.txt | where { $_ -ne "$null" } > 4.txt
			Get-Content .\4.txt | where { $_ -notmatch [char]254 } > 5.txt
			Remove-Item 1.txt, 2.txt, 3.txt, 4.txt
			Rename-Item .\5.txt lignescript.txt
			echo "Fichier est crée, trouvable à la racine de C:\ (script.txt)"
			start-sleep 5
			Clear-Host
		}
	}
	while($demande=9999)
	}
	$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
	$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
	$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
	if ($myWindowsPrincipal.IsInRole($adminRole))
	{	
		fonctionprincipale;
	}
	else
	{
		$newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
		$newProcess.Arguments = $myInvocation.MyCommand.Definition;
		$newProcess.Verb = "runas";
		[System.Diagnostics.Process]::Start($newProcess);
	}
	fonctionprincipale;
}