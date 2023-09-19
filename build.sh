#!/bin/bash
set -eux

LOOP=$(losetup --find --partscan --show ./steamos_image/disk.img)
mkdir -p ./steamos
mount ${LOOP}p3 ./steamos
unmountimg() {
    umount ./steamos
    losetup -d $LOOP
}
trap unmountimg ERR

PROGRESS_ARG=
if [[ -n "$CI" ]]; then
    PROGRESS_ARG=--progress=plain
fi

docker build $PROGRESS_ARG \
    --build-arg=REPO="${REPO:=rel}" \
    -t "ghcr.io/ian-h-chamberlain/holo-base:${TAG:=latest}"  \
    .

unmountimg
