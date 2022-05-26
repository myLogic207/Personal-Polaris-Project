# (Custom) Modules Used
Using module './util/Get-StageDefinition/Get-StageDefinition.psm1'
Using module './util/Polaris/PSScriptAnalyzerSettings.psd1'

$config = Get-Content -Path "./config.json" | ConvertFrom-Json
$stagevars = Get-StageDefinition -stage $config.stage


# Actual Polaris Part
Stop-Polaris
Clear-Polaris

if($stagevars.https){
    $app = Start-Polaris -hostname $stagevars.hostname -Port $stagevars.port -MinRunspaces $stagevars.MinRunspaces -MaxRunspaces $stagevars.MaxRunspaces -UseJsonBodyParserMiddleware -Verbose -Https
} else {
    $app = Start-Polaris -hostname $stagevars.hostname -Port $stagevars.port -MinRunspaces $stagevars.MinRunspaces -MaxRunspaces $stagevars.MaxRunspaces -UseJsonBodyParserMiddleware -Verbose
}

while ($app.Listener.IsListening) {
    Wait-Event callbackeventbridge.callbackcomplete
 }