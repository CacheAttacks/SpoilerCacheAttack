source ~/MA_2/webassembly/emsdk-portable/emsdk_env.sh
emcc eviction_set_finder.c vlist.c timestats.c l3.c -s WASM=1 -o eviction_set_finder.html