var number_of_samples = 300;
Module['asm']._find_interesting_eviction_sets(Module['appStatePtr'], 1.5, number_of_samples);

var wasmMemoryArray = new Uint32Array(Module['wasmMemory'].buffer);
var idle_arr_offset = Module['idleTimesPtr']/Module['timesArrayByteFactor'];
var current_arr_offset = Module['currentTimesPtr']/Module['timesArrayByteFactor'];
var interesting_cache_sets = "";
for(var i=0; i<number_of_samples; i++){
    //console.log(wasmMemoryArray[idle_arr_offset] + " " + wasmMemoryArray[current_arr_offset] + " ");
    if(wasmMemoryArray[++idle_arr_offset] * 1.2 < wasmMemoryArray[++current_arr_offset]){
        interesting_cache_sets += i + " ";
    }
}
if(interesting_cache_sets == ""){
    interesting_cache_sets = "nothing found!";
}
console.log(interesting_cache_sets);