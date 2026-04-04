# Node.js 20 Development Container
# Alpine-based for minimal size and fast startup

FROM node:20-alpine

# Install additional tools
RUN apk add --no-cache \
    build-base \
    git \
    curl \
    ca-certificates \
    zsh \
    vim \
    less

# Install chezmoi for dotfiles management
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin init only

# Install global Node tools
RUN npm install -g \
    typescript \
    ts-node \
    eslint \
    prettier \
    pnpm

# Create workspace
WORKDIR /workspace

# Set npm to non-interactive
ENV CI=true

CMD ["/bin/sh"]
