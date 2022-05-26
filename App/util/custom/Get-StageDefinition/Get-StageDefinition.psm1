function Get-StageDefinition {
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Stagedefinition (Produktion or Development)")]
        [String]
        $stage
    )

    class StageDefinition {
        [String] $stage;
        [String] $hostname;
        [String] $port;
        [boolean] $https;
        [String] $AuthType;
        [int] $minRunspaces;
        [int] $maxRunspaces;
    }

    [StageDefinition]$stagedef = [StageDefinition]::new()

    switch ($stage) {
        "Development" { 
            $stagedef.hostname = "localhost"
            $stagedef.port = "2070"
            $stagedef.https = $false
            $stagedef.AuthType = "Anonymous"
            $stagedef.minRunspaces = 1
            $stagedef.maxRunspaces = 1
        }
        "Production" { 
            $stagedef.hostname = "localhost"
            $stagedef.port = "443"
            $stagedef.https = $true
            $stagedef.AuthType = "Negotiate"
            $stagedef.minRunspaces = 1
            $stagedef.maxRunspaces = 5
        }
        Default {
            throw "Invalid Stage Definition"
        }
    }

    return $stagedef
}

Export-ModuleMember -Function Get-StageDefinition