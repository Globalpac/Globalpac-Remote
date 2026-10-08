param(
    [Parameter(Mandatory = $true)]
    [string]$BrandDir
)

$ErrorActionPreference = "Stop"

function Replace-Once {
    param(
        [string]$Path,
        [string]$Old,
        [string]$New
    )
    $text = [System.IO.File]::ReadAllText($Path)
    $count = ([regex]::Matches($text, [regex]::Escape($Old))).Count
    if ($count -ne 1) {
        throw "Esperava 1 ocorrencia em ${Path}, achei ${count}: ${Old}"
    }
    $updated = $text.Replace($Old, $New)
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($Path, $updated, $utf8)
}

$root = (Get-Location).Path
$brand = (Resolve-Path $BrandDir).Path

Replace-Once `
    -Path (Join-Path $root "libs\hbb_common\src\config.rs") `
    -Old 'RwLock::new("RustDesk".to_owned())' `
    -New 'RwLock::new("Globalpac".to_owned())'

Replace-Once `
    -Path (Join-Path $root "libs\hbb_common\src\config.rs") `
    -Old '&["rs-ny.rustdesk.com"]' `
    -New '&["rustdesk.globalpac.com.br"]'

Replace-Once `
    -Path (Join-Path $root "libs\hbb_common\src\config.rs") `
    -Old 'OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw=' `
    -New 'kwrVksGnr7O5FGpxqiPTGWKsi2mksEtI7B1DvoHfykc='

$runner = Join-Path $root "flutter\windows\runner\Runner.rc"
Replace-Once -Path $runner -Old 'VALUE "FileDescription", "RustDesk Remote Desktop"' -New 'VALUE "FileDescription", "Globalpac Remote Desktop"'
Replace-Once -Path $runner -Old 'VALUE "ProductName", "RustDesk"' -New 'VALUE "ProductName", "Globalpac"'
Replace-Once -Path $runner -Old 'VALUE "CompanyName", "Purslane Tech Pte. Ltd."' -New 'VALUE "CompanyName", "Globalpac"'

Copy-Item (Join-Path $brand "app_icon.ico") (Join-Path $root "res\icon.ico") -Force
Copy-Item (Join-Path $brand "app_icon.ico") (Join-Path $root "res\tray-icon.ico") -Force
Copy-Item (Join-Path $brand "app_icon.ico") (Join-Path $root "flutter\windows\runner\resources\app_icon.ico") -Force
Copy-Item (Join-Path $brand "icon.png") (Join-Path $root "res\icon.png") -Force
Copy-Item (Join-Path $brand "icon.png") (Join-Path $root "flutter\assets\icon.png") -Force
Copy-Item (Join-Path $brand "logo.png") (Join-Path $root "flutter\assets\logo.png") -Force
Copy-Item (Join-Path $brand "logo.png") (Join-Path $root "flutter\assets\logo_light.png") -Force

Write-Host "Marca Globalpac aplicada em $root"
