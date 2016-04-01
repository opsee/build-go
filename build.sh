#!/bin/bash
set -e

build() {
  local os=$1
  local arch=$2
  local target="target/${os}/${arch}"
  mkdir -p "$target"

  for f in ./cmd/**/; do
    echo "Building $(basename $f) for GOOS=$os GOARCH=$arch"
    CGO_ENABLED=0 GOOS=$os GOARCH=$arch govendor build -v -o "$target/bin/$(basename $f)" $f
    if [ $? -ne 0 ]; then
      echo "Build failed..."
      exit 1
    fi
  done
}

TARGETS=${TARGETS:-"$(go env GOOS)/$(go env GOARCH)"}

cd "${GOPATH}/src/${PROJECT}"

if [ -x build.sh ]; then
  echo "Running project local build steps..."
  ./build.sh
fi

govendor test -v -bench -race +local
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
