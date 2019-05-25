wget -O emsdk-portable.tar.gz https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
tar -xvzf emsdk-portable.tar.gz
rm emsdk-portable.tar.gz
cd emsdk-portable
./emsdk update
./emsdk install sdk-1.38.11-64bit
./emsdk activate sdk-1.38.11-64bit
#at each startup
source ./emsdk_env.sh
