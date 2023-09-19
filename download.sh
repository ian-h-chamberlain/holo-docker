#!/bin/sh
set -eux

VARIANT=${VARIANT:="steamdeck"}
BUILD_ID=${BUILD_ID:="20220526.1"}

# these are hardcoded and can be found in ~/.netrc
AUTH="jupiter-image-2021:e54fe7f0-756e-46e1-90d2-7843cda0ac01"
FILE="$(
    curl -sS  --user $AUTH --get 'https://steamdeck-atomupd.steamos.cloud/updates' \
        -d "product=steamos" \
        -d "release=holo" \
        -d "arch=amd64" \
        -d "version=snapshot" \
        -d "variant=$VARIANT" \
        -d "buildid=$BUILD_ID" \
        -d "checkpoint=False" \
        -d "estimated_size=0" \
    | tee /dev/stderr \
    | jq -r ".minor.candidates[0].update_path" \
    | sed 's/\.raucb/\.img.zip/'
)"
echo "Downloading image $FILE"
curl --user $AUTH "https://steamdeck-images.steamos.cloud/$FILE" -o ./steamos.zip
unzip ./steamos.zip -d ./steamos_image
rm ./steamos.zip
