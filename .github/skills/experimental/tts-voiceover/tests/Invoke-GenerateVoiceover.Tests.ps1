#Requires -Modules Pester
# Copyright (c) 2026 Microsoft Corporation. All rights reserved.
# SPDX-License-Identifier: MIT

<#
.SYNOPSIS
    Pester tests for the tts-voiceover generation wrappers.
.DESCRIPTION
    Covers wrapper parameter handling and argument forwarding without
    creating a virtual environment or contacting Azure Speech.
#>

BeforeAll {
    $script:SkillRoot = Split-Path -Parent $PSScriptRoot
    $script:PowerShellWrapper = Join-Path $script:SkillRoot 'scripts/Invoke-GenerateVoiceover.ps1'
    $script:BashWrapper = Join-Path $script:SkillRoot 'scripts/generate-voiceover.sh'
}

Describe 'Invoke-GenerateVoiceover.ps1 wrapper' -Tag 'Unit' {
    It 'Declares a CollapseNewlines switch' {
        $command = Get-Command -Name $script:PowerShellWrapper
        $command.Parameters['CollapseNewlines'].ParameterType | Should -Be ([switch])
    }

    It 'Forwards --collapse-newlines only when the switch is set' {
        $scriptContent = Get-Content -Path $script:PowerShellWrapper -Raw
        $scriptContent | Should -Match "if \(\`$CollapseNewlines\) \{ \`$PythonArgs \+= '--collapse-newlines' \}"
    }
}

Describe 'generate-voiceover.sh wrapper' -Tag 'Unit' {
    It 'Documents --collapse-newlines in its usage text' {
        Get-Content -Path $script:BashWrapper -Raw | Should -Match '--collapse-newlines'
    }
}
