#!/bin/bash

for ARCH in i386 x86_64; do
  # remove old installers
  rm -f Disk\ Image/*.pkg

  ARCH=$ARCH ./build.sh

  GIT_VERSION=$(git --version | sed 's/git version //')
  PACKAGE_NAME="git-$GIT_VERSION-intel-$ARCH-leopard"
  echo $PACKAGE_NAME | pbcopy

  echo "Git version is $GIT_VERSION"

  /Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker --doc Git\ Installer.pmdoc/ -o Disk\ Image/git-$GIT_VERSION-intel-$ARCH-leopard.pkg --title "Git $GIT_VERSION"

  UNCOMPRESSED_IMAGE_FILENAME="$PACKAGE_NAME.uncompressed.dmg"
  IMAGE_FILENAME="$PACKAGE_NAME.dmg" 
  hdiutil create $UNCOMPRESSED_IMAGE_FILENAME -srcfolder "Disk Image" -volname "Git $GIT_VERSION Intel $ARCH Leopard" -ov
  hdiutil convert -format UDZO -o $IMAGE_FILENAME $UNCOMPRESSED_IMAGE_FILENAME
  rm $UNCOMPRESSED_IMAGE_FILENAME
done

echo "Testing the $ARCH installer..."

./test_installer.sh

echo "Git Installer $GIT_VERSION - OS X - Leopard - Intel $ARCH" | pbcopy
open "http://code.google.com/p/git-osx-installer/downloads/entry"
sleep 1
open "./"
