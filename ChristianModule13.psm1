function Test-Clouflare {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [Alias('CN','Name')]
        [string[]]$Computername,
        [Parameter(Mandatory=$false)]
        [string]$path = "$Env:USERPROFILE",
        [ValidateSet('Host','Text','CSV')]
        [string]$Output = "Host"
    ) #Param

    ForEach ($Computer in $Computername) {
        Try {
            $params = @{'Computername' = $Computer
                 'ErrorAction' = 'Stop'
            }
             $Session = New-Session @params

             Write-Verbose "Connecting to $Computer ...."


             Write-Verbose "Testing connection to One.One.One.One on $Computername ..."
             Enter-PSSession $Session
             $DateTime = Get-Date
             $TestCF = Test-NetConnection -ComputerName one.one.one.one -InformationLevel Detailed


             $obj = [PSCustomObject]@{ 'Computername' = $Computer
                     'PingSuccess' = $TestCF.PingSucceeded
                     'NameResolve' = $TestCF.NameResoultionSucceeded
                     'ResolvedAddresses' = $TestCF.ResolvedAddresses
            }

             Exit-PSSession
             Remove-PSSession $Session
            } Catch {
                Write-Host "Remote Connection to $Compute failed." -ForegroundColor Red
            } #Try/Catch
    } #ForEach

    Write-Verbose "Receiving test results ..."
    switch ($Output) {
        "Host" {$obj}
        "CSV" {
            Write-Verbose "Generating results file ..."
            $obj | Export-Csv -Path $path\TestResults.csv
        }
        "Text" {
            Write-Verbose "Generating results file ..."
            $obj | Out-File $path\TestResults.txt
            Add-Content $path\RemTestNet.txt -Value "Computer Tested: $Computer"
            Add-Content $path\RemTestNet.txt -Value "Date/Time Tested: $DateTime"
            Add-Content $path\RemTestNet.txt -Value (Get-Content -Path $path\TestResults.txt)
            Remove-Item $path\TestResults.txt
            Write-Verbose "Opening Results ..."
            Notepad $path\RemTestNet.txt
        }
    } #switch

    Write-Verbose "Finished Runnning Tests."
}#function 

Import-Module "C:\PowerShell test 1\ChristianModule13.ps1"

Save-Module -Name ChristianModule13 -path "C:\PowerShell test 1"  

New-ModuleManifest -Path ./ChristianModule13.psd1 -ModuleVersion 3.0 -Author "Christian Jones" -CompanyName "MATC INT" -Description "This module is a test for your connection using one.one.one.one" -PowerShellVersion 4.0 -FunctionsToExport @('Test-Clouflare') -root ./ChristianModule13.psd1

