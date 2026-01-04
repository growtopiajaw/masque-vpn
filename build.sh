#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

if ! command -v git &> /dev/null
then
    DEV_VER="development"
else
    DEV_VER="dev-$(git rev-parse --short HEAD)"
fi

VERSION=${VERSION:=$DEV_VER}

build_client() {
    pushd vpn_client
    EXT=""
    [[ $GOOS = "windows" ]] && EXT=".exe"
    echo "Building ${GOOS} ${GOARCH} ${GOARM}"
    CGO_ENABLED=0 go build \
        -trimpath \
        -ldflags="-s -w" \
        -o ./bin/vpn-client-${GOOS}-${GOARCH}-${GOARM}${EXT} .
    popd
}

build_server() {
    pushd vpn_server
    EXT=""
    [[ $GOOS = "windows" ]] && EXT=".exe"
    echo "Building ${GOOS} ${GOARCH} ${GOARM}"
    CGO_ENABLED=0 go build \
        -trimpath \
        -ldflags="-s -w" \
        -o ./bin/vpn-server-${GOOS}-${GOARCH}-${GOARM}${EXT} .
    popd
}
### multi arch binary build
GOOS=linux GOARCH=arm GOARM=5 build_client
GOOS=linux GOARCH=arm GOARM=6 build_client
GOOS=linux GOARCH=arm GOARM=7 build_client
GOOS=linux GOARCH=386 build_client
GOOS=linux GOARCH=amd64 build_client
GOOS=windows GOARCH=amd64 build_client
GOOS=windows GOARCH=386 build_client

GOOS=linux GOARCH=arm GOARM=5 build_server
GOOS=linux GOARCH=arm GOARM=6 build_server
GOOS=linux GOARCH=arm GOARM=7 build_server
GOOS=linux GOARCH=386 build_server
GOOS=linux GOARCH=amd64 build_server
GOOS=windows GOARCH=amd64 build_server
GOOS=windows GOARCH=386 build_server
