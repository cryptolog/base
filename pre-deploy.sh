#!/bin/bash

OUTDIR=$TRAVIS_BUILD_DIR/out/$TRAVIS_PULL_REQUEST/$TRAVIS_JOB_NUMBER-$HOST
mkdir -p $OUTDIR/bin

ARCHIVE_CMD="zip"

if [[ $HOST = "i686-w64-mingw32" ]]; then
  ARCHIVE_NAME="base-windows-32bit.zip"
elif [[ $HOST = "x86_64-w64-mingw32" ]]; then
    ARCHIVE_NAME="base-windows-64bit.zip"
elif [[ $HOST = "arm-linux-gnueabihf" ]]; then
    ARCHIVE_NAME="base-arm-x86.tar.gz"
    ARCHIVE_CMD="tar -czf"
elif [[ $HOST = "aarch64-linux-gnu" ]]; then
    ARCHIVE_NAME="base-arm-x64.tar.gz"
    ARCHIVE_CMD="tar -czf"
elif [[ $HOST = "x86_64-unknown-linux-gnu" ]]; then
    ARCHIVE_NAME="base-linux-x64.tar.gz"
    ARCHIVE_CMD="tar -czf"
elif [[ $HOST = "x86_64-apple-darwin11" ]]; then
    ARCHIVE_NAME="base-osx-x64.zip"
fi

cp $TRAVIS_BUILD_DIR/src/qt/base-qt $OUTDIR/bin/ || cp $TRAVIS_BUILD_DIR/src/qt/base-qt.exe $OUTDIR/bin/ || echo "no QT Wallet"
cp $TRAVIS_BUILD_DIR/src/based $OUTDIR/bin/ || cp $TRAVIS_BUILD_DIR/src/basecoind.exe $OUTDIR/bin/
cp $TRAVIS_BUILD_DIR/src/base-cli $OUTDIR/bin/ || cp $TRAVIS_BUILD_DIR/src/base-cli.exe $OUTDIR/bin/
strip "$OUTDIR/bin"/* || echo "nothing to strip"
ls -lah $OUTDIR/bin

cd $OUTDIR/bin
ARCHIVE_CMD="$ARCHIVE_CMD $ARCHIVE_NAME *"
eval $ARCHIVE_CMD

mkdir -p $OUTDIR/zip
mv $ARCHIVE_NAME $OUTDIR/zip

sleep $[ ( $RANDOM % 6 )  + 1 ]s
