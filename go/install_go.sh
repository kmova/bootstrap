#!/bin/bash

set -ex

GO_VERSION="1.10"
CURDIR=`pwd`

# Setup go, for development
SRCROOT="/usr/local/go_${GO_VERSION}"

# Get the ARCH
ARCH=`uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|'`

# Install Go
cd /tmp

if [ ! -f "./go${GO_VERSION}.linux-${ARCH}.tar.gz" ]; then
  wget -q https://storage.googleapis.com/golang/go${GO_VERSION}.linux-${ARCH}.tar.gz
fi

tar -xf go${GO_VERSION}.linux-${ARCH}.tar.gz
sudo mv go $SRCROOT
sudo chmod 775 $SRCROOT

echo "GOROOT=$SRCROOT" > ~/.profile 

cd ${CURDIR}
