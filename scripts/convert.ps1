# Raw Artifact Converter - PowerShell Version
# Usage: .\convert.ps1
#
# Converts PDF, DOCX, PPTX, Excel to Markdown for Copilot processing.
# Requires: pandoc (install via: choco install pandoc or winget install Pandoc.Pandoc)

param(
    [string]$InputDir = "raw-artifacts",
    [string]$OutputDir = "raw-artifacts\converted"
)

$Green = "`e[92m"
$Yellow = "`e[93m"
$Red = "`e[91m"
$Reset = "`e[0m"

function Write-Info { param($msg) Write-Host "${Green}[INFO]${Reset} $msg" }
function Write-Warn { param($msg) Write-Host "${Yellow}[WARN]${Reset} $msg" }
function Write-Err  { param($msg) Write-Host "${Red}[ERROR]${Reset} $msg" }

# Check pandoc
$pandoc = Get-Command pandoc -ErrorAction SilentlyContinue
if (-not $pandoc) {
    Write-Err "pandoc not found. Install with: choco install pandoc"
    exit 1
}

Write-Info "Using: $(pandoc.Source)"

# Resolve paths
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $scriptDir
$inputPath = Join-Path $projectDir $InputDir
$outputPath = Join-Path $projectDir $OutputDir

# Create directories
New-Item -ItemType Directory -Force -Path $outputPath | Out-Null
$imagesPath = Join-Path $inputPath "images"
New-Item -ItemType Directory -Force -Path $imagesPath | Out-Null

Write-Info "Input: $inputPath"
Write-Info "Output: $outputPath"
Write-Host ""

$converted = 0
$failed = 0

# Helper function to convert file
function Convert-File {
    param($inputFile, $outputFile, $type)
    
    if (-not (Test-Path $inputFile)) { return $false }
    
    try {
        $result = & pandoc $inputFile -t markdown -o $outputFile 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Info "$($inputFile.Name) -> $($outputFile.Name)"
            $script:converted++
            return $true
        }
    }
    catch { }
    Write-Err "$($inputFile.Name) -> FAILED"
    $script:failed++
    return $false
}

# Convert PDFs
Write-Host "Converting PDFs..." -ForegroundColor Cyan
Get-ChildItem $inputPath -Filter "*.pdf" | ForEach-Object {
    $outFile = Join-Path $outputPath "$($_.BaseName).md"
    Convert-File $_.FullName $outFile "PDF"
}

# Convert DOCX
Write-Host "Converting DOCX files..." -ForegroundColor Cyan
Get-ChildItem $inputPath -Filter "*.docx" | ForEach-Object {
    $outFile = Join-Path $outputPath "$($_.BaseName).md"
    Convert-File $_.FullName $outFile "DOCX"
}

# Convert PPTX
Write-Host "Converting PPTX files..." -ForegroundColor Cyan
Get-ChildItem $inputPath -Filter "*.pptx" | ForEach-Object {
    $outFile = Join-Path $outputPath "$($_.BaseName).md"
    $tempFile = Join-Path $outputPath "$($_.BaseName)_temp.md"
    
    & pandoc $_.FullName -t markdown --wrap=none 2>$null | Out-File $tempFile -Encoding UTF8
    
    if ($LASTEXITCODE -eq 0) {
        @"
# Presentation: $($_.BaseName)

_Converted from PowerPoint_

---

"@ | Out-File $outFile -Encoding UTF8 -Append
        Get-Content $tempFile | ForEach-Object { 
            $_.Replace('# ', '## Slide: ') | Out-File $outFile -Encoding UTF8 -Append 
        }
        Remove-Item $tempFile -Force
        Write-Info "$($_.Name) -> $($_.BaseName).md"
        $converted++
    }
    else {
        Write-Err "$($_.Name) -> FAILED"
        $failed++
    }
}

# Convert Excel
Write-Host "Converting Excel files..." -ForegroundColor Cyan
Get-ChildItem $inputPath -Filter "*.xlsx" | ForEach-Object {
    $outFile = Join-Path $outputPath "$($_.BaseName).md"
    
    @"
# Excel: $($_.BaseName)

_Converted from Excel spreadsheet_

---

"@ | Out-File $outFile -Encoding UTF8
    
    & pandoc $_.FullName -t markdown 2>$null | Out-File $outFile -Encoding UTF8 -Append
    
    if ($LASTEXITCODE -eq 0) {
        Write-Info "$($_.Name) -> $($_.BaseName).md"
        $converted++
    }
    else {
        Write-Err "$($_.Name) -> FAILED"
        $failed++
    }
}

# Copy Markdown files
Write-Host "Copying Markdown files..." -ForegroundColor Cyan
Get-ChildItem $inputPath -Filter "*.md" | ForEach-Object {
    $outFile = Join-Path $outputPath $_.Name
    Copy-Item $_.FullName $outFile -Force
    Write-Info "Copied: $($_.Name)"
    $converted++
}

# Copy CSV files
Write-Host "Copying CSV files..." -ForegroundColor Cyan
Get-ChildItem $inputPath -Filter "*.csv" | ForEach-Object {
    $outFile = Join-Path $outputPath $_.Name
    Copy-Item $_.FullName $outFile -Force
    Write-Info "Copied: $($_.Name)"
    $converted++
}

# Handle images
Write-Host "Creating image references..." -ForegroundColor Cyan
foreach ($ext in @('*.png', '*.jpg', '*.jpeg', '*.gif')) {
    Get-ChildItem $inputPath -Filter $ext | ForEach-Object {
        # Copy to images folder
        Copy-Item $_.FullName $imagesPath -Force
        
        $outFile = Join-Path $outputPath "$($_.BaseName)-image.md"
        
        @"
# Image: $($_.Name)

![$($_.Name)](../raw-artifacts/images/$($_.Name))

## Description
_TODO: Describe what this diagram/screenshot shows_

## Key Elements
- _TODO: List key elements visible in image_
"@ | Out-File $outFile -Encoding UTF8
        
        Write-Info "Image reference: $($_.Name)"
        $converted++
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor White
Write-Host "Conversion Summary" -ForegroundColor White
Write-Host "========================================" -ForegroundColor White
Write-Host "Converted: $converted files"
if ($failed -gt 0) {
    Write-Host "Failed: $failed files" -ForegroundColor Red
}
Write-Host "Output: $outputPath"
Write-Host "========================================" -ForegroundColor White

# List output files
Write-Host ""
Write-Host "Output files:" -ForegroundColor Cyan
Get-ChildItem $outputPath | Select-Object Name | ForEach-Object { Write-Host "  - $($_.Name)" }
