# Drogon Project Setup

This guide explains how to install all dependencies, clone the Drogon framework, and build it on your system.

---

## 📦 Prerequisites

Before building Drogon, you need:
- A C++17 compiler (GCC ≥ 7.5, Clang ≥ 6.0, or MSVC ≥ 2017)
- CMake ≥ 3.5
- Git
- Libraries: `uuid`, `jsoncpp`, `openssl`, `zlib`, `yaml-cpp`

---

## ⚙️ Installation Steps

### 1. Install Dependencies
Run the setup script to automatically install all required packages:

```bash
chmod +x setup-drogon.sh
./setup-drogon.sh
```

This script detects your operating system (Ubuntu/Debian, macOS, FreeBSD) and installs the necessary tools and libraries.

---

### 2. Clone Drogon Repository
Clone the official Drogon repository from GitHub:

```bash
git clone https://github.com/drogonframework/drogon.git
```

---

### 3. Build Drogon
Enter the Drogon directory and run the build script:

```bash
cd drogon
chmod +x build.sh
sudo ./build.sh
```

This will configure, compile, and install Drogon into your system directories:
- Binaries → `/usr/local/bin/`
- Libraries → `/usr/local/lib/`
- Headers → `/usr/local/include/drogon/`
- CMake config → `/usr/local/lib/cmake/Drogon/`

---

## ✅ Verify Installation

After installation, check that Drogon is available:

```bash
which drogon_ctl
drogon_ctl --version
ls /usr/local/include/drogon
ls /usr/local/lib | grep drogon
```

Once you have verified the installation, you can safely delete the drogon source directory that you cloned earlier