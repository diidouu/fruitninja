#!/bin/bash

# Script de compilation pour Windows
set -e

echo "=== Cross-compilation pour Windows ==="

# Créer le répertoire de build
mkdir -p build-windows
cd build-windows

# Configuration CMake pour Windows
cmake ../biblio \
    -DCMAKE_TOOLCHAIN_FILE=../windows-toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DQt6_DIR=/root/6.8.2/win64_mingw/lib/cmake/Qt6 \
    -DOpenCV_DIR=/opt/opencv-windows \
    -DCMAKE_INSTALL_PREFIX=/workspace/install-windows

# Compilation
cmake --build . --config Release

# Installation
cmake --install .

echo "=== Compilation terminée ==="
echo "L'exécutable Windows se trouve dans build-windows/"
