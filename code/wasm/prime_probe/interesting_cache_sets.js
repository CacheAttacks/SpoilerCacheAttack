var numberOfSamples = 300;
Module['asm']._find_interesting_eviction_sets(Module['appStatePtr'], 1.5, numberOfSamples);

var numberOfObservedCacheSets = Module['numberOfObservedCacheSets'];
console.log(numberOfObservedCacheSets);
var wasmMemoryArray = new Uint32Array(Module['wasmMemory'].buffer);
var idleArrOffset = Module['idleTimesPtr']/Module['timesArrayByteFactor'];
var currentArrOffset = Module['currentTimesPtr']/Module['timesArrayByteFactor'];
var interestingCacheSets = "";
var interestingCounter = 0;
for(var i=0; i<numberOfObservedCacheSets; i++){
    //console.log(wasmMemoryArray[idleArrOffset] + " " + wasmMemoryArray[current_arr_offset] + " ");
    if(wasmMemoryArray[idleArrOffset++] * 1.7 < wasmMemoryArray[currentArrOffset++]){
        interestingCacheSets += i + " ";
        interestingCounter++;
    }
}
if(interestingCacheSets == ""){
    interestingCacheSets = "nothing found!";
}
console.log(interestingCacheSets);
console.log("found "+ interestingCounter);


//observe interesting cache sets and send observed data to R

for(var i=0; i<numberOfObservedCacheSets; i++){
    //console.log(wasmMemoryArray[idleArrOffset] + " " + wasmMemoryArray[current_arr_offset] + " ");
    if(wasmMemoryArray[idleArrOffset++] * 1.7 < wasmMemoryArray[current_arr_offset++]){

        Module['asm']._set_monitored_es(Module['appStatePtr'], i, i);

        var slotTime = 0;
        var printToBrowser = 0;

        Module['asm']._sample_es(Module['appStatePtr'], numberOfSamples, slotTime, printToBrowser);

        var POSTstr = Module['createPOSTStr'](Module['wasmMemoryArr'], Module['res']/Module['byteFactor'], Module['nrow'], Module['ncol']);
        Module['postxhr']('http://localhost:8000/changedata', POSTstr);

        d = new Date();
        Module['imgElement'].src = 'http://localhost:8000/plotdata?selected_es=' + document.getElementById('numberRangeEs').value + "&" + d.getTime();

    }
}