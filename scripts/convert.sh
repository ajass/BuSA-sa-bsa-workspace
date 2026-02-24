#!/bin/bash
#
# Raw Artifact Converter - Shell Script Version
# Usage: ./convert.sh
#
# This script converts common file types to Markdown for Copilot processing.
# Requires: pandoc (install via: brew install pandoc)
#

INPUT_DIR="raw-artifacts"
OUTPUT_DIR="raw-artifacts/converted"

echo "========================================"
echo "Raw Artifact Converter"
echo "========================================"

# Check for pandoc
if ! command -v pandoc &> /dev/null; then
    echo "WARNING: pandoc not found. PDF/DOCX conversion will be limited."
    echo "Install pandoc: brew install pandoc"
    echo ""
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Convert PDF files
if command -v pandoc &> /dev/null; then
    find "$INPUT_DIR" -name "*.pdf" -type f 2>/dev/null | while read -r pdf; do
        filename=$(basename "$pdf" .pdf)
        echo "Converting PDF: $filename.pdf"
        pandoc "$pdf" -t markdown -o "$OUTPUT_DIR/${filename}.md" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "  → Created: ${filename}.md"
        else
            echo "  → Failed: ${filename}.pdf"
        fi
    done
fi

# Convert DOCX files
if command -v pandoc &> /dev/null; then
    find "$INPUT_DIR" -name "*.docx" -type f 2>/dev/null | while read -r docx; do
        filename=$(basename "$docx" .docx)
        echo "Converting DOCX: $filename.docx"
        pandoc "$docx" -t markdown -o "$OUTPUT_DIR/${filename}.md" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "  → Created: ${filename}.md"
        else
            echo "  → Failed: ${filename}.docx"
        fi
    done
fi

# Copy Markdown files
find "$INPUT_DIR" -name "*.md" -type f 2>/dev/null | while read -r md; do
    filename=$(basename "$md")
    if [ "$md" != "$OUTPUT_DIR/$filename" ]; then
        echo "Copying: $filename"
        cp "$md" "$OUTPUT_DIR/$filename"
    fi
done

# Copy CSV files
find "$INPUT_DIR" -name "*.csv" -type f 2>/dev/null | while read -r csv; do
    filename=$(basename "$csv")
    echo "Copying: $filename"
    cp "$csv" "$OUTPUT_DIR/$filename"
done

# Create image references
mkdir -p "$INPUT_DIR/images"
find "$INPUT_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) 2>/dev/null | while read -r img; do
    filename=$(basename "$img" | sed 's/\.[^.]*//')
    ext=$(echo "$img" | sed 's/.*\.//')
    echo "Creating image reference: $filename.$ext"
    cat > "$OUTPUT_DIR/${filename}-image.md" << EOF
# Image: $filename.$ext

![${filename}](../raw-artifacts/images/$filename.$ext)

## Description
_TODO: Describe what this diagram/screenshot shows_

## Key Elements
- _TODO: List key elements visible in image_
EOF
done

echo ""
echo "========================================"
echo "Conversion complete!"
echo "Output directory: $OUTPUT_DIR"
echo "========================================"
