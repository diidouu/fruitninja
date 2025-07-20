#!/bin/bash

# Script pour corriger la signature de code de l'application biblio
set -e

APP_PATH="/Users/ismail/projet-biblio-multimedia/biblio/build/macOS-Release/biblio.app"

echo "🔧 Correction de la signature de code pour biblio.app..."

# Supprimer toutes les signatures existantes
echo "📝 Suppression des signatures existantes..."
codesign --remove-signature "$APP_PATH" 2>/dev/null || true

# Supprimer les attributs étendus qui peuvent causer des problèmes
echo "🧹 Nettoyage des attributs étendus..."
xattr -cr "$APP_PATH"

# Signer tous les frameworks Qt (dans l'ordre correct)
echo "🔐 Signature des frameworks Qt..."
find "$APP_PATH/Contents/Frameworks" -name "*.framework" -type d | while read framework; do
    if [ -f "$framework/Versions/Current/$(basename "$framework" .framework)" ]; then
        echo "  Signing: $(basename "$framework")"
        codesign --force --deep --sign - --options runtime "$framework"
    fi
done

# Signer tous les plugins
echo "🔐 Signature des plugins..."
find "$APP_PATH/Contents/PlugIns" -name "*.dylib" | while read dylib; do
    echo "  Signing: $(basename "$dylib")"
    codesign --force --sign - --options runtime "$dylib"
done

# Signer les bibliothèques OpenCV
echo "🔐 Signature des bibliothèques OpenCV..."
find "$APP_PATH/Contents/Frameworks" -name "*.dylib" | while read dylib; do
    echo "  Signing: $(basename "$dylib")"
    codesign --force --sign - --options runtime "$dylib"
done

# Signer le binaire principal
echo "🔐 Signature du binaire principal..."
codesign --force --sign - --options runtime "$APP_PATH/Contents/MacOS/biblio"

# Signer l'application entière
echo "🔐 Signature finale de l'application..."
codesign --force --deep --sign - --options runtime "$APP_PATH"

# Vérifier la signature
echo "✅ Vérification de la signature..."
codesign --verify --deep --strict --verbose=2 "$APP_PATH"

echo "🎉 Signature corrigée avec succès!"
echo "🚀 Test de lancement..."

# Tester le lancement
"$APP_PATH/Contents/MacOS/biblio" --version 2>/dev/null || echo "Note: L'application n'a pas d'option --version, c'est normal"
