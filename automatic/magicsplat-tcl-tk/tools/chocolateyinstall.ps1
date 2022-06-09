﻿$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  destination   = "$toolsDir"

  file          = "$toolsDir\tcl-8.6.12-installer-1.12.1-x86.msi"
  filetype      = 'MSI'
  file64        = "$toolsDir\tcl-8.6.12-installer-1.12.1-x64.msi"
  filetype64    = 'MSI'

  silentArgs    = "ALLUSERS=1 APPLICATIONFOLDER=C:\Progra~1\Tcl /qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
}

Install-ChocolateyInstallPackage @packageArgs
