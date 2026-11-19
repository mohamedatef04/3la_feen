$rootPath = "f:\Apps\ala_feen\lib"
$files = Get-ChildItem -Path $rootPath -Filter "*_cubit.dart" -Recurse

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
    if ($content -match "emit\(") {
        if ($content -notmatch "safe_emit\.dart") {
            $importStatement = "import 'package:ala_feen/core/utils/safe_emit.dart';`n"
            $lines = $content -split "`r?`n"
            $lastImportIndex = -1
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -like "import *") {
                    $lastImportIndex = $i
                }
            }
            
            if ($lastImportIndex -eq -1) {
                $content = $importStatement + $content
            } else {
                $newLines = @()
                for ($i = 0; $i -le $lastImportIndex; $i++) {
                    $newLines += $lines[$i]
                }
                $newLines += $importStatement.Trim()
                for ($i = $lastImportIndex + 1; $i -lt $lines.Count; $i++) {
                    $newLines += $lines[$i]
                }
                $content = $newLines -join "`r`n"
            }
        }
        
        $content = $content -replace "emit\(", "safeEmit("
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Processed: $($file.FullName)"
    }
}
