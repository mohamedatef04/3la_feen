$rootPath = "f:\Apps\ala_feen\lib"
$files = Get-ChildItem -Path $rootPath -Filter "*.dart" -Recurse

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
    if ($content -match "safesafeEmit\(|SAFESAFEEmit\(") {
        # Replace safesafeEmit( with safeEmit(
        $content = $content -replace "safesafeEmit\(", "safeEmit("
        $content = $content -replace "SAFESAFEEmit\(", "safeEmit("
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Fixed: $($file.FullName)"
    }
}
