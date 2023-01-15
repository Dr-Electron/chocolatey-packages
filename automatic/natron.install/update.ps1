﻿import-module au
. ..\..\helpers\GitHub_Helper.ps1

function global:au_GetLatest {  
    $data = github_GetInfo -ArgumentList @{
        repository = 'NatronGitHub/Natron'        
        regex64    = 'Natron-(?<Version>[\d\.]+)-Windows-x86_64.zip'
    }

    return @{        
        URL64   = $data.URL64
        Version = $data.Version
    }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyinstall.ps1" = @{
          "(^(\s)*url64\s*=\s*)('.*')"          = "`${1}'$($Latest.URL64)'"
          "(^(\s)*checksum64\s*=\s*)('.*')"     = "`${1}'$($Latest.Checksum64)'"          
        }
    }
}

If ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
    update -NoCheckUrl -ChecksumFor 64
}