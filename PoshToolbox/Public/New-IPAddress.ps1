# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

function New-IPAddress {
    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Alias("Address")]
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline
        )]
        [string[]]
        $IPAddress
    )

    ## PROCESS ################################################################
    process {
        foreach ($Address in $IPAddress) {
            try {
                Write-Output ([ipaddress]::Parse($Address))

                ## EXCEPTIONS #################################################
            } catch [System.Management.Automation.MethodInvocationException] {
                $PSCmdlet.WriteError(( New-MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
