import-module au

[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

function global:au_GetLatest {
  $releases = 'https://openmodelica.org/download/download-windows'
  $regex    = '/windows/releases/(?<Version>[\d\./]+).*$'
  # $regexVersion      = '<a href="https://build.openmodelica.org/omc/builds/windows/(releases/)?.*>(?<Version>[\d\.]+)(/[\d]+)?<br />'
  # <a href="https://build.openmodelica.org/omc/builds/windows/releases/1.14/final/"><span style="font-size: 13.3333px;">1.14.0<br />

  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $url           = $download_page.links | ? href -match $regex | Select -First 1
  $version       = $matches.Version -Replace '/', '.'

	return @{
    Version = $version
    URL32   = $url.href + '/32bit/OpenModelica-v' + $version + '-32bit.exe'
    URL64   = $url.href + '/64bit/OpenModelica-v' + $version + '-64bit.exe'
  }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyinstall.ps1" = @{
          "(^(\s)*url\s*=\s*)('.*')"        = "`${1}'$($Latest.URL32)'"
          "(^(\s)*checksum\s*=\s*)('.*')"   = "`${1}'$($Latest.Checksum32)'"
          "(^(\s)*url64\s*=\s*)('.*')"      = "`${1}'$($Latest.URL64)'"
          "(^(\s)*checksum64\s*=\s*)('.*')" = "`${1}'$($Latest.Checksum64)'"
        }
    }
}

update