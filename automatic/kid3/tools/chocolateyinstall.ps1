﻿$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  destination   = "$toolsDir"  
  file64        = "$toolsDir\kid3-3.9.1-win32-x64.zip"  
}

if (Get-OSArchitectureWidth -compare 32) {
    $architectureWidth = ''
} else {
    $architectureWidth = '-x64'
}

Get-ChocolateyUnzip @packageArgs
Remove-Item $packageArgs.file64

# Install start menu shortcut
$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutFilePath = Join-Path $programs "Kid3.lnk"
$targetPath = Join-Path $toolsDir "kid3-3.9.1-win32${architectureWidth}\kid3.exe"
Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath
