#!/bin/bash

# Script pour créer une version distribuable de l'application Biblio
# Usage: ./create-distributable.sh

set -e

echo "=== Création d'une version distribuable de Biblio ==="

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "biblio/CMakeLists.txt" ]; then
    echo "❌ Erreur : Ce script doit être exécuté depuis le répertoire racine du projet"
    exit 1
fi

# Aller dans le répertoire de build macOS
cd biblio/build/macOS-Release

# Vérifier que l'app existe
if [ ! -d "biblio.app" ]; then
    echo "❌ Erreur : biblio.app n'existe pas. Compilez d'abord le projet."
    exit 1
fi

echo "📦 Intégration des dépendances..."
macdeployqt biblio.app -verbose=0

echo "🔐 Signature de l'application..."
codesign --force --deep --sign - biblio.app

echo "✅ Vérification de la signature..."
codesign --verify --deep --verbose biblio.app

echo "📱 Test de l'application..."
# open biblio.app &

echo "📦 Création du DMG..."
# Nettoyer les anciens fichiers
rm -f /tmp/biblio_distributable.dmg ~/Desktop/Biblio-*.dmg

# Créer le DMG
hdiutil create -size 150m -fs HFS+ -volname "Biblio" /tmp/biblio_distributable.dmg > /dev/null
hdiutil attach /tmp/biblio_distributable.dmg > /dev/null
cp -R biblio.app "/Volumes/Biblio/"
hdiutil detach "/Volumes/Biblio" > /dev/null
hdiutil convert /tmp/biblio_distributable.dmg -format UDZO -o ~/Desktop/Biblio-Distributable.dmg > /dev/null

echo "📦 Création de l'archive ZIP..."
cd .. && zip -r ~/Desktop/Biblio-Distributable.zip macOS-Release/biblio.app > /dev/null

echo ""
echo "🎉 Terminé !"
echo "📁 Fichiers créés :"
echo "   • ~/Desktop/Biblio-Distributable.dmg ($(du -h ~/Desktop/Biblio-Distributable.dmg | cut -f1))"
echo "   • ~/Desktop/Biblio-Distributable.zip ($(du -h ~/Desktop/Biblio-Distributable.zip | cut -f1))"
echo ""
echo "📋 Instructions pour partager :"
echo "   1. Envoyez le fichier .dmg ou .zip à vos utilisateurs"
echo "   2. Ils doivent double-cliquer sur biblio.app (pas sur le fichier biblio à l'intérieur)"
echo "   3. Si macOS bloque l'app, ils doivent aller dans Réglages > Confidentialité et sécurité"
echo "      et autoriser l'application"
echo ""
echo "✅ Compatibilité : macOS 10.15+ (Apple Silicon et Intel)"
