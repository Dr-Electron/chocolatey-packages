﻿$ErrorActionPreference = 'Stop'
import-module au

function global:au_GetLatest {
     $releases = 'https://keepersecurity.com/desktop_electron/desktop_electron_version.txt'
	 $version  = (Invoke-WebRequest -Uri $releases | ConvertFrom-Json).version

     return @{
        Version = $version
        URL32   = 'https://www.keepersecurity.com/desktop_electron/Win32/KeeperSetup32.msi'
        URL64   = 'https://www.keepersecurity.com/desktop_electron/packages/KeeperPasswordManager.msixbundle'
    }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyinstall.ps1" = @{
			"(^(\s)*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(^(\s)*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^(\s)*url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^(\s)*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

update