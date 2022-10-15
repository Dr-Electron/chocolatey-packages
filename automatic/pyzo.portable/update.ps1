﻿$ErrorActionPreference = 'Stop'
import-module au
. ..\..\helpers\GitHub_Helper.ps1

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
   return github_GetInfo -ArgumentList @{
        repository = 'pyzo/pyzo'
        regex32    = 'pyzo-[\d\.]+-win32.zip$'        
        regex64  = 'pyzo-(?<Version>[\d\.]+)-win64.zip$'
   }
}

<#function global:au_GetLatest {
    $github_repository = 'pyzo/pyzo'
    $releases = 'https://github.com/' + $github_repository + '/releases/latest'
    #$regex_win7 = 'pyzo-([\d\.]+)-win64-windows7.zip$'
    $regex32  = 'pyzo-[\d\.]+-win32.zip$'
    $regex64  = 'pyzo-(?<Version>[\d\.]+)-win64.zip$'

    $download_page = (Invoke-WebRequest -Uri $releases -UseBasicParsing).links
    #$url_win7 = $download_page | ? href -match $regex_win7 | Select -First 1
    $url32 = $download_page | ? href -match $regex32 | Select -First 1
    $url64 = $download_page | ? href -match $regex64 | Select -First 1

    return @{
        Version = $matches.Version
        URL32   = 'https://github.com' + $url32.href
        URL64   = 'https://github.com' + $url64.href
    }
}#>

function global:au_SearchReplace {    
    @{
        "legal\VERIFICATION.txt"  = @{            
            "(?i)(x32: ).*"             = "`${1}$($Latest.URL32)"
            "(?i)(x64: ).*"             = "`${1}$($Latest.URL64)"
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType64)"
            "(?i)(checksum32:).*"       = "`${1} $($Latest.Checksum32)"
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum64)"
        }

        "tools\chocolateyinstall.ps1" = @{
          "(?i)(^\s*file32\s*=\s*`"[$]toolsDir\\)(.*)`"" = "`${1}$($Latest.FileName32)`""
          "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\)(.*)`"" = "`${1}$($Latest.FileName64)`""
          "([$]toolsDir\ `"pyzo-)[\d\.]+(\\pyzo.exe)"    = "`${1}$($Latest.Version)`${2}"
        }
    }
}

update -ChecksumFor none
