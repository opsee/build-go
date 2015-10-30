#!/bin/bash
set -e 

build() {
  local os=$1
  local arch=$2

  echo "Building for GOOS=$os GOARCH=$arch"

  CGO_ENABLED=0 GOOS=$os GOARCH=$arch gb build
  if [ $? -ne 0 ]; then
    echo "Build failed..."
    exit 1
  fi

  target="target/${os}/${arch}"
  if [ -d bin/ ]; then
    bin="${target}/bin"
    mkdir -p $bin
    cp bin/* $bin
  fi

  if [ -d pkg/ ]; then
    pkg="${target}/pkg"
    mkdir -p $pkg
    cp -R pkg/* $pkg
  fi
}

TARGETS=${TARGETS:-"$(go env GOOS)/$(go env GOARCH)"}

cd /build

if [ -x build.sh ]; then
  echo "Running project local build steps..."
  ./build.sh
fi

rm -rf bin/ target/

gb test -v -cpu 1
if [ $? -ne 0 ]; then
  echo "Tests failed -- bailing out..."
  exit 1
fi

for t in $TARGETS; do
  arr=( $(echo $t | tr "/" " ") )
  os=${arr[0]}
  arch=${arr[1]}
  build $os $arch
done
