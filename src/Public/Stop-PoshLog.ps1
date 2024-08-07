function Stop-PoshLog {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([void])]
    param ()

    ## LOGIC ###################################################################
    end {
        if (-not $PSLogDetails) {
            $PSCmdlet.ThrowTerminatingError(( New_PSInvalidOperationException -Message 'An error occurred stopping the log: The host is not currently logging.' ))
        }

        if ($Events = Get-EventSubscriber | Where-Object SourceIdentifier -CMatch '^PSLog') {
            $Events | Unregister-Event

            $Global:PSDefaultParameterValues.Remove('Write-Information:InformationVariable')
            $Global:PSDefaultParameterValues.Remove('Write-Warning:WarningVariable')
            $Global:PSDefaultParameterValues.Remove('Write-Error:ErrorVariable')
        }

        $DateTime = [datetime]::Now

        $Template = {
            '**********************'
            'Windows PowerShell log end'
            "End time: {0:$( $Format[0] )}" -f $DateTime.($Format[1]).Invoke()
            '**********************'
        }

        foreach ($PSLog in $PSLogDetails) {
            try {
                $Format = $PSLog.Utc | Use-Ternary ('yyyy\-MM\-dd HH:mm:ss\Z', 'ToUniversalTime') ('yyyy\-MM\-dd HH:mm:ss', 'ToLocalTime')

                Use-Object ($File = [System.IO.File]::AppendText($PSLog.Path)) {
                    foreach ($Line in $Template.Invoke()) {
                        $File.WriteLine($Line)
                    }
                }

                Write-Information -InformationAction Continue -MessageData ("Log stopped, output file is '{0}'" -f $PSLog.Path) -InformationVariable null

                ## EXCEPTIONS ##################################################
            } catch [System.Management.Automation.MethodInvocationException] {
                $PSCmdlet.WriteError(( New_MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }

        Remove-Variable -Name PSLog* -Scope Global
    }
}
