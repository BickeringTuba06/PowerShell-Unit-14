<#

.SYNOPSIS
Test your connection to the cloudflare DNS using the cloud-flare function

.DESCRIPTION
The command will be used to Test and to get detailed information of that test to the CloudFlare DNS 

.PARAMETER -ComputerName
The name or the IP of the remote PC you want to test

.PARAMETER -Path
Can be used to set a path to a certain destination or variable

.PARAMETER -output
Specifies the destination when the script is run

.PARAMETER -Session 
The parameter that specifies session then is followed by the session name. 

.PARAMETER -path
Sets the path to the location

.PARAMETER -name
The name of the of the job or file

.PARAMETER -computername 
The name of the PC

.Notes
Author: Christian Jones

Last Edit: 11/22/20 8:54 PM

Version 1.12 -Added exception Handling for each loop
-Modified object creation to use OBJ PSCustomObject

.EXAMPLE
PS C:\>. \Test-cloudflare11 -coumputername (IP address or PC name)
Tests connectivity to cloudflare and writes the reults to the host with a different output.

.EXAMPLE
PS C:\>. \Test-cloudflare11 -coumputername (IP address or PC name) -path C:\Temp
Tests connectivity to Cloudflare and changes the location when saving the results.

#>
function Test-CloudFlare11 {
    
    param (
        [parameter(ValueFromPipeline = $true,
             Mandatory = $true)]
             [Alias ('CN','Name')]
             [string[]]$ComputerName,
        [Parameter(Mandatory = $false)]
             [ValidateSet('Text','Host','CSV')] 
             [string]$output = 'host',
        [parameter(Mandatory = $false)]
             [string] $Path = "$Env:USERPROFILE"
     ) 
     foreach ($Computer in $ComputerName) {
     try { 

        $Params = @{ 
            
            'computername' = $ComputerName

            'ErrorAction' = 'Stop'}
           
            $NewSession = New-PSSession $ComputerName
          
           Enter-PSSession $NewSession
          
           $DT = Get-Date
          
           $TestCF = Test-NetConnection -ComputerName one.one.one.one -InformationLevel Detailed
           
           $OBJ = [PSCustomObject]@{
               'computername' = $Computer

               'pingsuccess' = $TestCF.TcpTestSucceeded

               'NameResolve' = $TestCF.NameResolutionSucceeded

               'ResolveAddresses' = $TestCF.ResolvedAddresses}

        Exit-PSSession
               
        Remove-PSSession -Session $NewSession
        } #Try
     catch {
          Write-Host "Remote connection to $ComputerName failed" -ForegroundColor Red }#catch
}

switch ($Output) {
    
    "Host" {
        
         <#This option displays straight to the terminal#>
       
       $OBJ 
     
    }

    "Text" {
        
         <#This option will write to a text file#>


         <#These commands are going to retrieve the results of the job and save them to a text file#>

      Write-Verbose "Making Test Results"

      $OBJ | Out-File .\JobResults.txt

      Write-Verbose "Opening the results to a text file"

      Write-Verbose "Adding Content that will display onto our text file"

      Add-Content -Path "$NewPath.\RemTestNet.txt" -Value "Computer thats being tested: $ComputerName"

      add-content -Path "$NewPath.\RemTestNet.txt" -Value "Date and Time Tested: $DT"

      Add-Content -Path "$NewPath.\RemTestNet.txt" -Value (Get-Content -path .\JobResults.txt)
    
      notepad "$NewPath.\RemTestNet.txt"

      Remove-Item .\JobResults.txt

    }
    "CSV" {
       
         <#This option will write to a CSV file#>

      Write-Verbose "Making Test Results"

      Write-Verbose "Exporting Test Results"

         $OBJ | Export-Csv -Path .\TestResults.csv
        
           
           }

     

         

     }
} 

     