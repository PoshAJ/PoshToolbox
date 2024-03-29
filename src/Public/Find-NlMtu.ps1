function Find-NlMtu {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectUsageOfAssignmentOperator', '', Justification='Assignment Operator is intended.')]

    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Alias("Hostname", "IPAddress", "Address")]
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName,

        [Parameter()]
        [ValidateRange(1, [int32]::MaxValue)]
        [int32]
        $Timeout = 10000,

        [Alias("Ttl", "TimeToLive", "Hops")]
        [Parameter()]
        [ValidateRange(1, [int32]::MaxValue)]
        [int32]
        $MaxHops = 128
    )

    ## BEGIN ##################################################################
    begin {
        $PingOptions = [System.Net.NetworkInformation.PingOptions]::new($MaxHops, $true)
    }

    ## PROCESS ################################################################
    process {
        foreach ($Computer in $ComputerName) {
            try {
                Use-Object ($Ping = [System.Net.NetworkInformation.Ping]::new()) {
                    $UpperBound = 65500
                    $LowerBound = 1

                    $Size = 9000
                    $Buffer = [byte[]]::new($Size)

                    $Result = [System.Collections.Generic.List[System.Net.NetworkInformation.PingReply]]::new()

                    while ($Size -ne $LowerBound) {
                        try {
                            Write-Verbose ("PING {0} with {1}-byte payload" -f $Computer, $Size)
                            $Reply = $Ping.Send($Computer, $Timeout, $Buffer, $PingOptions)
                        } catch {
                            New-InvalidOperationException -Message ("Connection to '{0}' failed." -f $Computer) -Throw
                        }

                        switch ($Reply.Status) {
                            "PacketTooBig" { $UpperBound = $Size }
                            "Success" { $LowerBound = $Size }
                            "TimedOut" { $UpperBound = $Size }
                            default {
                                New-InvalidOperationException -Message ("Connection to '{0}' failed with status '{1}.'" -f $Computer, $Reply.Status) -Throw
                            }
                        }

                        $Result.Add($Reply)

                        if (($Size = [System.Math]::Floor(($LowerBound + $UpperBound) / 2)) -eq 1) {
                            New-InvalidOperationException -Message ("Connection to '{0}' failed with status 'NoReply.'" -f $Computer) -Throw
                        }

                        [array]::Resize([ref] $Buffer, $Size)
                    }

                    if (($Hops = $MaxHops - $Result.Where({ $_.Status -eq "Success" })[-1].Options.Ttl) -lt 0) {
                        $Hops = 0
                    }

                    Write-Output ([pscustomobject] @{
                            ComputerName = $Computer
                            ReplyFrom    = $Result.Where({ $_.Status -eq "Success" })[-1].Address
                            "Time(ms)"   = [int] ($Result.Where({ $_.Status -eq "Success" }).RoundtripTime | Measure-Object -Average).Average
                            Hops         = $Hops
                            # IP Header (20 bytes) + ICMP Header (8 bytes) = 28 bytes
                            MTU          = $Size + 28
                        })
                }

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
