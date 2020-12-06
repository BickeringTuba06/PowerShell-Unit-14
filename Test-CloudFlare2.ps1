<#
.SYNOPSIS
Test your connection to the CloudFlare DNS 
.DESCRIPTION
The command will be used to Test and to get detailed information of that test to the CloudFlare DNS 
.PARAMETER -Command
Specifies wich commands to run
.PARAMETER -AsJob
Tells PowerShell to start a Job 
.PARAMETER -JobName
Gives the Job a name
.PARAMETER -Session 
The parameter that specifies session then is followed by the session name. 
.PARAMETER -path
Sets the path to the location
.PARAMETER -name
The name of the of the job or file
.PARAMETER -seconds 
Time in seconds
.PARAMETER -computername 
The name of the PC
.PARAMETER -filepath
the path of the file
#>
[CmdletBinding()]
param ([parameter(Mandatory = $true)]
[string]$ComputerName)
param ([Parameter(Mandatory = $false)] 
[string] $Env:USERPROFILE)
Write-Verbose "Connecting to $ComputerName"
$DateTime = Get-Date 
set-location "C:\PowerShell test 1\"
<#Setting the location to the powershell test 1 folder#>
Clear-Host
<#clears the PowerShell prompt#>
$NewSession = New-PSSession -ComputerName $ComputerName
<#Creates a new session#>
Invoke-Command -Command {Test-NetConnection -ComputerName one.one.one.one -InformationLevel Detailed} -AsJob -JobName RemTestNet -session $NewSession 
<#Uses the invoke command to force the command above to run#>
Write-Verbose "running test on $ComputerName"
Start-Sleep -Seconds 10
<#This command sleeps the script for 10 seconds to allow the remote command to complete#>
Write-Verbose "receving test results" 
Receive-Job -Name RemTestNet | Out-File JobResults.txt
<#These commands are going to retrieve the results of the job and save them to a text file#>
Write-Verbose "generating test results"
Start-Process notepad -FilePath "C:\PowerShell test 1\JobResults.txt"
<#This command will use PowerShell to launch notpad to display the results of the text file#>
Write-Verbose "Opening results"
add-content -Path .\RemTestNet.txt -Value ($DateTime, $ComputerName)
Add-Content -Path .\RemTestNet.txt -Value (Get-Content -path .\JobResults.txt)
Remove-Item .\JobResults.txt
Write-Verbose "Finished running test"
Remove-PSSession -session $NewSession
<#This command will close the session with your session variable#>