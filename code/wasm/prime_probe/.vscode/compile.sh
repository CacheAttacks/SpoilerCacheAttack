source ~/MA_2/webassembly/emsdk-portable/emsdk_env.sh
emcc -O0 eviction_set_finder.c vlist.c timestats.c SABcounter.c l3.c -s WASM=1 -o eviction_set_finder.html --js-library myLibrary.js -s TOTAL_MEMORY=256MB
