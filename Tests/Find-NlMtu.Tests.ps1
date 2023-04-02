Describe "Find-NlMtu" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "${PSScriptRoot}\..\PoshToolbox.psm1"

        ## SETUP ##############################################################
        $NextHop = (Get-NetRoute "0.0.0.0/0").NextHop
        $NlMtu = (Get-NetIPInterface -AddressFamily IPv4 -NeighborDiscoverySupported Yes).NlMtu[0]
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "Address" {
            $Test = Find-NlMtu -ComputerName $NextHop
            $Test.MTU | Should -Be $NlMtu
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "PingException" {
            $Test = { Find-NlMtu -ComputerName "potato" -ErrorAction Stop }
            $Test | Should -Throw "Connection to 'potato' failed."
        }

        It "PingTtlExpired" {
            $Test = { Find-NlMtu -ComputerName "microsoft.com" -MaxHops 1 -ErrorAction Stop }
            $Test | Should -Throw "Connection to 'microsoft.com' failed with status 'TtlExpired.'"
        }

        It "PingNoReply" {
            $Test = { Find-NlMtu -ComputerName "microsoft.com" -Timeout 1 -ErrorAction Stop }
            $Test | Should -Throw "Connection to 'microsoft.com' failed with status 'NoReply.'"
        }
    }

    AfterAll {
        ## CLEAN UP ###########################################################
    }
}
