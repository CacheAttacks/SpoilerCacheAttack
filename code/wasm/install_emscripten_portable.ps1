Invoke-WebRequest https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz -OutFile emsdk-portable.tar.gz 
tar -xvzf emsdk-portable.tar.gz
del emsdk-portable.tar.gz
cd emsdk-portable
.\emsdk update
.\emsdk install sdk-1.38.11-64bit
.\emsdk activate sdk-1.38.11-64bit
.\emsdk_env.bat
