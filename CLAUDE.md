# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an automated resume generator that creates professional PDFs from **JSONResume-compatible** data using LaTeX templates. The system supports multiple languages (English and Italian) and uses Docker for consistent LaTeX compilation across environments.

### JSONResume Compatibility

This project follows the [JSONResume](https://jsonresume.org) standard (v1.0.0), making CV data portable and compatible with other JSONResume tools and themes.

## Core Architecture

The system follows a simple pipeline:
1. **JSON Data** (`data/cv-en.json`, `data/cv-it.json`) - Contains structured CV information
2. **Configuration** (`config.yaml`) - Controls template styling, colors, fonts, and layout
3. **Python Generator** (`scripts/generate-cv.py`) - Processes JSON data and generates LaTeX files
4. **LaTeX Template** (`template/cv.tex`, `template/awesome-cv.cls`) - Defines the CV layout and styling
5. **Docker Environment** - Provides consistent LaTeX compilation with all required packages and fonts

## Development Commands

### Build and Generate CVs

```bash
# Build Docker image
docker build -t my-resume-generator .

# Generate English CV
docker run -v $(pwd)/output:/output my-resume-generator en

# Generate Italian CV
docker run -v $(pwd)/output:/output my-resume-generator it

# Check generated files
ls -lh output/
```

### Local Development

```bash
# Run the Python script directly (requires local LaTeX installation)
python3 scripts/generate-cv.py en
python3 scripts/generate-cv.py it
```

### Testing and Validation

```bash
# Validate JSON data
python3 -m json.tool data/cv-en.json > /dev/null
python3 -m json.tool data/cv-it.json > /dev/null

# Check LaTeX compilation logs
cat output/cv-en.log
cat output/cv-it.log
```

## Key Components

### JSON Data Structure (JSONResume Format)
The CV data follows the JSONResume schema (https://jsonresume.org/schema):

- `$schema`: JSONResume schema version reference
- `basics`: Personal information, contact details, location, and social profiles
  - `name`, `label`, `email`, `phone`, `url`, `summary`
  - `location`: nested object with address, postalCode, city, countryCode, region
  - `profiles[]`: array of social profiles (LinkedIn, GitHub, etc.)
- `work[]`: Array of work experience with ISO 8601 dates
  - `name`, `position`, `startDate`, `endDate`, `summary`, `highlights[]`, `keywords[]`, `location`
- `education[]`: Educational background with ISO 8601 dates
  - `institution`, `area`, `studyType`, `startDate`, `endDate`, `location`
- `skills[]`: Skills grouped by category with proficiency levels
  - `name`, `level`, `keywords[]`
- `languages[]`: Language proficiencies
- `interests[]`: Personal interests
- `volunteer[]`, `awards[]`, `certificates[]`, `publications[]`, `references[]`, `projects[]`: Optional sections
- `meta`: Metadata including nationality and last modified date

### Configuration System
The `config.yaml` file controls:
- Template selection (`awesome-cv`, `modern`, `classic`)
- Color schemes (`skyblue`, `emerald`, `red`, `pink`, `orange`, `nephritis`, `concrete`, `darknight`)
- Font size and page margins
- Section ordering and visibility
- Technology display preferences
- Bullet point limits per job

### Template System
- Uses Awesome-CV LaTeX class for professional styling
- Placeholder-based templating with double braces (e.g., `{{NAME}}`)
- Automatic LaTeX escaping for special characters
- Multi-language label support

### CI/CD Integration
GitHub Actions workflow (`.github/workflows/build-cv.yml`):
- Triggers on pushes to any branch and tag creation
- Builds Docker image and generates PDFs for all languages
- Uploads artifacts with 90-day retention
- Creates permanent releases for tagged versions

## File Modification Guidelines

### Adding New Languages
1. Create `data/cv-<lang>.json` with translated content
2. Update `scripts/generate-cv.py` to add language labels in the labels dictionary
3. Update GitHub workflow to generate the new language variant

### Customizing Templates
- Modify `template/cv.tex` for layout changes
- Edit `template/awesome-cv.cls` for deeper styling modifications
- Use `config.yaml` for standard customizations (colors, fonts, margins)

### JSON Data Updates
- Follow the JSONResume schema (v1.0.0) when adding new fields
- Use ISO 8601 date format (YYYY-MM-DD) for all dates
- Use `keywords[]` arrays instead of comma-separated technology strings
- Omit optional fields if empty rather than using empty strings
- LinkedIn and GitHub are specified in `basics.profiles[]` array
- Ensure proper LaTeX character escaping is handled by the generator
- Test with both languages to ensure consistency
- Validate JSON against schema: https://raw.githubusercontent.com/jsonresume/resume-schema/v1.0.0/schema.json

## Dependencies

### Docker Environment
- Ubuntu 22.04 base
- Full TeXLive distribution with XeTeX
- Python 3 with PyYAML
- Source Sans Pro fonts (automatically installed)
- Font Awesome icons

### Python Dependencies
- Standard library only (json, sys, os, pathlib)
- PyYAML (optional, falls back to default config if not available)

## Branch Strategy

The repository supports multiple resume variants through branching:
- `main`: Standard/general version
- `architect-focus`: Architecture-focused variant
- `platform-focus`: Platform/infrastructure-focused variant
- Feature branches for specific customizations

Tagged releases create permanent versions for job applications.