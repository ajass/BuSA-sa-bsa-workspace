@echo off
REM
REM Raw Artifact Converter - Windows Version
REM Usage: convert.bat
REM
REM Converts PDF, DOCX, PPTX, Excel to Markdown for Copilot processing.
REM Requires: pandoc (install via: choco install pandoc or download from pandoc.org)
REM

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%.."
set "INPUT_DIR=%PROJECT_DIR%raw-artifacts"
set "OUTPUT_DIR=%INPUT_DIR%\converted"

echo ========================================
echo Raw Artifact Converter (Windows)
echo ========================================

where pandoc >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: pandoc not found.
    echo Install: choco install pandoc
    echo Or download: https://pandoc.org/installing.html
    exit /b 1
)

for /f "delims=" %%v in ('pandoc --version ^| findstr /b "pandoc"') do set PANDOC_VER=%%v
echo Using: %PANDOC_VER%
echo.

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"
if not exist "%INPUT_DIR%\images" mkdir "%INPUT_DIR%\images"

set CONVERTED=0
set FAILED=0

REM Convert PDF files
echo Converting PDFs...
for %%f in ("%INPUT_DIR%\*.pdf") do (
    set "filename=%%~nf"
    echo   Converting: %%~nf.pdf
    pandoc "%%f" -t markdown -o "%OUTPUT_DIR%\%%~nf.md" 2>nul
    if !errorlevel! equ 0 (
        echo     -^> %%~nf.md
        set /a CONVERTED+=1
    ) else (
        echo     -^> FAILED
        set /a FAILED+=1
    )
)

REM Convert DOCX files
echo Converting DOCX files...
for %%f in ("%INPUT_DIR%\*.docx") do (
    set "filename=%%~nf"
    echo   Converting: %%~nf.docx
    pandoc "%%f" -t markdown -o "%OUTPUT_DIR%\%%~nf.md" 2>nul
    if !errorlevel! equ 0 (
        echo     -^> %%~nf.md
        set /a CONVERTED+=1
    ) else (
        echo     -^> FAILED
        set /a FAILED+=1
    )
)

REM Convert PPTX files
echo Converting PPTX files...
for %%f in ("%INPUT_DIR%\*.pptx") do (
    set "filename=%%~nf"
    echo   Converting: %%~nf.pptx
    pandoc "%%f" -t markdown --wrap=none 2>nul > "%OUTPUT_DIR%\%%~nf_temp.md"
    if !errorlevel! equ 0 (
        (
            echo # Presentation: %%~nf
            echo.
            echo _Converted from PowerPoint_
            echo.
            echo ---
            echo.
            type "%OUTPUT_DIR%\%%~nf_temp.md"
        ) > "%OUTPUT_DIR%\%%~nf.md"
        del "%OUTPUT_DIR%\%%~nf_temp.md" 2>nul
        echo     -^> %%~nf.md
        set /a CONVERTED+=1
    ) else (
        echo     -^> FAILED
        set /a FAILED+=1
    )
)

REM Convert Excel files
echo Converting Excel files...
for %%f in ("%INPUT_DIR%\*.xlsx") do (
    set "filename=%%~nf"
    echo   Converting: %%~nf.xlsx
    pandoc "%%f" -t markdown 2>nul > "%OUTPUT_DIR%\%%~nf.md"
    if !errorlevel! equ 0 (
        (
            echo # Excel: %%~nf
            echo.
            echo _Converted from Excel spreadsheet_
            echo.
            type "%OUTPUT_DIR%\%%~nf.md"
        ) > "%OUTPUT_DIR%\%%~nf_temp.md"
        move /y "%OUTPUT_DIR%\%%~nf_temp.md" "%OUTPUT_DIR%\%%~nf.md" >nul
        echo     -^> %%~nf.md
        set /a CONVERTED+=1
    ) else (
        echo     -^> FAILED
        set /a FAILED+=1
    )
)

REM Copy Markdown files
echo Copying Markdown files...
for %%f in ("%INPUT_DIR%\*.md") do (
    copy /Y "%%f" "%OUTPUT_DIR%\%%~nf.md" >nul 2>&1
    if !errorlevel! equ 0 (
        echo   Copied: %%~nf.md
        set /a CONVERTED+=1
    )
)

REM Copy CSV files
echo Copying CSV files...
for %%f in ("%INPUT_DIR%\*.csv") do (
    copy /Y "%%f" "%OUTPUT_DIR%\%%~nf.csv" >nul 2>&1
    if !errorlevel! equ 0 (
        echo   Copied: %%~nf.csv
        set /a CONVERTED+=1
    )
)

REM Create image references
echo Creating image references...
for %%f in ("%INPUT_DIR%\*.png") do (
    set "filename=%%~nf"
    copy /Y "%%f" "%INPUT_DIR%\images\" >nul 2>&1
    (
        echo # Image: %%~nf.png
        echo.
        echo ![%%~nf](../raw-artifacts/images/%%~nf.png)
        echo.
        echo ## Description
        echo _TODO: Describe what this diagram/screenshot shows_
        echo.
        echo ## Key Elements
        echo - _TODO: List key elements visible in image_
    ) > "%OUTPUT_DIR%\%%~nf-image.md"
    echo   Image reference: %%~nf.png
    set /a CONVERTED+=1
)

for %%f in ("%INPUT_DIR%\*.jpg") do (
    set "filename=%%~nf"
    copy /Y "%%f" "%INPUT_DIR%\images\" >nul 2>&1
    (
        echo # Image: %%~nf.jpg
        echo.
        echo ![%%~nf](../raw-artifacts/images/%%~nf.jpg)
        echo.
        echo ## Description
        echo _TODO: Describe what this diagram/screenshot shows_
    ) > "%OUTPUT_DIR%\%%~nf-image.md"
    echo   Image reference: %%~nf.jpg
    set /a CONVERTED+=1
)

for %%f in ("%INPUT_DIR%\*.jpeg") do (
    set "filename=%%~nf"
    copy /Y "%%f" "%INPUT_DIR%\images\" >nul 2>&1
    (
        echo # Image: %%~nf.jpeg
        echo.
        echo ![%%~nf](../raw-artifacts/images/%%~nf.jpeg)
        echo.
        echo ## Description
        echo _TODO: Describe what this diagram/screenshot shows_
    ) > "%OUTPUT_DIR%\%%~nf-image.md"
    echo   Image reference: %%~nf.jpeg
    set /a CONVERTED+=1
)

echo.
echo ========================================
echo Conversion Summary
echo ========================================
echo Converted: %CONVERTED% files
if %FAILED% gtr 0 (
    echo Failed: %FAILED% files
)
echo Output: %OUTPUT_DIR%
echo ========================================
echo.
dir /b "%OUTPUT_DIR%" 2>nul

endlocal
