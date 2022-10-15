﻿import-module au
. ..\..\helpers\GitHub_Helper.ps1

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
   return github_GetInfo -ArgumentList @{
        repository = 'GNS3/gns3-gui'
        regex32    = '/releases/download/.*/GNS3-(?<Version>[\d\.]*)[\w-]*.exe$'        
   }
}

function global:au_SearchReplace {
    @{
       "legal\VERIFICATION.txt"  = @{            
            "(?i)(x32: ).*"             = "`${1}$($Latest.URL32)"
            "(?i)(x64: ).*"             = "`${1}$($Latest.URL32)"            
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType32)"
            "(?i)(checksum32:).*"       = "`${1} $($Latest.Checksum32)"
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum32)"
        }

        "tools\chocolateyinstall.ps1" = @{
          "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
        }

        "tools\chocolateyinstall.ahk" = @{
            "(^\s*GNS_Version\s*=\s).*" = "`${1}$($Latest.Version)"
        }

        "tools\chocolateyuninstall.ahk" = @{
            "(^\s*GNS_Version\s*=\s).*" = "`${1}$($Latest.Version)"
        }
    }
}

update -ChecksumFor none