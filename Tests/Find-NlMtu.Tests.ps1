BeforeAll {
    ## SOURCE #################################################################
    Import-Module "${PSScriptRoot}\..\PoshToolbox\PoshToolbox.psm1"

    ## SETUP ##################################################################
    $NextHop = (Get-NetRoute "0.0.0.0/0").NextHop
    $NlMtu = (Get-NetIPInterface -AddressFamily IPv4 -NeighborDiscoverySupported Yes).NlMtu[0]
}

Describe "Find-NlMtu" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "Local" {
            $Result = Find-NlMtu -ComputerName $NextHop

            $Result.MTU | Should -Be $NlMtu
        }
        It "Remote" {
            $Result = Find-NlMtu -ComputerName "bing.com"

            $Result.MTU | Should -Be $NlMtu
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "PingException" {
            $Test = { Find-NlMtu -ComputerName "throw.error" -ErrorAction Stop }

            $Test | Should -Throw "Connection to 'throw.error' failed."
        }

        It "PingTtlExpired" {
            $Test = { Find-NlMtu -ComputerName "bing.co.kr" -MaxHops 1 -ErrorAction Stop }

            $Test | Should -Throw "Connection to 'bing.co.kr' failed with status 'TtlExpired.'"
        }

        It "PingNoReply" {
            $Test = { Find-NlMtu -ComputerName "bing.co.kr" -Timeout 1 -ErrorAction Stop }

            $Test | Should -Throw "Connection to 'bing.co.kr' failed with status 'NoReply.'"
        }
    }
}
