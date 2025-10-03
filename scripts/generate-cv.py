#!/usr/bin/env python3
"""
CV Generator Script
Reads JSON data and generates LaTeX CV with configurable templates
"""

import json
import sys
import os
import shutil
import yaml
from pathlib import Path


def load_config():
    """Load configuration from config.yaml"""
    config_file = Path(__file__).parent.parent / 'config.yaml'
    if config_file.exists():
        with open(config_file, 'r') as f:
            return yaml.safe_load(f)
    return {}


def escape_latex(text):
    """Escape special LaTeX characters"""
    if not text:
        return ""
    
    replacements = {
        '&': r'\&',
        '%': r'\%',
        '$': r'\$',
        '#': r'\#',
        '_': r'\_',
        '{': r'\{',
        '}': r'\}',
        '~': r'\textasciitilde{}',
        '^': r'\^{}',
    }
    
    for old, new in replacements.items():
        text = text.replace(old, new)
    
    return text


def generate_experience_section(experiences, config):
    """Generate LaTeX for experience section"""
    latex = ""
    show_tech = config.get('show_technologies', True)
    max_highlights = config.get('max_highlights_per_job', 0)
    
    for exp in experiences:
        latex += "\\cventrylong\n"
        latex += f"  {{{escape_latex(exp['title'])}}}\n"
        latex += f"  {{{escape_latex(exp['company'])}}}\n"
        latex += f"  {{{escape_latex(exp['location'])}}}\n"
        latex += f"  {{{escape_latex(exp['period'])}}}\n"
        latex += "  {\n"
        
        if exp.get('description'):
            latex += f"    {escape_latex(exp['description'])}\n"
        
        if exp.get('highlights'):
            highlights = exp['highlights']
            if max_highlights > 0:
                highlights = highlights[:max_highlights]
            
            latex += "    \\begin{cvitems}\n"
            for highlight in highlights:
                latex += f"      \\item {{{escape_latex(highlight)}}}\n"
            latex += "    \\end{cvitems}\n"
        
        latex += "  }\n"
        
        # Add technologies line
        tech = escape_latex(exp.get('technologies', ''))
        if show_tech and tech:
            latex += f"  {{{tech}}}\n"
        else:
            latex += "  {}\n"
        
        latex += "\n"
    
    return latex


def generate_education_section(education):
    """Generate LaTeX for education section"""
    latex = ""
    
    for edu in education:
        latex += "\\cventry\n"
        latex += f"  {{{escape_latex(edu['degree'])}}}\n"
        latex += f"  {{{escape_latex(edu['institution'])}}}\n"
        latex += f"  {{{escape_latex(edu['location'])}}}\n"
        latex += f"  {{{escape_latex(edu['period'])}}}\n"
        latex += "  {}\n\n"
    
    return latex


def generate_skills_section(skills, lang='en'):
    """Generate LaTeX for skills section"""
    latex = ""
    
    if lang == 'en':
        tech_title = "Technical Skills"
        soft_title = "Soft Skills"
    else:
        tech_title = "Competenze Tecniche"
        soft_title = "Competenze Trasversali"
    
    if skills.get('technical'):
        latex += "\\cvskills\n"
        latex += f"  {{{tech_title}}}\n"
        latex += "  {\n"
        latex += "    " + " \\textbar\\ ".join(escape_latex(s) for s in skills['technical'])
        latex += "\n  }\n\n"
    
    if skills.get('soft'):
        latex += "\\cvskills\n"
        latex += f"  {{{soft_title}}}\n"
        latex += "  {\n"
        latex += "    " + " \\textbar\\ ".join(escape_latex(s) for s in skills['soft'])
        latex += "\n  }\n\n"
    
    return latex


