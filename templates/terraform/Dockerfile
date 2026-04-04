# Terraform & Ansible Development Container
# For infrastructure-as-code projects

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Update and install base tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    wget \
    unzip \
    zsh \
    vim \
    less \
    jq \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install chezmoi for dotfiles management
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin init only

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform && \
    rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN pip3 install --no-cache-dir \
    ansible \
    ansible-lint \
    netaddr \
    jinja2

# Install AWS CLI
RUN pip3 install --no-cache-dir awscli

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Create workspace
WORKDIR /workspace

CMD ["/bin/bash"]
