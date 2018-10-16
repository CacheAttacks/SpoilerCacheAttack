// much better results with 1000 instead 300
var numberOfSamples = 1000;
var numberOfRounds = 2;
var refFactorThreshold = 1.7; //mean access time have to greater than refFactorThreshold * idle mean value
var threshold = 1;

var numberOfObservedCacheSets = Module['numberOfObservedCacheSets'];
console.log(numberOfObservedCacheSets);
var arrNumberOfObservedCacheSets = new Array(numberOfObservedCacheSets).fill(0);

// do this multiple times to eliminate outliers
for (var rounds = 0; rounds < numberOfRounds; rounds++) {
  Module['asm']._find_interesting_eviction_sets(
      Module['appStatePtr'], 1.5, numberOfSamples);

  var wasmMemoryArray = new Uint32Array(Module['wasmMemory'].buffer);
  var idleArrOffset = Module['idleTimesPtr'] / Module['timesArrayByteFactor'];
  var currentArrOffset =
      Module['currentTimesPtr'] / Module['timesArrayByteFactor'];
  var interestingCacheSets = '';
  var interestingCounter = 0;
  for (var i = 0; i < numberOfObservedCacheSets; i++) {
    // console.log(wasmMemoryArray[idleArrOffset] + " " +
    // wasmMemoryArray[current_arr_offset] + " ");
    if (wasmMemoryArray[idleArrOffset++] * refFactorThreshold <
        wasmMemoryArray[currentArrOffset++]) {
      arrNumberOfObservedCacheSets[i]++;
      interestingCacheSets += i + ' ';
      interestingCounter++;
    }
  }
  // if(interestingCacheSets == ""){
  //     interestingCacheSets = "nothing found!";
  // }
  // console.log(interestingCacheSets);
  // console.log("found "+ interestingCounter);
}

var listInterestingCacheSets = [];
var interestingCacheSets = 'over threshold: ';
for (var i = 0; i < numberOfObservedCacheSets; i++) {
  if (arrNumberOfObservedCacheSets[i] >= threshold) {
    //"(floor64:" + Math.floor(i/64) +
    interestingCacheSets += i + '(' + Math.floor(i / 64) + ',' + i % 64 + ') ';
    listInterestingCacheSets.push(i);
  }
}
consoleLogEx(interestingCacheSets);



// observe interesting cache sets and send observed data to R

// for(var i=0; i<numberOfObservedCacheSets; i++){
//     //console.log(wasmMemoryArray[idleArrOffset] + " " +
//     wasmMemoryArray[current_arr_offset] + " ");
//     if(wasmMemoryArray[idleArrOffset++] * 1.7 <
//     wasmMemoryArray[currentArrOffset++]){

//         Module['asm']._set_monitored_es(Module['appStatePtr'], i, i);

//         var slotTime = 0;
//         var printToBrowser = 0;

//         Module['asm']._sample_es(Module['appStatePtr'], numberOfSamples,
//         slotTime, printToBrowser);

//         var POSTstr = Module['createPOSTStr'](Module['wasmMemoryArr'],
//         Module['res']/Module['byteFactor'], Module['nrow'], Module['ncol']);
//         Module['postxhr']('http://localhost:8000/changedata', POSTstr);

//         d = new Date();
//         Module['imgElement'].src =
//         'http://localhost:8000/plotdata?selected_es=' +
//         document.getElementById('numberRangeX').value + "&" + d.getTime();

//     }
// }