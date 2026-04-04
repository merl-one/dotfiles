# Python 3.11 Development Container
# Minimal, fast image with poetry and common tools

FROM python:3.11-slim

# Set labels for dev container spec
LABEL devcontainer.metadata='[{"customizations":{"vscode":{"extensions":["ms-python.python"]}}}]'

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    wget \
    zsh \
    vim \
    less \
    && rm -rf /var/lib/apt/lists/*

# Install chezmoi for dotfiles management
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin init only

# Install Python tools
RUN pip install --upgrade \
    pip \
    setuptools \
    wheel \
    poetry \
    black \
    ruff \
    mypy

# Create workspace directory
WORKDIR /workspace

# Default to bash for now (zsh will be initialized by postCreateCommand)
CMD ["/bin/bash"]
