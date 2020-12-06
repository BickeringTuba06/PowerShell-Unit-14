fuction global:ADD-LOGFILE{
[CmdletBinding()]
Param(
    [STRING[]]$Folder="C:\PowerShell test 1",
    [STRING[]]$Preface="Logfile",
    [STRING[]]$Extension=".log"
)}

param([Parameter(Mandatory = $false)] $LabPath = 'c:\PowerShell test 1\' )

$ComputerName = read-host "Please enter the Name or IP Address of the remote computer you wish to test:")

<#Sets the Variable with read-host that displays the entered text to the user when the variable is entered#>