function New_MethodInvocationException {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Function does not change system state.')]

    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param(
        [Parameter(
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [System.Exception] $Exception,

        [Parameter()]
        [switch] $Throw = $false
    )

    ## LOGIC ###################################################################
    end {
        [System.Management.Automation.ErrorRecord] $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
            $Exception,
            'System.Management.Automation.MethodInvocationException',
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $null
        )

        if ($Throw) {
            throw $ErrorRecord
        }

        $PSCmdlet.WriteObject($ErrorRecord)
    }
}
