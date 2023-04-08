# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

using namespace System.IO

function Join-File {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline,
            ParameterSetName = "Path"
        )]
        [ValidateScript({
                if (Test-Path -Path $_ -PathType Leaf -Filter *.*split) {
                    return $true
                }
                throw "The argument specified must resolve to a valid split type file."
            })]
        [string[]]
        $Path,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "LiteralPath"
        )]
        [Alias("PSPath")]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -PathType Leaf -Filter *.*split) {
                    return $true
                }
                throw "The argument specified must resolve to a valid split type file."
            })]
        [string[]]
        $LiteralPath,

        [Parameter()]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -IsValid) {
                    return $true
                }
                throw "The argument specified must resolve to a valid file or folder path."
            })]
        [string]
        $Destination = (Get-Location -PSProvider FileSystem).ProviderPath
    )

    ## BEGIN ##################################################################
    begin {
        $DestinationInfo = [FileInfo] (Resolve-PoshPath -LiteralPath $Destination).ProviderPath
    }

    ## PROCESS ################################################################
    process {
        $ParameterSet = @{ $PSCmdlet.ParameterSetName = $PSBoundParameters[$PSCmdlet.ParameterSetName] }
        $Process = Resolve-PoshPath @ParameterSet

        foreach ($Object in $Process) {
            try {
                if ($Object.Provider.Name -ne "FileSystem") {
                    New-ArgumentException "The argument specified must resolve to a valid path on the FileSystem provider." -Throw
                }

                $File = [FileInfo] $Object.ProviderPath

                $CalculatedDestination = $DestinationInfo.Extension | ?: { $DestinationInfo } { "{0}\{1}" -f $DestinationInfo.FullName.TrimEnd("\"), $File.BaseName }

                if ($PSCmdlet.ShouldProcess($CalculatedDestination, "Write Content")) {
                    if (-not ($Directory = $DestinationInfo.Extension | ?: { $DestinationInfo.Directory } { $DestinationInfo }).Exists) {
                        $null = [Directory]::CreateDirectory($Directory)
                    }

                    Write-Verbose ("WRITE {0}" -f $CalculatedDestination)
                    Use-Object ($Writer = [File]::OpenWrite($CalculatedDestination)) {
                        # sort to fix ChildItem number sorting
                        foreach ($SplitFile in (Get-ChildItem -Path ("{0}\{1}.*split" -f $File.Directory, $File.BaseName)).FullName | Sort-Object -Property @{e = { [int32] [regex]::Match($_, "\.(\d+)split$").Groups[1].Value } }) {
                            Write-Verbose ("READ {0}" -f $SplitFile)
                            $Bytes = [File]::ReadAllBytes($SplitFile)
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
