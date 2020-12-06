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

.Notes
Author: Christian Jones

Last Edit: 11/15/20 6:58 PM

Version 1.0 Initial relaese of Test-CloudFlare

.Example 
Testing a network connection on a local PC
Invoke-Command -Command {Test-NetConnection -ComputerName one.one.one.one -InformationLevel Detailed} -AsJob -JobName RemTestNet -session $NewSession 

.Example 
Testing the network connection on a remote PC
Invoke-Command -Command {Test-NetConnection -ComputerName one.one.one.one -InformationLevel Detailed} -AsJob -JobName RemTestNet -session $NewSession 

.Example 
Getting network information on a remote and or a local PC
Invoke-Command -Command {Test-NetConnection -ComputerName one.one.one.one -InformationLevel Detailed} -AsJob -JobName RemTestNet -session $NewSession 

#>

[CmdletBinding()]
 param([parameter(Mandatory = $true)]
 [string[]]$ComputerName,
 [Parameter(Mandatory = $false)] 
 [string] $Path = "$Env:USERPROFILE",
 [parameter(Mandatory=$true)]
 [string]$output = "Host"
)

Write-Verbose "Connecting to $ComputerName"

$DateTime = Get-Date 

<#Setting the location to the powershell test 1 folder#>

set-location "C:\PowerShell test 1\"

<#clears the PowerShell prompt#>

Clear-Host

<#Starts a new session#>

$NewSession = New-PSSession -ComputerName $ComputerName

<#Uses the invoke command to force the command above to run#>

Invoke-Command -Command {Test-NetConnection -ComputerName one.one.one.one -InformationLevel Detailed} -AsJob -JobName RemTestNet -session $NewSession 

Write-Verbose "running test on $ComputerName"

<#This command sleeps the script for 10 seconds to allow the remote command to complete#>

Start-Sleep -Seconds 10

Write-Verbose "receving test results" 

<#Used the switch output here to account for all of the if and else if sections#>

switch ($Output) {
    
     "Host" {
         <#This option displays straight to the terminal#>
        
        Receive-Job RemTestNet

     }

     "Text" {
         <#This option will write to a text file#>


     <#These commands are going to retrieve the results of the job and save them to a text file#>

     Write-Verbose "generating test results"

     Receive-Job RemTestNet | Out-File .\JobResults.txt

     Write-Verbose "Opening results"

     Start-Process notepad -FilePath "C:\PowerShell test 1\JobResults.txt"

     add-content -Path .\RemTestNet.txt -Value ($DateTime, $ComputerName)

     Add-Content -Path .\RemTestNet.txt -Value (Get-Content -path .\JobResults.txt)
     
     notepad .\RemTestNet.txt

     Remove-Item .\JobResults.txt

     }

     "CSV" {
         <#This option will write to a CSV file#>

     Write-Verbose "generating test results"

     Receive-Job -Name RemTestNet | Export-Csv -Path .\RemTestNet.csv 

     Write-Verbose "Opening results"

     notepad .\RemTestNet.csv

     }
 <#Setting the default output#>
 Default {"$Output is not a valid option"}

}

Write-Verbose "Finished running test"

<#This command will close the session with your session variable#>

Remove-PSSession -session $NewSession