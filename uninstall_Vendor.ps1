function fonctionprincipale{
do{
Clear-Host
$demande=read-host -Prompt "Indiquer un mot clé"
$reponse=Get-WmiObject -Class Win32_Product | Where-Object {$_.Vendor -match $demande}
$resultat=0
if ($reponse -eq $null){
write-host "Le mot clé indiqué abouti à rien du tout." -ForegroundColor red -BackgroundColor black
start-sleep 5
}
else{
$resultat=1
}
switch($resultat){
"1"{
$reponse
$confirmation=read-host "Etes vous sûr de désinstaller le(s) programme(s) suivant(s)? [Oui] [Non]"
if ($confirmation -eq "Oui"){
Get-WmiObject -Class Win32_Product | Where-Object {$_.Vendor -match $demande } | %{$_.Uninstall()} | Clear-Host
start-sleep 2
}}}
Clear-Host
}
while($resultat=2)
}
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
if ($myWindowsPrincipal.IsInRole($adminRole)){
fonctionprincipale
}
else
{
$newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
$newProcess.Arguments = $myInvocation.MyCommand.Definition;
$newProcess.Verb = "runas";
[System.Diagnostics.Process]::Start($newProcess);
fonctionprincipale
}