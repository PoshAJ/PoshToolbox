function Use-ErrorCoalescing {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [Alias("?!")]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [scriptblock]
        $InputObject,

        [Parameter(
            Position = 0,
            Mandatory
        )]
        [object]
        $IfError
    )

    ## PROCESS ################################################################
    process {
        # wrapping in an array to handle $null as input
        foreach ($Object in @($InputObject)) {
            try {
                . $Object
            } catch {
                if ($IfError -is [scriptblock]) {
                    . $IfError
                } else {
                    Write-Output $IfError -NoEnumerate
                }
            }
        }
    }
}