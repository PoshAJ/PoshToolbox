Describe "Use-Ternary" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "${PSScriptRoot}\..\PoshToolbox.psm1"
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "True" {
            $Test = $true | ?: { "VALUE" } { 1 / 0 }
            $Test | Should -Be "VALUE"
        }

        It "False" {
            $Test = $false | ?: { 1 / 0 } { "VALUE" }
            $Test | Should -Be "VALUE"
        }
    }
}
