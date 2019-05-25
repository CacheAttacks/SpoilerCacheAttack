wget -O emsdk-portable.tar.gz https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
tar -xvzf emsdk-portable.tar.gz
rm emsdk-portable.tar.gz
cd emsdk-portable
call emsdk update
call emsdk install sdk-1.38.11-64bit
call emsdk activate sdk-1.38.11-64bit
#at each startup
emsdk_env.bat
