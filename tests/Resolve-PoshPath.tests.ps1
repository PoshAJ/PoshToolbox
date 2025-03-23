Describe 'Resolve-PoshPath' {
    BeforeAll {
        Push-Location -Path 'TestDrive:/'

        $Path = Get-Item '*'
        $LiteralPath = Get-Item -LiteralPath '.'
    }

    Context 'Success' {
        It 'Path' {
            $Result = Resolve-PoshPath -Path '*'

            $Result.ProviderPath | Should -Be $Path.FullName
        }

        It 'LiteralPath' {
            $Result = Resolve-PoshPath -LiteralPath '.'

            $Result.ProviderPath | Should -Be $LiteralPath.FullName
        }
    }

    AfterAll { Pop-Location }
}
