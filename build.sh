#!/bin/sh

set -eu

EVENT_DATA=$(cat $GITHUB_EVENT_PATH)
echo $EVENT_DATA | jq .
RELEASE_NAME=$(echo $EVENT_DATA | jq -r .release.tag_name)

cd $GITHUB_WORKSPACE

sed -i 's:CURRENT_VERSION .*".*":CURRENT_VERSION "${RELEASE_NAME}":g' common/version.h

echo "build"
mkdir -p build 
cd build 
echo "cmake"
cmake -DEQEMU_BUILD_LOGIN=ON -DEQEMU_BUILD_LUA=ON -G 'Unix Makefiles' ..
cd code/build 
echo "make"
make
echo "final files:"
ls