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
        build-essential \
        cmake \
        git \
        uuid-dev \
        libjsoncpp-dev \
        libssl-dev \
        zlib1g-dev \
        libyaml-cpp-dev
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

# Clone and build Drogon from source
echo "=== Building Drogon from source ==="

DROGON_VERSION="v1.9.8"
BUILD_DIR="/tmp/drogon_build"

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Clone Drogon repository
if [ -d "drogon" ]; then
    echo "Drogon directory already exists, updating..."
    cd drogon
    git fetch --all
    git checkout "$DROGON_VERSION"
    git submodule update --init --recursive
else
    echo "Cloning Drogon repository..."
    git clone https://github.com/drogonframework/drogon.git
    cd drogon
    git checkout "$DROGON_VERSION"
    git submodule update --init --recursive
fi

# Create build directory for CMake
mkdir -p build
cd build

# Configure with CMake
echo "Configuring Drogon with CMake..."
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING=OFF

# Build Drogon
echo "Building Drogon (this may take a while)..."
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# Install Drogon
echo "Installing Drogon..."
sudo make install

# Update shared library cache (Linux only)
if [ "$OS" = "Linux" ]; then
    sudo ldconfig
fi

# Clean up build directory (optional)
# rm -rf "$BUILD_DIR"

echo "=== Drogon installed successfully! ==="
echo "You can now use Drogon in your projects."
