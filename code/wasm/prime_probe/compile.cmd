#source ~/MA_2/webassembly/emsdk-portable/emsdk_env.sh
echo "hallo"
emcc c/main.c c/printf_wrapper.c c/vlist.c c/timestats.c c/SABcounter.c c/es_management.c c/l3.c c/l3_phases.c c/l3_test.c c/probe.c c/storefor_find_es.c c/example.c -s WASM=1 -o eviction_set_finder.html --js-library javascript/C_API_lib/R_webserver.js --js-library javascript/C_API_lib/myLibrary.js --js-library javascript/C_API_lib/storeForward.js -s ALLOW_MEMORY_GROWTH=1 -s TOTAL_MEMORY=768MB -g4 --source-map-base http://localhost:8080/ -s EXPORTED_FUNCTIONS='["_main", "_build_es", "_sample_es", "_set_monitored_es_arr", "_set_monitored_es", "_set_monitored_es_lower_half", "_measure_mean_access_time", "_change_type", "_build_es_ex", "_get_idle_times", "_find_interesting_eviction_sets", "_prime_spam_es", "_try_to_create_es", "_set_storefor_parameters", "_set_l3_cache_parameters", "_memaccesstime_for_js"]'

rm eviction_set_finder.html
