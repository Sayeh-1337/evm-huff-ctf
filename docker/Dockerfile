# HUFF-CTF Challenge Docker Environment
# Provides a complete environment with Foundry, Huff compiler, and Python

FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    python3-pip \
    ca-certificates \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (required for Foundry)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:/root/.foundry/bin:/root/.huff/bin:${PATH}"
ENV RUSTUP_HOME="/root/.rustup"
ENV CARGO_HOME="/root/.cargo"

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash
RUN /root/.foundry/bin/foundryup

# Install Huff compiler using official huffup installer (recommended method)
RUN curl -L get.huff.sh | bash
ENV PATH="/root/.huff/bin:${PATH}"

# Install the compiler using huffup
RUN /root/.huff/bin/huffup

# Verify huffc installation
RUN huffc --version

# Install Python dependencies
RUN pip3 install --no-cache-dir \
    pytest \
    black

# Set working directory
WORKDIR /app

# Copy challenge files
COPY challenge /app/challenge
COPY README.md /app/
COPY docker/entrypoint.sh /app/docker/entrypoint.sh
COPY docker/get_bytecode.sh /app/docker/get_bytecode.sh

# Make scripts executable
RUN chmod +x /app/challenge/deploy.sh
RUN chmod +x /app/docker/entrypoint.sh
RUN chmod +x /app/docker/get_bytecode.sh

# Default command (entrypoint will handle deployment)
CMD ["/app/docker/entrypoint.sh"]
