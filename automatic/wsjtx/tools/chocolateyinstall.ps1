﻿$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  file         = "$toolsDir\wsjtx-2.6.1-win32.exe"
  file64       = "$toolsDir\wsjtx-2.6.1-win64.exe"
  silentArgs   = '/S'
}

Install-ChocolateyInstallPackage @packageArgs
