Describe "Split-File" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "${PSScriptRoot}\..\PoshToolbox.psm1"

        ## SETUP ##############################################################
        Push-Location -Path "${PSScriptRoot}\Files"
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Test = Split-File -Path "*.file" -Size 5MB
            $Test.Count | Should -Be 5
            $Test.Name | Should -BeLike "25MB.file.*split"
        }

        It "LiteralPath" {
            $Test = Split-File -LiteralPath "25MB.file" -Size 5MB
            $Test.Count | Should -Be 5
            $Test.Name | Should -BeLike "25MB.file.*split"
        }

        It "Path & Destination" {
            $Test = Split-File -Path "*.file" -Size 5MB -Destination "Copy\"
            $Test.Count | Should -Be 5
            $Test.Name | Should -BeLike "25MB.file.*split"
        }

        It "LiteralPath & Destination" {
            $Test = Split-File -LiteralPath "25MB.file" -Size 5MB -Destination "Copy\"
            $Test.Count | Should -Be 5
            $Test.Name | Should -BeLike "25MB.file.*split"
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "DirectoryNotFoundException" {
            $Test = { Split-File -Path "25MB.file" -Size 5MB -Destination "\\fake\potato" -ErrorAction Stop }
            $Test | Should -Throw "Could not find a part of the path '\\fake\potato'."
        }

        It "UnauthorizedAccessException" {
            $Test = { Split-File -Path "25MB.file" -Size 5MB -Destination "C:\Config.Msi\" -ErrorAction Stop }
            $Test | Should -Throw "Access to the path 'C:\Config.Msi\25MB.file.1split' is denied."
        }
    }

    AfterAll {
        ## CLEAN UP ###########################################################
        Remove-Item -Path "Copy\" -Recurse
        Pop-Location
    }
}
