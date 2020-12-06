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
#>
param(

    $LabPath = 'c:\PowerShell test 1\'
    
)
<#Setting the Variable Lab path with the destination of powershell test 1#>
set-location -path $LabPath 
<#Creates a variable that sets a location#>
Clear-Host
<#clears the PowerShell prompt#>
$ComputerName = read-host "Please enter the Name or IP Address of the remote computer you wish to test:"
<#Sets the Variable with read-host that displays the entered text to the user when the variable is entered#>
$NewSession = New-PSSession -ComputerName $ComputerName
<#Creates a new session#>
Invoke-Command -Command {Test-NetConnection -ComputerName one.one.one.one -InformationLevel Detailed} -AsJob -JobName UnitLabJob -session $NewSession 
<#Uses the invoke command to force the command above to run#>
Start-Sleep -Seconds 10 
<#This command sleeps the script for 10 seconds to allow the remote command to complete#>
Receive-Job -Name UnitLabJob | Out-File UnitLabJob.txt 
<#These commands are going to retrieve the results of the job and save them to a text file#>
Start-Process notepad -FilePath "c:\PowerShell test 1\UnitLabJob.txt"
<#This command will use PowerShell to launch notpad to display the results of the text file#>
Remove-PSSession -session $NewSession
<#This command will close the session with your session variable#>
