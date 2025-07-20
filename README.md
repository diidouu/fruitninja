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
