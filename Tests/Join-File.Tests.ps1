Describe "Join-File" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "${PSScriptRoot}\..\PoshToolbox.psm1"

        ## SETUP ##############################################################
        Push-Location -Path "${PSScriptRoot}\Files"

        $File = Get-FileHash -Path "25MB.file"
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Test = Get-FileHash (Join-File -Path "*.file.1split")
            $Test.Hash | Should -Be $File.Hash
            $Test.Path | Should -BeLike "*\25MB.file"
        }

        It "LiteralPath" {
            $Test = Get-FileHash (Join-File -LiteralPath "25MB.file.1split")
            $Test.Hash | Should -Be $File.Hash
            $Test.Path | Should -BeLike "*\25MB.file"
        }

        It "Path & Destination" {
            $Test = Get-FileHash (Join-File -Path "*.file.1split" -Destination "25MB.copy")
            $Test.Hash | Should -Be $File.Hash
            $Test.Path | Should -BeLike "*\25MB.copy"
        }

        It "LiteralPath & Destination" {
            $Test = Get-FileHash (Join-File -LiteralPath "25MB.file.1split" -Destination "25MB.copy")
            $Test.Hash | Should -Be $File.Hash
            $Test.Path | Should -BeLike "*\25MB.copy"
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "DirectoryNotFoundException" {
            $Test = { Join-File -Path "25MB.file.1split" -Destination "\\fake\potato" -ErrorAction Stop }
            $Test | Should -Throw "Could not find a part of the path '\\fake\potato'."
        }

        It "UnauthorizedAccessException" {
            $Test = { Join-File -Path "25MB.file.1split" -Destination "C:\Config.Msi\" -ErrorAction Stop }
            $Test | Should -Throw "Access to the path 'C:\Config.Msi\25MB.file' is denied."
        }
    }

    AfterAll {
        ## CLEAN UP ###########################################################
        Remove-Item -Path "25MB.copy"
        Pop-Location
    }
}
