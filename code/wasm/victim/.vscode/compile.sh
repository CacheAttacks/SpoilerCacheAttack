source ~/MA_2/webassembly/emsdk-portable/emsdk_env.sh
emcc victim.c -s WASM=1 -o victim.html -s EXPORTED_FUNCTIONS='["_main", "_int_sqrt", "_get_mem", "_read_mem", "_bla"]' --js-library myLibrary.js