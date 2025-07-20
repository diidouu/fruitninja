#!/bin/bash

# Script pour corriger complètement la signature de code de l'application biblio
set -e

APP_PATH="/Users/ismail/projet-biblio-multimedia/biblio/build/macOS-Release/biblio.app"

echo "🔧 Correction complète de la signature de code pour biblio.app..."

# Fonction pour supprimer toutes les signatures
remove_all_signatures() {
    echo "📝 Suppression de toutes les signatures existantes..."
    
    # Supprimer signature de l'app
    codesign --remove-signature "$APP_PATH" 2>/dev/null || true
    
    # Supprimer signatures des frameworks
    find "$APP_PATH/Contents/Frameworks" -name "*.framework" -type d | while read framework; do
        codesign --remove-signature "$framework" 2>/dev/null || true
        # Aussi pour le binaire à l'intérieur du framework
        if [ -f "$framework/Versions/A/$(basename "$framework" .framework)" ]; then
            codesign --remove-signature "$framework/Versions/A/$(basename "$framework" .framework)" 2>/dev/null || true
        fi
    done
    
    # Supprimer signatures des dylibs
    find "$APP_PATH" -name "*.dylib" | while read dylib; do
        codesign --remove-signature "$dylib" 2>/dev/null || true
    done
    
    # Supprimer signature du binaire principal
    codesign --remove-signature "$APP_PATH/Contents/MacOS/biblio" 2>/dev/null || true
}

# Supprimer toutes les signatures existantes
remove_all_signatures

# Supprimer les attributs étendus qui peuvent causer des problèmes
echo "🧹 Nettoyage des attributs étendus..."
xattr -cr "$APP_PATH"

# Signer TOUS les binaires dans les frameworks Qt d'abord
echo "🔐 Signature des binaires dans les frameworks Qt..."
find "$APP_PATH/Contents/Frameworks" -name "*.framework" -type d | while read framework; do
    framework_name=$(basename "$framework" .framework)
    binary_path="$framework/Versions/A/$framework_name"
    if [ -f "$binary_path" ]; then
        echo "  Signing binary: $framework_name"
        codesign --force --sign - --timestamp=none "$binary_path"
    fi
done

# Signer tous les frameworks Qt complets
echo "🔐 Signature des frameworks Qt complets..."
find "$APP_PATH/Contents/Frameworks" -name "*.framework" -type d | while read framework; do
    echo "  Signing framework: $(basename "$framework")"
    codesign --force --sign - --timestamp=none "$framework"
done

# Signer toutes les bibliothèques dylib
echo "🔐 Signature des bibliothèques dylib..."
find "$APP_PATH/Contents/Frameworks" -name "*.dylib" | while read dylib; do
    echo "  Signing dylib: $(basename "$dylib")"
    codesign --force --sign - --timestamp=none "$dylib"
done

# Signer tous les plugins
echo "🔐 Signature des plugins..."
find "$APP_PATH/Contents/PlugIns" -name "*.dylib" | while read dylib; do
    echo "  Signing plugin: $(basename "$dylib")"
    codesign --force --sign - --timestamp=none "$dylib"
done

# Signer le binaire principal
echo "🔐 Signature du binaire principal..."
codesign --force --sign - --timestamp=none "$APP_PATH/Contents/MacOS/biblio"

# Signer l'application entière
echo "🔐 Signature finale de l'application..."
codesign --force --sign - --timestamp=none "$APP_PATH"

# Vérifier la signature
echo "✅ Vérification de la signature..."
codesign --verify --deep --strict --verbose=1 "$APP_PATH"

echo "🎉 Signature corrigée avec succès!"

# Tester le lancement
echo "🚀 Test de lancement de l'application..."
timeout 5s "$APP_PATH/Contents/MacOS/biblio" &
APP_PID=$!
sleep 2

if ps -p $APP_PID > /dev/null 2>&1; then
    echo "✅ L'application se lance avec succès!"
    kill $APP_PID 2>/dev/null || true
else
    echo "❌ L'application ne se lance pas correctement"
fi
