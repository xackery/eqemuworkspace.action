#!/bin/sh

set -euv

EVENT_DATA=$(cat $GITHUB_EVENT_PATH)
echo $EVENT_DATA | jq .
RELEASE_NAME=$(echo $EVENT_DATA | jq -r .release.tag_name)

cd $GITHUB_WORKSPACE

git submodule update --init --recursive --remote
sed -i 's:CURRENT_VERSION .*".*":CURRENT_VERSION "${RELEASE_NAME}":g' ./common/version.h

echo "Making release $RELEASE_NAME"
mkdir -p build 
cd build 
cmake -DEQEMU_BUILD_LOGIN=ON -DEQEMU_BUILD_LUA=ON -G 'Unix Makefiles' ..
make
ls