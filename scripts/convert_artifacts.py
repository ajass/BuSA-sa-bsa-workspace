#!/usr/bin/env python3
"""
Raw Artifact Converter
Converts various file types to Markdown for Copilot processing.

Usage: 
    ./convert.sh          # Use shell script (recommended)
    python3 convert_artifacts.py --venv  # Use Python with venv

Requirements:
    brew install pandoc
"""

import os
import sys
import subprocess
import argparse
from pathlib import Path
from datetime import datetime

GREEN = '\033[92m'
YELLOW = '\033[93m'
RED = '\033[91m'
RESET = '\033[0m'

def log_info(msg):
    print(f"{GREEN}[INFO]{RESET} {msg}")

def log_warn(msg):
    print(f"{YELLOW}[WARN]{RESET} {msg}")

def log_error(msg):
    print(f"{RED}[ERROR]{RESET} {msg}")

def check_venv():
    """Check if running in virtual environment."""
    return (hasattr(sys, 'real_prefix') or 
            (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix))

def ensure_venv():
    """Ensure we're running in a venv."""
    script_dir = Path(__file__).parent
    venv_dir = script_dir / "venv"
    venv_python = venv_dir / "bin" / "python"
    
    if check_venv():
        log_info("Already in virtual environment")
        return True
    
    if venv_python.exists():
        log_info(f"Using existing venv: {venv_dir}")
        return True
    
    log_info(f"Creating virtual environment at {venv_dir}")
    try:
        subprocess.run([sys.executable, "-m", "venv", str(venv_dir)], check=True)
        
        # Install dependencies
        log_info("Installing dependencies...")
        subprocess.run([str(venv_dir / "bin" / "pip"), "install", "-q", 
                       "pdftotext", "python-docx", "markdown"], check=False)
        
        log_info("Virtual environment created")
        return True
    except Exception as e:
        log_error(f"Failed to create venv: {e}")
        return False

def run_venv_python(args):
    """Run Python in the venv with given args."""
    script_dir = Path(__file__).parent
    venv_python = script_dir / "venv" / "bin" / "python"
    
    if venv_python.exists():
        os.exec(str(venv_python), *args)
    else:
        log_error("Virtual environment not found. Run with --setup first.")
        sys.exit(1)

class ArtifactConverter:
    def __init__(self, input_dir, output_dir):
        self.input_dir = Path(input_dir)
        self.output_dir = Path(output_dir)
        self.converted = []
        self.skipped = []
        self.errors = []
        
    def convert_with_pandoc(self, input_path, output_path, file_type):
        """Convert file using pandoc."""
        try:
            result = subprocess.run(
                ['pandoc', str(input_path), '-t', 'markdown', '-o', str(output_path)],
                capture_output=True, text=True, timeout=30
            )
            if result.returncode == 0:
                log_info(f"Converted: {input_path.name}")
                self.converted.append(str(output_path))
                return True
            else:
                log_error(f"Failed: {input_path.name} - {result.stderr}")
                self.errors.append((str(input_path), result.stderr))
                return False
        except Exception as e:
            log_error(f"Error converting {input_path.name}: {e}")
            self.errors.append((str(input_path), str(e)))
            return False
    
    def convert_pptx(self, input_path, output_path):
        """Convert PPTX with slide separation."""
        try:
            result = subprocess.run(
                ['pandoc', str(input_path), '-t', 'markdown', '--wrap=none'],
                capture_output=True, text=True, timeout=60
            )
            if result.returncode == 0:
                with open(output_path, 'w', encoding='utf-8') as f:
                    f.write(f"# Presentation: {input_path.stem}\n\n")
                    f.write("_Converted from PowerPoint_\n\n")
                    f.write("---\n\n")
                    # Add slide headers
                    content = result.stdout.replace('# ', '## Slide: ')
                    f.write(content)
                log_info(f"Converted PPTX: {input_path.name}")
                self.converted.append(str(output_path))
                return True
            else:
                log_error(f"Failed PPTX: {result.stderr}")
                return False
        except Exception as e:
            log_error(f"Error converting PPTX: {e}")
            return False
    
    def copy_file(self, input_path, output_path):
        """Copy file as-is."""
        try:
            import shutil
            shutil.copy2(input_path, output_path)
            log_info(f"Copied: {input_path.name}")
            self.converted.append(str(output_path))
            return True
        except Exception as e:
            log_error(f"Error copying: {e}")
            return False
    
    def create_image_ref(self, input_path, output_path):
        """Create markdown reference for image."""
        relative_path = f"../raw-artifacts/images/{input_path.name}"
        
        # Move image to images folder
        images_dir = self.input_dir / "images"
        images_dir.mkdir(exist_ok=True)
        
        import shutil
        dest = images_dir / input_path.name
        shutil.copy2(input_path, dest)
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(f"# Image: {input_path.name}\n\n")
            f.write(f"![{input_path.name}]({relative_path})\n\n")
            f.write("## Description\n")
            f.write("_TODO: Describe what this diagram/screenshot shows_\n\n")
            f.write("## Key Elements\n")
            f.write("- _TODO: List key elements visible in image_\n")
        
        log_info(f"Created image reference: {input_path.name}")
        self.converted.append(str(output_path))
    
    def process(self):
        """Process all files."""
        log_info(f"Scanning: {self.input_dir}")
        
        # Ensure output directory exists
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        handlers = {
            '.pdf': lambda i, o: self.convert_with_pandoc(i, o, 'PDF'),
            '.docx': lambda i, o: self.convert_with_pandoc(i, o, 'DOCX'),
            '.pptx': self.convert_pptx,
            '.txt': lambda i, o: self.convert_with_pandoc(i, o, 'TXT'),
        }
        
        copy_handlers = {'.md', '.csv', '.json', '.yml', '.yaml'}
        image_exts = {'.png', '.jpg', '.jpeg', '.gif', '.bmp'}
        
        for file_path in self.input_dir.iterdir():
            if not file_path.is_file():
                continue
            if file_path.name.startswith('.'):
                continue
            
            output_path = self.output_dir / f"{file_path.stem}.md"
            suffix = file_path.suffix.lower()
            
            # Skip if already converted (input older than output)
            if output_path.exists() and file_path.stat().st_mtime < output_path.stat().st_mtime:
                log_info(f"Skipped (up-to-date): {file_path.name}")
                self.skipped.append(str(file_path))
                continue
            
            if suffix in handlers:
                handlers[suffix](file_path, output_path)
            elif suffix in copy_handlers:
                self.copy_file(file_path, output_path.with_suffix(suffix))
            elif suffix in image_exts:
                self.create_image_ref(file_path, output_path)
            else:
                log_warn(f"Unknown type: {file_path.name}")
        
        # Summary
        print(f"\n{'='*50}")
        log_info(f"Conversion complete!")
        log_info(f"  Converted: {len(self.converted)}")
        log_info(f"  Skipped: {len(self.skipped)}")
        log_info(f"  Errors: {len(self.errors)}")
        print(f"{'='*50}\n")
        
        return len(self.errors) == 0

def main():
    parser = argparse.ArgumentParser(description='Convert raw artifacts to Markdown')
    parser.add_argument('--input', default='raw-artifacts', help='Input directory')
    parser.add_argument('--output', default='raw-artifacts/converted', help='Output directory')
    parser.add_argument('--setup', action='store_true', help='Setup virtual environment')
    args = parser.parse_args()
    
    # Change to script directory
    os.chdir(Path(__file__).parent.parent)
    
    if args.setup:
        ensure_venv()
        return
    
    converter = ArtifactConverter(args.input, args.output)
    success = converter.process()
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()
