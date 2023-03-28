# Copyright (c) 2022 Anthony J. Raymond, MIT License (see manifest for details)

using namespace System.Management.Automation

function Resolve-PSPath {
    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline,
            ParameterSetName = "Path"
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "LiteralPath"
        )]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $LiteralPath,

        [Parameter()]
        [switch]
        $Provider
    )

    ## BEGIN ##################################################################
    begin {
        $ProviderInfo = $DriveInfo = $null
    }

    ## PROCESS ################################################################
    process {
        :Main foreach ($Object in ($Path + $LiteralPath).Where({ $_ })) {
            try {
                if ($PSCmdlet.ParameterSetName -eq "LiteralPath") {
                    $PathInfo = $PSCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Object, [ref] $ProviderInfo, [ref] $DriveInfo)
                } else {
                    try {
                        $PathInfo = $PSCmdlet.SessionState.Path.GetResolvedProviderPathFromPSPath($Object, [ref] $ProviderInfo)
                    } catch {
                        $Parent = Split-Path $_.Exception.InnerException.ItemName -Parent
                        $Leaf = Split-Path $_.Exception.InnerException.ItemName -Leaf

                        if ($Parent) {
                            $PathInfo = $PSCmdlet.SessionState.Path.GetResolvedProviderPathFromPSPath($Parent, [ref] $ProviderInfo).ForEach({ $_.TrimEnd("\") + "\" + $Leaf })
                        } else {
                            throw $_
                        }
                    }
                }

                if ($Provider) {
                    Write-Output $ProviderInfo
                } else {
                    Write-Output $PathInfo
                }
                ## EXCEPTIONS #################################################
            } catch [MethodInvocationException] {
                $PSCmdlet.WriteError(
                    [ErrorRecord]::new(
                        $_.Exception.InnerException,
                        "MethodException",
                        [ErrorCategory]::InvalidOperation,
                        $Item
                    )
                )
                continue Main
            } catch {
                $PSCmdlet.WriteError($_)
                continue Main
            }
        }
    }

    ## END ####################################################################
    end {
    }
}
