# My Resume Generator

Generate professional resumes in multiple languages automatically using JSON data, LaTeX templates, and GitHub Actions.

## 🚀 Features

- **Multi-language support**: Currently English and Italian
- **JSON-based data**: Easy to maintain and update
- **Professional LaTeX template**: Based on Awesome-CV
- **Automated builds**: GitHub Actions generates PDFs on every push
- **Version control**: Create tagged releases for permanent CV versions
- **Branch variations**: Different branches for different CV variants (e.g., architect-focus, platform-focus)

## 📁 Repository Structure

```
my-resume-generator/
├── .github/workflows/
│   └── build-cv.yml          # GitHub Actions workflow
├── data/
│   ├── cv-en.json            # English resume data
│   └── cv-it.json            # Italian resume data
├── template/
│   ├── cv.tex                # LaTeX template
│   └── awesome-cv.cls        # LaTeX class file
├── scripts/
│   └── generate-cv.py        # Python generator script
├── output/                    # Generated PDFs (gitignored)
├── Dockerfile                 # Docker image for LaTeX compilation
└── README.md
```

## 🛠️ Setup

### 1. Clone and Customize

```bash
git clone https://github.com/stormino/my-resume-generator.git
cd my-resume-generator
```

### 2. Edit Your CV Data

Update `data/cv-en.json` and `data/cv-it.json` with your information:

```json
{
  "personal": {
    "name": "Your Name",
    "title": "Your Title",
    "email": "your.email@example.com",
    ...
  },
  "experience": [...],
  "education": [...],
  ...
}
```

### 3. Test Locally (Optional)

Build and run with Docker:

```bash
# Build the Docker image
docker build -t my-resume-generator .

# Generate English version
docker run -v $(pwd)/output:/output my-resume-generator en

# Generate Italian version
docker run -v $(pwd)/output:/output my-resume-generator it

# Check the output
ls -lh output/
```

### 4. Push to GitHub

```bash
git add .
git commit -m "Update CV data"
git push
```

The GitHub Action will automatically:
- Build the Docker container
- Generate PDFs for all languages
- Upload them as artifacts (available for 90 days)

### 5. Create a Release (Optional)

For permanent versions:

```bash
git tag -a v2024.09 -m "Senior Software Architect version"
git push origin v2024.09
```

This creates a GitHub release with the PDFs attached permanently.

## 📝 Usage Scenarios

### Different CV Variations

Create branches for different job applications:

```bash
# Create architect-focused version
git checkout -b architect-focus
# Edit data/cv-*.json to emphasize architecture experience
git commit -am "Architect-focused CV"
git push -u origin architect-focus

# Create platform-focused version
git checkout -b platform-focus
# Edit data/cv-*.json to emphasize platform/infrastructure
git commit -am "Platform-focused CV"
git push -u origin platform-focus
```

### Dated Versions

Tag specific versions for applications:

```bash
git tag -a 2024.09.30 -m "Application for Company X"
git push origin 2024.09.30
```

### Quick Updates

```bash
# Update your current position
vim data/cv-en.json
vim data/cv-it.json

git commit -am "Update current position"
git push

# PDFs will be automatically generated in Actions tab
```

## 🔄 Workflow Behavior

### On Push to Any Branch
- Generates PDFs for all languages
- Uploads as artifacts (90-day retention)
- Artifacts named: `cv-pdfs-<branch-name>`

### On Tag Push
- Generates PDFs for all languages
- Creates a GitHub Release
- Attaches PDFs to the release (permanent)

### Manual Trigger
- Go to Actions tab
- Select "Build CV" workflow
- Click "Run workflow"

## 📥 Downloading Your CV

### From Artifacts (Recent Builds)
1. Go to Actions tab
2. Click on the latest workflow run
3. Download artifacts from the bottom of the page

### From Releases (Tagged Versions)
1. Go to Releases section
2. Download PDFs from any release

## 🎨 Customization

### Using config.yaml

The easiest way to customize your CV is through `config.yaml`:

```yaml
# Template to use
template: awesome-cv

# Color scheme (skyblue, emerald, red, pink, orange, nephritis, concrete, darknight)
color: skyblue

# Font size
font_size: 11

# Page margins
margins:
  left: 1.4
  right: 1.4
  top: 0.8
  bottom: 1.8

# Show technologies in experience
show_technologies: true

# Limit bullet points per job (0 = unlimited)
max_highlights_per_job: 0
```

After editing `config.yaml`, just rebuild and generate:

```bash
docker build -t my-resume-generator .
docker run -v $(pwd)/output:/output my-resume-generator en
```

### Modify Template Style

Edit `template/cv.tex` to change layout, or `template/awesome-cv.cls` for deeper styling changes (colors, fonts, spacing).

### Add New Languages

1. Create `data/cv-<lang>.json`
2. Update `scripts/generate-cv.py` to add language labels
3. Update `.github/workflows/build-cv.yml` to generate the new language

### Change Fonts or Colors

Edit `template/awesome-cv.cls`:

```latex
% Change primary color
\colorlet{awesome}{awesome-red}  % or awesome-emerald, awesome-orange, etc.

% Change fonts
\setmainfont{YourFont}[...]
```

## 🐛 Troubleshooting

### PDFs Not Generating
- Check the Actions tab for error logs
- Ensure JSON files are valid (use a JSON validator)
- Verify LaTeX syntax in template files

### Missing Fonts
The Dockerfile includes Source Sans Pro. For other fonts, modify the Dockerfile to install them.

### Local Testing Issues
Make sure Docker is installed and running:
```bash
docker --version
```

## 📄 License

This project structure is free to use. Customize as needed for your CV!

## 🤝 Contributing

Feel free to fork and customize for your needs. If you have improvements to the template or workflow, PRs are welcome!

---

**Note**: Remember to keep your personal information secure. Consider using a private repository if your CV contains sensitive data.