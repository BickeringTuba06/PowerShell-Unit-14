function Test-CloudFlare {
    param (
        [parameter(ValueFromPipeline=$true,
             Mandatory = $true)]
             [Alias ('CN','Name')]
             [string[]]$ComputerName,
        [Parameter(Mandatory = $false)]
             [ValidateSet('Text','Host','CSV')] 
             [string]$output = "host",
        [parameter(Mandatory=$false)]
             [string] $Path = "$Env:USERPROFILE"
     )
    foreach ($computer in $ComputerName) {
        try { 
            
        
          $NewSession = New-PSSession -ComputerName $ComputerName
          Enter-PSSession $NewSession
          $DateAndTime = Get-Date
          $TestCF = Test-NetConnection -ComputerName one.one.one.one -InformationLevel Detailed
          $Props = @{
             'computer name' = $computer.PCUsedInTest
             'ping success' = $TestCF.PingTestThatWasUsedInTestNetCon
             'Name Resolve' = $TestCF.ResolvedNamesInTest
             'Resolve Addresses' = $TestCF.ResolvedAddressessInTestCon }
         $OBJ = New-Object -TypeName PSObject -Property $Props
         Exit-PSSession
         Remove-PSSession -Session $NewSession
}
switch ($Output) {
    "Host" {
        <#This option displays straight to the terminal#>
       
       $OBJ }

    "Text" {
        <#This option will write to a text file#>


     <#These commands are going to retrieve the results of the job and save them to a text file#>

      Write-Verbose "generating test results"

      $OBJ | Out-File .\JobResults.txt

      Write-Verbose "Opening results"

      add-content -Path "$Path.\RemTestNet.txt" -Value "Date and Time Tested: $DateAndTime"

      Add-Content -Path "$Path.\RemTestNet.txt" -Value "Computer thats being tested: $ComputerName"

      Add-Content -Path "$Path.\RemTestNet.txt" -Value (Get-Content -path .\JobResults.txt)
    
      notepad "$Path.\RemTestNet.txt"

      Remove-Item .\JobResults.txt

     }
    "CSV" {
        <#This option will write to a CSV file#>

      Write-Verbose "generating test results"

      Write-Verbose "Opening results"

         $OBJ | Export-Csv -Path .\TestResults.csv
        }

     

         

     }
 
}