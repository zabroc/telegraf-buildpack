#!/bin/bash

set -euo pipefail

DEPS_DIR=$1
DEPS_IDX=$2

echo "-----> Install $SIDECAR_NAME binaries"

VERSION="1.27.2"
URL="https://dl.influxdata.com/telegraf/releases/telegraf-${VERSION}_linux_amd64.tar.gz"
SHA256="2a051e5113898cea52c6bbb4835fd73bf835c5a5976dd7901108ea68adae2749"

DepDir="$DEPS_DIR/$DEPS_IDX"
InstallDir="$DepDir/telegraf"

if [ ! -f $InstallDir/telegraf ]; then
  
  echo "-----> Download telegraf ${VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o /tmp/module.tar.gz

  DOWNLOAD_SHA256=$(shasum -a 256 /tmp/module.tar.gz | cut -d ' ' -f 1)

  if [[ $DOWNLOAD_SHA256 != $SHA256 ]]; then
    echo "       **ERROR** SHA256 mismatch: got $DOWNLOAD_SHA256 expected $SHA256"
    exit 1
  fi

  tar xfz /tmp/module.tar.gz -C $DepDir
  mkdir -p $InstallDir
  mv "$DepDir/telegraf-${VERSION}/usr/bin/telegraf" "$InstallDir/"
  mv "$BUILDPACK_DIR/src/telegraf/telegraf.conf" "$InstallDir/"
  mv "$BUILDPACK_DIR/src/telegraf/THIRD_PARTY_LICENSES" "$InstallDir/"
  rm /tmp/module.tar.gz

  mkdir -p "$DepDir/bin"
  cd $DepDir/bin;
  ln -s "../telegraf/telegraf" "./telegraf" 

fi

if [ ! -f $InstallDir/telegraf ]; then
  echo "       **ERROR** Could not download $SIDECAR_NAME"
  exit 1
fi
