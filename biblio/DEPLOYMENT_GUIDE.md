# Guide de Déploiement Multi-Plateforme - Biblio

## 🍎 macOS (votre plateforme actuelle)

### Compilation locale
```bash
cd /Users/ismail/projet-biblio-multimedia/biblio
mkdir -p build/macOS-Release
cd build/macOS-Release
cmake -DCMAKE_BUILD_TYPE=Release ../..
make -j4
```

### Création du bundle .app
```bash
# Déploiement des dépendances Qt
macdeployqt biblio.app -verbose=2

# Création d'un DMG (optionnel)
hdiutil create -volname "Biblio" -srcfolder biblio.app -ov -format UDZO biblio.dmg
```

## 🪟 Windows

### Prérequis Windows
1. **Qt6** : https://www.qt.io/download
   - Composants nécessaires : Core, Widgets, OpenGL, Multimedia
2. **OpenCV 4.x** : https://opencv.org/releases/
3. **CMake 3.19+** : https://cmake.org/download/
4. **Compilateur** : MinGW (inclus avec Qt) ou Visual Studio

### Installation OpenCV sur Windows
```cmd
# Télécharger OpenCV et extraire dans C:\opencv
# Ajouter au PATH système :
C:\opencv\build\x64\vc16\bin

# Variables d'environnement :
OpenCV_DIR=C:\opencv\build
```

### Compilation Windows
```cmd
# Méthode 1 : Script automatique
build_windows.bat

# Méthode 2 : Manuelle
mkdir build\Windows-Release
cd build\Windows-Release
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..\..
cmake --build . --config Release

# Déploiement des DLL Qt
windeployqt.exe biblio.exe --qmldir ..\.. --verbose 2
```

### Création d'un installeur Windows (optionnel)
1. Installer Inno Setup : https://jrsoftware.org/isinfo.php
2. Compiler `installer.iss`
3. L'installeur sera créé dans le dossier `installer/`

## 🐧 Linux (Ubuntu/Debian)

### Installation des dépendances
```bash
sudo apt update
sudo apt install qt6-base-dev qt6-multimedia-dev libqt6opengl6-dev
sudo apt install libopencv-dev cmake build-essential
```

### Compilation
```bash
mkdir -p build/Linux-Release
cd build/Linux-Release
cmake -DCMAKE_BUILD_TYPE=Release ../..
make -j$(nproc)
```

### Création d'un AppImage (optionnel)
```bash
# Installer linuxdeploy
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

# Créer l'AppImage
./linuxdeploy-x86_64.AppImage --appdir AppDir --executable biblio --create-desktop-file --output appimage
```

## 📦 Distribution

### Structure finale pour Windows
```
biblio-windows/
├── biblio.exe
├── Qt6Core.dll
├── Qt6Gui.dll
├── Qt6Widgets.dll
├── Qt6OpenGL.dll
├── Qt6Multimedia.dll
├── opencv_world470.dll
├── platforms/
│   └── qwindows.dll
├── imageformats/
├── mediaservice/
└── assets/
    ├── textures/
    ├── sounds/
    └── *.xml
```

### Structure finale pour macOS
```
biblio.app/
├── Contents/
│   ├── MacOS/
│   │   └── biblio
│   ├── Frameworks/
│   │   ├── QtCore.framework/
│   │   ├── QtWidgets.framework/
│   │   └── ...
│   ├── Resources/
│   │   └── assets/
│   └── Info.plist
```

## 🚀 Distribution finale

### Options de distribution
1. **GitHub Releases** : Téléchargement direct
2. **Site web** : Hébergement propre
3. **Stores** : Microsoft Store, Mac App Store
4. **Portables** : Versions sans installation

### Tailles approximatives
- Windows : ~50-100 MB (avec DLL Qt)
- macOS : ~80-150 MB (avec frameworks Qt)
- Linux : ~30-60 MB (si Qt installé séparément)

## 🔧 Dépannage courant

### Windows
- **OpenCV non trouvé** : Vérifier la variable `OpenCV_DIR`
- **DLL manquantes** : Utiliser `windeployqt` correctement
- **Erreur de compilation** : Vérifier que MinGW est dans le PATH

### macOS
- **Framework non trouvé** : Utiliser `macdeployqt`
- **Permissions** : `chmod +x biblio.app/Contents/MacOS/biblio`

### Tous
- **Textures manquantes** : Vérifier que le dossier `assets/` est copié
- **Caméra non détectée** : Vérifier les permissions système
