﻿$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName = $env:ChocolateyPackageName
  file        = "$toolsDir\tesseract-ocr-w32-setup-v5.3.0.20221214.exe"
  file64      = "$toolsDir\tesseract-ocr-w64-setup-v5.3.0.20221214.exe"
  silentArgs  = '/S'
}

Install-ChocolateyInstallPackage @packageArgs
Install-ChocolateyPath $env:ProgramFiles\Tesseract-OCR
