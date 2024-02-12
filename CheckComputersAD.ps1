<#
::=================================================================::
::Created by Daniel Krysty                                         ::
::Check list of computers if they are in AD                        ::
::Built in error checking and includes text output                 ::
::February 2024                                                    ::
::=================================================================:: 
#>

Set-StrictMode -Version Latest
# Import modules
Import-Module ActiveDirectory

# Specify location of text document
$FilePath = ".\computers.txt"
# Get date
$Date = Get-Date -DisplayHint Date
# Get User
$user = whoami

# Write Title
Write-Host -ForegroundColor Magenta "-----------------------------------"
Write-Host -ForegroundColor Magenta "Data Pulled from $FilePath by $user"
Write-Host -ForegroundColor Magenta "-----------------------------------"

# Check if .\FOUND.txt exists
if (Test-Path -Path .\FOUND.txt){
    Write-Host -ForegroundColor Gray "File .\FOUND.txt already exists"
    Write-Host -ForegroundColor DarkRed "  *Removing old data"
    Remove-Item -Path .\FOUND.txt -Force
    Write-Host -ForegroundColor DarkRed "  *Re-creating .\FOUND.txt"
    New-Item -Path . -Name FOUND.txt -Value "$Date`n$user`n`n" | Out-Null

}else{
    Write-Host -ForegroundColor Gray "File .\FOUND.txt does not exist"
    Write-Host -ForegroundColor DarkRed "  *Creating .\FOUND.txt"
    New-Item -Path . -Name FOUND.txt -Value "$Date`n$user`n`n" | Out-Null
}

# Check if .\FOUND.txt exists
if (Test-Path -Path .\NOT.FOUND.txt){
    Write-Host -ForegroundColor Gray "File .\NOT.FOUND.txt already exists"
    Write-Host -ForegroundColor DarkRed "  *Removing old data"
    Remove-Item -Path .\NOT.FOUND.txt -Force
    Write-Host -ForegroundColor DarkRed "  *Re-creating .\NOT.FOUND.txt"
    New-Item -Path . -Name NOT.FOUND.txt -Value "$Date`n$user`n`n" | Out-Null
}else{
    Write-Host -ForegroundColor Gray "File .\NOT.FOUND.txt does not exist"
    Write-Host -ForegroundColor DarkRed "  *Creating .\NOT.FOUND.txt"
    New-Item -Path . -Name NOT.FOUND.txt -Value "$Date`n$user`n`n" | Out-Null
}

# Test File path exists
if (Test-Path -Path $filepath){
    # Loop through list
    foreach($Computer in Get-Content $FilePath){
        # Checking
        Write-Host -ForegroundColor Yellow "Checking if $Computer is in AD"    
        try{
            $CheckName = Get-ADComputer -Identity $Computer -ErrorAction Ignore | Select-Object -ExpandProperty name
            Write-Host -ForegroundColor Green "  *Found $Computer in AD*"
            Add-Content -Path .\FOUND.txt $CheckName
        }catch{            
            Write-Host -ForegroundColor Red "  *Did not Found $Computer in AD*"
            Add-Content -Path .\NOT.FOUND.txt $CheckName
        }
    }
}else{
    Write-Host "  *File path '$FilePath' does not exist.`n  *Please check for file in directory."
}

[int]$fl = (Get-Content -Path .\FOUND.txt).Length
[int]$nfl = (Get-Content -Path .\NOT.FOUND.txt).Length

if ($fl -le 3){
    Write-Host -ForegroundColor Gray "Removing .\FOUND.txt"
    Remove-Item -Path .\FOUND.txt -Force
}

if($nfl -le 3){
    Write-Host -ForegroundColor Gray "Removing .\NOT.FOUND.txt"
    Remove-Item -Path .\NOT.FOUND.txt -Force
}
