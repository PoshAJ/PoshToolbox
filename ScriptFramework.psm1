# Copyright (c) 2022 Anthony J. Raymond, MIT License (see manifest for details)
# Copyright (c) 2015 Warren Frame, Modified "PowerShell Module Framework" (http://github.com/ramblingcookiemonster)

using namespace System.IO
using namespace System.Management.Automation

$Public = [FileInfo[]] (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter *.ps1 -ErrorAction SilentlyContinue)

foreach ($Function in $Public) {
    try {
        . $Function.FullName
    } catch {
        throw [ErrorRecord]::new(
            ([FileLoadException] "The function '$( $Function.BaseName )' was not loaded because an error occurred."),
            "FunctionUnavailable",
            [ErrorCategory]::ResourceUnavailable,
            $Function.FullName
        )
    }
}

Export-ModuleMember -Function $Public.BaseName -Alias (Get-Alias | Where-Object Source -EQ "ScriptFramework")
