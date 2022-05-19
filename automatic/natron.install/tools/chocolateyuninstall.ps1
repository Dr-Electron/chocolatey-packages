﻿$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  softwareName = 'Natron'
  fileType     = 'exe'
}

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % { 
    $packageArgs['file'] = "$($_.UninstallString)"
	  #Start-Process "AutoHotKey" -Verb runas -ArgumentList "`"$toolsDir\chocolateyuninstall.ahk`""
    Uninstall-ChocolateyPackage @packageArgs

    # Close AutoHotKey
    #$autohotkey = Get-Process AutoHotKey -ErrorAction SilentlyContinue
    #if ($autohotkey) { $autohotkey | Stop-Process }
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}