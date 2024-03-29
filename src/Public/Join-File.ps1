function Join-File {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Path'
        )]
        [ValidateScript({
                if (Test-Path -Path $_ -PathType Leaf -Filter *.*split) {
                    return $true
                }
                throw 'The argument specified must resolve to a valid split type file.'
            })]
        [string[]]
        $Path,

        [Alias('PSPath')]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'LiteralPath'
        )]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -PathType Leaf -Filter *.*split) {
                    return $true
                }
                throw 'The argument specified must resolve to a valid split type file.'
            })]
        [string[]]
        $LiteralPath,

        [Parameter()]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -IsValid) {
                    return $true
                }
                throw 'The argument specified must resolve to a valid file or folder path.'
            })]
        [string]
        $Destination = (Get-Location -PSProvider FileSystem).ProviderPath
    )

    ## BEGIN ##################################################################
    begin {
        $DestinationInfo = [System.IO.FileInfo] (Resolve-PoshPath -LiteralPath $Destination).ProviderPath
    }

    ## PROCESS ################################################################
    process {
        $Process = ($PSCmdlet.ParameterSetName -cmatch '^LiteralPath') | Use-Ternary { Resolve-PoshPath -LiteralPath $LiteralPath } { Resolve-PoshPath -Path $Path }

        foreach ($Object in $Process) {
            try {
                if ($Object.Provider.Name -ne 'FileSystem') {
                    New-ArgumentException 'The argument specified must resolve to a valid path on the FileSystem provider.' -Throw
                }

                $File = [System.IO.FileInfo] $Object.ProviderPath

                $CalculatedDestination = $DestinationInfo.Extension | Use-Ternary { $DestinationInfo } { '{0}/{1}' -f $DestinationInfo.FullName.TrimEnd('\/'), $File.BaseName }

                if ($PSCmdlet.ShouldProcess($CalculatedDestination, 'Write Content')) {
                    if (-not ($Directory = $DestinationInfo.Extension | Use-Ternary { $DestinationInfo.Directory } { $DestinationInfo }).Exists) {
                        $null = [System.IO.Directory]::CreateDirectory($Directory)
                    }

                    Write-Verbose ('WRITE {0}' -f $CalculatedDestination)
                    Use-Object ($Writer = [System.IO.File]::OpenWrite($CalculatedDestination)) {
                        # sort to fix ChildItem number sorting
                        foreach ($SplitFile in (Get-ChildItem -Path ('{0}/{1}.*split' -f $File.Directory, $File.BaseName)).FullName | Sort-Object -Property @{e = { [int32] [regex]::Match($_, '\.(\d+)split$').Groups[1].Value } }) {
                            Write-Verbose ('READ {0}' -f $SplitFile)
                            $Bytes = [System.IO.File]::ReadAllBytes($SplitFile)
                            $Writer.Write($Bytes, 0, $Bytes.Length)
                        }
                    }
                }

                Write-Output (Get-ChildItem -Path $CalculatedDestination)

                ## EXCEPTIONS #################################################
            } catch [System.Management.Automation.MethodInvocationException] {
                $PSCmdlet.WriteError(( New-MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }

    ## END ####################################################################
    end {
    }
}
