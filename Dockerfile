FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies - using minimal TeX packages for faster builds
RUN apt-get update && apt-get install -y \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    python3 \
    python3-yaml \
    fonts-font-awesome \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Crimson Text font
RUN mkdir -p /usr/share/fonts/truetype/crimson-text && \
    cd /usr/share/fonts/truetype/crimson-text && \
    wget -q https://github.com/google/fonts/raw/main/ofl/crimsontext/CrimsonText-Regular.ttf && \
    wget -q https://github.com/google/fonts/raw/main/ofl/crimsontext/CrimsonText-Bold.ttf && \
    wget -q https://github.com/google/fonts/raw/main/ofl/crimsontext/CrimsonText-Italic.ttf && \
    wget -q https://github.com/google/fonts/raw/main/ofl/crimsontext/CrimsonText-BoldItalic.ttf && \
    fc-cache -f -v && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy project files
COPY data/ /workspace/data/
COPY template/ /workspace/template/
COPY scripts/ /workspace/scripts/

# Make script executable
RUN chmod +x /workspace/scripts/generate-cv.py

# Create output directory and set it as volume
RUN mkdir -p /output
VOLUME ["/output"]

# Set output directory as working directory for compilation
WORKDIR /workspace

# Default command
ENTRYPOINT ["python3", "/workspace/scripts/generate-cv.py"]
CMD ["en"]