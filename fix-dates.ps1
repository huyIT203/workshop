# Fix date format in all markdown files
$files = Get-ChildItem -Path "content" -Filter "*.md" -Recurse

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match 'date\s*:\s*"`r Sys\.Date\(\)`"') {
        $newContent = $content -replace 'date\s*:\s*"`r Sys\.Date\(\)`"', 'date: "2024-01-01"'
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "Fixed date in: $($file.FullName)"
    }
}

Write-Host "Date format fix completed!" 