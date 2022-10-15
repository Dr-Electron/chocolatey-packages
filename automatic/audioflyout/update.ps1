﻿$ErrorActionPreference = 'Stop'
import-module au
. ..\..\helpers\GitHub_Helper.ps1

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
   return github_GetInfo -ArgumentList @{
        repository = 'ADeltaX/AudioFlyout'
        regex32    = 'AudioFlyout.zip'
   }
}

[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

<#function global:au_GetLatest {
    $releases     = 'https://github.com/ADeltaX/AudioFlyout/releases'
    $regex        = 'AudioFlyout.zip'
    $regexVersion = 'AudioFlyout/tree/(?<Version>[\d\.]+)'

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing	
	$url = $download_page.links | ? href -match $regex | Select -First 1
    $download_page.links | ? href -match $regexVersion

    return @{ Version = $matches.Version ; URL32 = 'https://github.com' + $url.href }
}#>

function global:au_SearchReplace {
    @{
       "legal\VERIFICATION.txt"  = @{            
            "(?i)(x32: ).*"             = "`${1}$($Latest.URL32)"
            "(?i)(x64: ).*"             = "`${1}$($Latest.URL32)"            
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType32)"
            "(?i)(checksum32:).*"       = "`${1} $($Latest.Checksum32)"
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum32)"
        }        
    }
}

update -ChecksumFor none