def generate_cv(json_file, output_dir, lang='en'):
    """Main function to generate CV"""
    
    # Load config
    config = load_config()
    
    # Read JSON data
    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Read template
    template_name = config.get('template', 'awesome-cv')
    template_file = Path(__file__).parent.parent / 'template' / f'{template_name}.tex'
    
    if not template_file.exists():
        template_file = Path(__file__).parent.parent / 'template' / 'cv.tex'
    
    with open(template_file, 'r', encoding='utf-8') as f:
        template = f.read()
    
    # Section labels
    if lang == 'en':
        labels = {
            'summary': 'Summary',
            'experience': 'Experience',
            'education': 'Education',
            'skills': 'Skills',
            'languages': 'Languages',
            'additional': 'Additional Information'
        }
    else:
        labels = {
            'summary': 'Profilo',
            'experience': 'Esperienza',
            'education': 'Istruzione',
            'skills': 'Competenze',
            'languages': 'Lingue',
            'additional': 'Informazioni Aggiuntive'
        }
    
    # Generate sections
    personal = data['personal']
    
    # Replace placeholders in template
    cv_content = template
    cv_content = cv_content.replace('{{NAME}}', escape_latex(personal['name']))
    cv_content = cv_content.replace('{{TITLE}}', escape_latex(personal['title']))
    cv_content = cv_content.replace('{{ADDRESS}}', escape_latex(personal['address']))
    cv_content = cv_content.replace('{{PHONE}}', escape_latex(personal['phone']))
    cv_content = cv_content.replace('{{EMAIL}}', escape_latex(personal['email']))
    cv_content = cv_content.replace('{{LINKEDIN}}', personal['linkedin'])

    # Extract GitHub username from URL
    github_url = personal.get('github', '')
    github_username = github_url.split('/')[-1] if github_url else ''
    cv_content = cv_content.replace('{{GITHUB}}', github_username)

    # Homepage URL
    homepage = personal.get('homepage', '')
    cv_content = cv_content.replace('{{HOMEPAGE}}', homepage)
    
    # Apply color scheme if specified
    color = config.get('color', 'skyblue')
    cv_content = cv_content.replace('\\colorlet{awesome}{awesome-skyblue}', 
                                    f'\\colorlet{{awesome}}{{awesome-{color}}}')
    
    cv_content = cv_content.replace('{{LABEL_SUMMARY}}', labels['summary'])
    cv_content = cv_content.replace('{{SUMMARY}}', escape_latex(data['summary']))
    
    cv_content = cv_content.replace('{{LABEL_EXPERIENCE}}', labels['experience'])
    cv_content = cv_content.replace('{{EXPERIENCE}}', generate_experience_section(data['experience'], config))
    
    cv_content = cv_content.replace('{{LABEL_EDUCATION}}', labels['education'])
    cv_content = cv_content.replace('{{EDUCATION}}', generate_education_section(data['education']))
    
    cv_content = cv_content.replace('{{LABEL_SKILLS}}', labels['skills'])
    cv_content = cv_content.replace('{{SKILLS}}', generate_skills_section(data['skills'], lang))
    
    # Write output LaTeX file
    output_tex = Path(output_dir) / f'cv-{lang}.tex'
    with open(output_tex, 'w', encoding='utf-8') as f:
        f.write(cv_content)
    
    print(f"Generated LaTeX file: {output_tex}")
    return output_tex


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: generate-cv.py <language>")
        print("Example: generate-cv.py en")
        sys.exit(1)
    
    lang = sys.argv[1]
    
    if lang not in ['en', 'it']:
        print("Supported languages: en, it")
        sys.exit(1)
    
    # Check if PyYAML is available
    try:
        import yaml
    except ImportError:
        print("Warning: PyYAML not found, using default configuration")
        yaml = None
    
    # Paths
    base_dir = Path(__file__).parent.parent
    json_file = base_dir / 'data' / f'cv-{lang}.json'
    
    # Use /output for Docker or ./output for local
    if os.path.exists('/output'):
        output_dir = Path('/output')
    else:
        output_dir = base_dir / 'output'
    
    # Create output directory if it doesn't exist
    output_dir.mkdir(exist_ok=True)
    
    # Copy template files to output directory
    template_dir = base_dir / 'template'
    shutil.copy(template_dir / 'awesome-cv.cls', output_dir / 'awesome-cv.cls')
    
    # Generate CV
    output_tex = generate_cv(json_file, output_dir, lang)
    
    # Compile LaTeX to PDF
    print(f"Compiling PDF for {lang}...")
    os.chdir(output_dir)
    
    # Run xelatex twice for proper references
    for i in range(2):
        ret = os.system(f'xelatex -interaction=nonstopmode cv-{lang}.tex')
        if ret != 0:
            print(f"\n✗ xelatex failed with code {ret}")
            print(f"Check the log file: {output_dir}/cv-{lang}.log")
            # Print last 50 lines of log for debugging
            log_file = output_dir / f'cv-{lang}.log'
            if log_file.exists():
                print("\n=== Last 50 lines of LaTeX log ===")
                with open(log_file, 'r', encoding='utf-8', errors='ignore') as f:
                    lines = f.readlines()
                    for line in lines[-50:]:
                        print(line.rstrip())
            sys.exit(1)
    
    # Clean up all auxiliary files, keeping only the PDF
    # Remove LaTeX auxiliary files
    for ext in ['.aux', '.out', '.tex', '.log']:
        aux_file = output_dir / f'cv-{lang}{ext}'
        if aux_file.exists():
            aux_file.unlink()

    # Remove template files copied to output directory
    cls_file = output_dir / 'awesome-cv.cls'
    if cls_file.exists():
        cls_file.unlink()
    
    pdf_file = output_dir / f'cv-{lang}.pdf'
    if pdf_file.exists():
        print(f"\n✓ Successfully generated: {pdf_file}")
    else:
        print(f"\n✗ Failed to generate PDF")
        sys.exit(1)