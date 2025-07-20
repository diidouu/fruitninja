#!/bin/bash

# Script pour packager l'application pour Windows
# Ce script nécessite un environnement de compilation croisée ou une machine Windows

echo "=== Configuration pour Windows ==="

# Définir les variables
PROJECT_DIR="/Users/ismail/projet-biblio-multimedia/biblio"
BUILD_DIR="$PROJECT_DIR/build/Windows-Release"
DEPLOY_DIR="$PROJECT_DIR/deploy/Windows"

# Créer les répertoires
mkdir -p "$BUILD_DIR"
mkdir -p "$DEPLOY_DIR"

echo "Répertoires créés : $BUILD_DIR et $DEPLOY_DIR"

# Instructions pour la compilation Windows
echo ""
echo "=== Instructions pour Windows ==="
echo "1. Transférer ce projet sur un système Windows avec Qt6 et OpenCV installés"
echo "2. Ouvrir un terminal Windows et naviguer vers le dossier du projet"
echo "3. Exécuter les commandes suivantes :"
echo ""
echo "   mkdir build\\Windows-Release"
echo "   cd build\\Windows-Release"
echo "   cmake -G \"MinGW Makefiles\" -DCMAKE_BUILD_TYPE=Release ../.."
echo "   cmake --build . --config Release"
echo "   windeployqt.exe biblio.exe --qmldir ../.. --verbose 2"
echo ""
echo "4. L'exécutable sera dans build/Windows-Release/"
echo ""

# Créer un fichier batch pour Windows
cat > "$PROJECT_DIR/build_windows.bat" << 'EOF'
@echo off
echo Building Biblio for Windows...

if not exist "build\Windows-Release" mkdir "build\Windows-Release"
cd "build\Windows-Release"

echo Configuring with CMake...
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..\..
if %errorlevel% neq 0 (
    echo CMake configuration failed!
    pause
    exit /b 1
)

echo Building project...
cmake --build . --config Release
if %errorlevel% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo Deploying Qt dependencies...
windeployqt.exe biblio.exe --qmldir ..\.. --verbose 2
if %errorlevel% neq 0 (
    echo Deployment failed!
    pause
    exit /b 1
)

echo Build completed successfully!
echo Executable is in: build\Windows-Release\biblio.exe
pause
EOF

echo "Fichier build_windows.bat créé"

# Créer un README pour Windows
cat > "$PROJECT_DIR/README_Windows.md" << 'EOF'
# Compilation pour Windows

## Prérequis
1. Qt6 (avec Qt Creator optionnel)
2. OpenCV 4.x
3. CMake 3.19+
4. MinGW ou MSVC compiler
5. Git (optionnel)

## Installation des dépendances

### Qt6
- Télécharger Qt6 depuis https://www.qt.io/download
- Installer avec les composants : Core, Widgets, OpenGL, Multimedia

### OpenCV
- Télécharger OpenCV depuis https://opencv.org/releases/
- Extraire dans C:\opencv
- Ajouter C:\opencv\build\x64\vc16\bin au PATH

### CMake
- Télécharger CMake depuis https://cmake.org/download/
- Installer et ajouter au PATH

## Compilation

### Méthode 1 : Script automatique
1. Double-cliquer sur `build_windows.bat`
2. Attendre la fin de la compilation
3. L'exécutable sera dans `build\Windows-Release\`

### Méthode 2 : Ligne de commande
```cmd
mkdir build\Windows-Release
cd build\Windows-Release
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..\..
cmake --build . --config Release
windeployqt.exe biblio.exe --qmldir ..\.. --verbose 2
```

### Méthode 3 : Qt Creator
1. Ouvrir CMakeLists.txt dans Qt Creator
2. Configurer le projet avec MinGW
3. Compiler en mode Release
4. Utiliser windeployqt pour déployer

## Distribution
Après compilation, le dossier `build\Windows-Release\` contiendra :
- biblio.exe (votre application)
- Toutes les DLL Qt nécessaires
- Les assets (textures, sons)

Vous pouvez distribuer tout ce dossier.
EOF

echo "README_Windows.md créé"
echo ""
echo "=== Résumé ==="
echo "Files créés :"
echo "- build_windows.bat (script de compilation Windows)"
echo "- README_Windows.md (instructions détaillées)"
echo ""
echo "Pour créer l'exécutable Windows :"
echo "1. Transférer le projet sur un PC Windows"
echo "2. Installer Qt6, OpenCV, et CMake"
echo "3. Exécuter build_windows.bat"
