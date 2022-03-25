﻿import-module au

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {    
    $releases = 'https://camotics.org/download.html'
    $regex64   = 'camotics_(?<Version>[\d\.]+)_AMD64.exe'
    $regex32   = 'camotics_([\d\.]+)_x86.exe'

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing	
	$url32 = $download_page.links | ? href -match $regex32 | Select -First 1
    $url64 = $download_page.links | ? href -match $regex64 | Select -First 1
    $version = $matches.Version

    return @{
        Version = $version
        URL32 = 'https://camotics.org' + $url32.href
        URL64 = 'https://camotics.org' + $url64.href
    }
}

function global:au_SearchReplace {
    @{
       "legal\VERIFICATION.txt"  = @{            
            "(?i)(x32: ).*"             = "`${1}$($Latest.URL32)"
            "(?i)(x64: ).*"             = "`${1}$($Latest.URL64)"
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType32)"
            "(?i)(checksum32:).*"       = "`${1} $($Latest.Checksum32)"
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum64)"
        }

        "tools\chocolateyinstall.ps1" = @{        
          "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\)(.*)`"" = "`$1$($Latest.FileName32)`""          
          "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\)(.*)`"" = "`$1$($Latest.FileName64)`""
        }
    }
}

update -ChecksumFor none