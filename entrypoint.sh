#!/bin/bash

set -euv

/build.sh

readlink -f $(which sh)

EVENT_DATA=$(cat $GITHUB_EVENT_PATH)
echo $EVENT_DATA | jq .
UPLOAD_URL=$(echo $EVENT_DATA | jq -r .release.upload_url)
UPLOAD_URL=${UPLOAD_URL/\{?name,label\}/}
RELEASE_NAME=$(echo $EVENT_DATA | jq -r .release.tag_name)


cd $GITHUB_WORKSPACE/build/bin
tar cvfz tmp.tgz "zone" "world" "ucs" "queryserv" "eqlaunch" "loginserver" "shared_memory"

CHECKSUM=$(md5sum tmp.tgz | cut -d ' ' -f 1)

curl \
  -X POST \
  --data-binary @tmp.tgz \
  -H 'Content-Type: application/gzip' \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${UPLOAD_URL}?name=server_${RELEASE_NAME}.tar.gz"

curl \
  -X POST \
  --data $CHECKSUM \
  -H 'Content-Type: text/plain' \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${UPLOAD_URL}?name=server_${RELEASE_NAME}_checksum.txt"