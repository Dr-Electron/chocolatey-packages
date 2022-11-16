﻿$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"


# Remove previous setup
Remove-Item -Path "$toolsDir\*.zip" -ErrorAction SilentlyContinue

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  destination    = "$toolsDir"

  url64          = 'https://github.com//NatronGitHub/Natron/releases/download/v2.4.4/Natron-2.4.4-Windows-x86_64.zip'
  checksum64     = '1a80fe25e0acf727527a140711ea97e5ad7e837f3c2055cc463e315664cffd72'
  checksumType64 = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName  
  file          = (Get-ChildItem -Recurse "$toolsDir\Natron-*-Windows-*64\Setup.exe").fullName
  silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
}

Install-ChocolateyInstallPackage @packageArgs
