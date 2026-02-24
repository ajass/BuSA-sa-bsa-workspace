#!/bin/bash
#
# Raw Artifact Converter
# Usage: ./convert.sh
#
# Converts PDF, DOCX, PPTX, images to Markdown for Copilot processing.
# Requires: pandoc (install via: brew install pandoc)
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
INPUT_DIR="$PROJECT_DIR/raw-artifacts"
OUTPUT_DIR="$INPUT_DIR/converted"

echo "========================================"
echo "Raw Artifact Converter"
echo "========================================"

# Check for pandoc
if ! command -v pandoc &> /dev/null; then
    echo "ERROR: pandoc not found."
    echo "Install: brew install pandoc"
    exit 1
fi

echo "Using pandoc: $(pandoc --version | head -1)"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Create images directory
mkdir -p "$INPUT_DIR/images"

CONVERTED=0
FAILED=0

# Function to convert file
convert_file() {
    local input="$1"
    local output="$2"
    local ext="${input##*.}"
    
    # Skip if output already exists and is newer
    if [ -f "$output" ] && [ "$input" -ot "$output" ]; then
        return 0
    fi
    
    # Convert based on type
    case "${ext,,}" in
        pdf)
            pandoc "$input" -t markdown -o "$output" 2>/dev/null
            ;;
        docx)
            pandoc "$input" -t markdown -o "$output" 2>/dev/null
            ;;
        pptx)
            # PPTX needs special handling - extract slides
            pandoc "$input" -t markdown -o "$output" --wrap=none 2>/dev/null
            ;;
        txt)
            pandoc "$input" -t markdown -o "$output" 2>/dev/null
            ;;
        xlsx)
            # Excel - convert all sheets
            {
                echo "# Excel: $(basename "$input" .xlsx)"
                echo ""
                echo "_Converted from Excel spreadsheet_"
                echo ""
                pandoc "$input" -t markdown 2>/dev/null
            } > "$output" 2>/dev/null
            ;;
        *)
            return 1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        echo "  ✓ $input → $(basename "$output")"
        ((CONVERTED++))
    else
        echo "  ✗ $input → FAILED"
        ((FAILED++))
    fi
}

# Convert PDF files
echo "Converting PDFs..."
find "$INPUT_DIR" -name "*.pdf" -type f 2>/dev/null | while read -r pdf; do
    filename=$(basename "$pdf" .pdf)
    convert_file "$pdf" "$OUTPUT_DIR/${filename}.md"
done

# Convert DOCX files
echo "Converting DOCX files..."
find "$INPUT_DIR" -name "*.docx" -type f 2>/dev/null | while read -r docx; do
    filename=$(basename "$docx" .docx)
    convert_file "$docx" "$OUTPUT_DIR/${filename}.md"
done

# Convert PPTX files
echo "Converting PPTX files..."
find "$INPUT_DIR" -name "*.pptx" -type f 2>/dev/null | while read -r pptx; do
    filename=$(basename "$pptx" .pptx)
    
    # Create markdown with slide separators
    output="$OUTPUT_DIR/${filename}.md"
    
    {
        echo "# Presentation: $filename"
        echo ""
        echo "_Converted from PowerPoint_"
        echo ""
        echo "---"
        echo ""
        pandoc "$pptx" -t markdown --wrap=none 2>/dev/null | sed 's/^# /## Slide: /'
    } > "$output"
    
    if [ $? -eq 0 ]; then
        echo "  ✓ $pptx → ${filename}.md"
        ((CONVERTED++))
    else
        echo "  ✗ $pptx → FAILED"
        ((FAILED++))
    fi
done

# Convert Excel files
echo "Converting Excel files..."
find "$INPUT_DIR" -name "*.xlsx" -type f 2>/dev/null | while read -r xlsx; do
    filename=$(basename "$xlsx" .xlsx)
    output="$OUTPUT_DIR/${filename}.md"
    
    {
        echo "# Excel: $filename"
        echo ""
        echo "_Converted from Excel spreadsheet_"
        echo ""
        echo "---"
        echo ""
        # Convert each sheet
        pandoc "$xlsx" -t markdown 2>/dev/null
    } > "$output"
    
    if [ $? -eq 0 ]; then
        echo "  ✓ $xlsx → ${filename}.md"
        ((CONVERTED++))
    else
        echo "  ✗ $xlsx → FAILED"
        ((FAILED++))
    fi
done

# Copy Markdown files
echo "Copying Markdown files..."
find "$INPUT_DIR" -maxdepth 1 -name "*.md" -type f 2>/dev/null | while read -r md; do
    filename=$(basename "$md")
    cp "$md" "$OUTPUT_DIR/$filename"
    echo "  ✓ Copied: $filename"
    ((CONVERTED++))
done

# Copy CSV files
echo "Copying CSV files..."
find "$INPUT_DIR" -maxdepth 1 -name "*.csv" -type f 2>/dev/null | while read -r csv; do
    filename=$(basename "$csv")
    cp "$csv" "$OUTPUT_DIR/$filename"
    echo "  ✓ Copied: $filename"
    ((CONVERTED++))
done

# Create image references
echo "Creating image references..."
find "$INPUT_DIR" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" \) 2>/dev/null | while read -r img; do
    filename=$(basename "$img")
    name_only=$(echo "$filename" | sed 's/\.[^.]*//')
    ext=$(echo "$filename" | sed 's/.*\.//')
    
    # Move image to images folder
    mkdir -p "$INPUT_DIR/images"
    mv "$img" "$INPUT_DIR/images/" 2>/dev/null || cp "$img" "$INPUT_DIR/images/" 2>/dev/null
    
    # Create markdown reference
    cat > "$OUTPUT_DIR/${name_only}-image.md" << EOF
# Image: $filename

![${filename}](../raw-artifacts/images/$filename)

## Description
_TODO: Describe what this diagram/screenshot shows_

## Key Elements
- _TODO: List key elements visible in image_

## Slide/Page Reference
_If this image is from a presentation, note which slide:_
EOF
    echo "  ✓ Image reference: $filename"
    ((CONVERTED++))
done

echo ""
echo "========================================"
echo "Conversion Summary"
echo "========================================"
echo "Converted: $CONVERTED files"
if [ $FAILED -gt 0 ]; then
    echo "Failed: $FAILED files"
fi
echo "Output: $OUTPUT_DIR"
echo "========================================"

# List output files
echo ""
echo "Output files:"
ls -la "$OUTPUT_DIR" 2>/dev/null | tail -n +4
