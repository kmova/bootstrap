#!/bin/bash

set -ex

GO_VERSION="1.7.3"
CURDIR=`pwd`

# Setup go, for development
SRCROOT="/usr/local/go"
SRCPATH="$CURDIR/gopath"

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

# Setup the GOPATH; 
# This allows subsequent "go get" commands to work.
mkdir -p $SRCPATH

cat <<EOF >/tmp/gopath.sh
export GOPATH="$SRCPATH"
export GOROOT="$SRCROOT"
export PATH="$SRCROOT/bin:$SRCPATH/bin:\$PATH"
EOF

sudo mv /tmp/gopath.sh /etc/profile.d/gopath.sh
sudo chmod 0755 /etc/profile.d/gopath.sh
source /etc/profile.d/gopath.sh

cd ${CURDIR}
