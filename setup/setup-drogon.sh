#!/usr/bin/env bash

set -e

echo "=== Drogon setup script ==="

# Detect operating system
OS=$(uname)

install_ubuntu() {
    echo "Detected Ubuntu/Debian system"
    # Update package list and install required dependencies
    sudo apt update
    sudo apt install -y \
        build-essential \   # GCC, g++, make, etc.
        cmake \             # Build system
        git \               # Source control
        uuid-dev \          # UUID library
        libjsoncpp-dev \    # JSON library
        libssl-dev \        # OpenSSL for TLS/SSL
        zlib1g-dev \        # Compression library
        libyaml-cpp-dev     # YAML library
}

install_macos() {
    echo "Detected macOS system"
    # Check if Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Please install it from https://brew.sh"
        exit 1
    fi
    # Update Homebrew and install dependencies
    brew update
    brew install cmake git jsoncpp openssl zlib yaml-cpp
}

install_freebsd() {
    echo "Detected FreeBSD system"
    # Update package list and install required dependencies
    sudo pkg update
    sudo pkg install -y \
        cmake \      # Build system
        git \        # Source control
        gcc \        # Compiler
        jsoncpp \    # JSON library
        libuuid \    # UUID library
        openssl \    # TLS/SSL
        zlib \       # Compression library
        yaml-cpp     # YAML library
}

# Choose installation method based on OS
case "$OS" in
    Linux)
        if [ -f /etc/debian_version ]; then
            install_ubuntu
        else
            echo "Linux detected, but not Debian/Ubuntu. Please install manually:"
            echo "C++17 compiler, cmake, git, uuid, jsoncpp, openssl, zlib, yaml-cpp"
        fi
        ;;
    Darwin)
        install_macos
        ;;
    FreeBSD)
        install_freebsd
        ;;
    *)
        echo "Unknown system: $OS"
        echo "Please install manually: C++17 compiler, cmake, git, uuid, jsoncpp, openssl, zlib, yaml-cpp"
        ;;
esac

echo "=== All dependencies installed successfully! ==="
