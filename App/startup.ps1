# (Custom) Modules Used
Using module './util/custom/Get-StageDefinition/Get-StageDefinition.psm1'
Using module './util/Polaris/Polaris.psd1'

$config = Get-Content -Path './config.json' | ConvertFrom-Json
$stagevars = Get-StageDefinition -stage $config.stage


# Actual Polaris Part
# Clearing Old Polaris
Stop-Polaris
Clear-Polaris

# Defining Routes
# Static Frontend Pages
New-PolarisStaticRoute -RoutePath '/' -FolderPath './frontend'

# API Routes


# Define the parameters and values to give to Send-MailMessage.
$parameters = @{
    Port = $stagevars.port;
    MinRunspaces = $stagevars.MinRunspaces;
    MaxRunspaces = $stagevars.MaxRunspaces;
    UseJsonBodyParserMiddleware = $stagevars.jsonParser;
    Auth = $stagevars.AuthType;
    Verbose = $stagevars.verbose;
    Https = $stagevars.https;
}
# Hostname requires Admin Privileges!
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if ($null -ne $stagevars.hostname -and $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $parameters.Hostname = $stagevars.hostname;
}
$app = Start-Polaris @parameters

# final loop to keep app running
while ($app.Listener.IsListening) {
    Wait-Event callbackeventbridge.callbackcomplete
 }