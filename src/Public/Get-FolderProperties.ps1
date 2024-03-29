function Get-FolderProperties {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification='Named to match Windows context menu.')]

    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "Path"
        )]
        [ValidateScript({
                if (Test-Path -Path $_ -PathType Container) {
                    return $true
                }
                throw "The argument specified must resolve to a valid folder path."
            })]
        [string[]]
        $Path,

        [Alias("PSPath")]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "LiteralPath"
        )]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -PathType Container) {
                    return $true
                }
                throw "The argument specified must resolve to a valid folder path."
            })]
        [string[]]
        $LiteralPath,

        [Parameter()]
        [ValidateSet(
            "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB", # Decimal Metric (Base 10)
            "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB" # Binary IEC (Base 2)
        )]
        [string]
        $Unit = "MiB"
    )

    ## BEGIN ##################################################################
    begin {
        $Prefix = @{
            [char] "K" = 1 # kilo
            [char] "M" = 2 # mega
            [char] "G" = 3 # giga
            [char] "T" = 4 # tera
            [char] "P" = 5 # peta
            [char] "E" = 6 # exa
            [char] "Z" = 7 # zetta
            [char] "Y" = 8 # yotta
        }

        $Base = $Unit.Contains("i") | Use-Ternary { 1024 } { 1000 }
        $Divisor = [System.Math]::Pow($Base, $Prefix[$Unit[0]])
    }

    ## PROCESS ################################################################
    process {
        $Process = ($PSCmdlet.ParameterSetName -cmatch "^LiteralPath") | Use-Ternary { Resolve-PoshPath -LiteralPath $LiteralPath } { Resolve-PoshPath -Path $Path }

        foreach ($Object in $Process) {
            try {
                if ($Object.Provider.Name -ne "FileSystem") {
                    New-ArgumentException "The argument specified must resolve to a valid path on the FileSystem provider." -Throw
                }

                $Folder = [System.IO.DirectoryInfo] $Object.ProviderPath

                Write-Verbose ("GET {0}" -f $Folder)
                $Dirs = $Files = $Bytes = 0
                # https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
                $Result = robocopy $Folder.FullName.TrimEnd("\") \\null /l /e /np /xj /r:0 /w:0 /bytes /nfl /ndl

                if (($LASTEXITCODE -eq 16) -and ($Result[-2] -eq "Access is denied.")) {
                    New-UnauthorizedAccessException -Message ("Access to the path '{0}' is denied." -f $Folder) -Throw
                } elseif ($LASTEXITCODE -eq 16) {
                    New-ArgumentException -Message ("The specified path '{0}' is invalid." -f $Folder) -Throw
                }

                switch -Regex ($Result) {
                    "Dirs :\s+(\d+)" { $Dirs = [double] $Matches[1] - 1 }
                    "Files :\s+(\d+)" { $Files = [double] $Matches[1] }
                    "Bytes :\s+(\d+)" { $Bytes = [double] $Matches[1] }
                }

                Write-Output ([pscustomobject] @{
                        FullName = $Folder.FullName
                        Length   = $Bytes
                        Size     = "{0:n2} {1}" -f ($Bytes / $Divisor), $Unit
                        Contains = "{0} Files, {1} Folders" -f $Files, $Dirs
                        Created  = "{0:F}" -f $Folder.CreationTime
                    })

                ## EXCEPTIONS #################################################
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }

    ## END ####################################################################
    end {
    }
}
