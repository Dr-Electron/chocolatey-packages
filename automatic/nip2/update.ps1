﻿import-module au
. ..\..\helpers\GitHub_Helper.ps1

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
   return github_GetInfo -ArgumentList @{
        repository = 'libvips/nip2'
        regex32    = 'nip2-(?<Version>[\d\.]*)-setup.zip$'
        exclude_versions = @('8.9.1')
   }
}

function global:au_SearchReplace {
    @{
        "legal\VERIFICATION.txt"  = @{            
            "(?i)(x32).*"      = "`${1}$($Latest.URL32)"
            "(?i)(x64).*"      = "`${1}$($Latest.URL32)"
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType32)"
            "(?i)(checksum32:).*"       = "`${1} $($Latest.Checksum32)"
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum32)"
        }

        "tools\chocolateyinstall.ps1" = @{			
            "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\)(.*)`""   = "`$1$($Latest.FileName32)`""
            "(?i)(^\s*fileFullPath\s*=\s*`"[$]toolsDir\\nip2-)[\d\.]+(.*)`""   = "`$1$($Latest.Version)`$2`""
        }
    }
}

update -ChecksumFor none -NoHostOutput