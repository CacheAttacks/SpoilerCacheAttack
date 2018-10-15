sampleEsWrapper =
    function(
        numberOfSamples, slotTime, printToBrowser, transmitWorkerPlotData = 0) {
  // Module['startTimer']();
  Module['asm']._sample_es(
      Module['appStatePtr'], numberOfSamples, slotTime, printToBrowser,
      document.getElementById('selectPrimeprobe').value);

  if (transmitWorkerPlotData) {
    if (Module['byteFactor'] != 0) {
      var POSTstr = Module['createPOSTStr'](
          Module['wasmMemoryArr'], Module['res'] / Module['byteFactor'],
          Module['nrow'], Module['ncol']);
      Module['postxhr']('http://localhost:8000/changedataworker', POSTstr);

      var indexVecStartAdd =
          Module['monitoredEsIndexVecPtr'] / Module['byteFactor'];
      var indexVecSize = Module['monitoredEsIndexVecSize'];
      var indexString = '';
      for (var i = 0; i < indexVecSize; i++) {
        indexString +=
            Module['wasmMemoryArr'][indexVecStartAdd + i].toString() + ',';
      }

      Module['postxhr'](
          'http://localhost:8000/changeindexvecworker', indexString);
    }
  }
  // Module['stopTimer']();
}

primeSpamEsWrapper =
    function(durationSec) {
  // Module['startTimer']();
  Module['asm']._prime_spam_es(Module['appStatePtr'], durationSec);
  // Module['stopTimer']();
}

buildEsWrapper =
    function(max_es, search_method) {
  // Module['startTimer']();
  while (Module['sharedArrayCounter'] < 10000000) {
    if (Module['sharedArrayCounter'] > 0)
      console.log(Module['sharedArrayCounter']);
  }
  console.log('fin');
  Module['asm']._build_es(Module['appStatePtr'], max_es, search_method);
  // Module['stopTimer']();
}

buildEsExWrapper =
    function(max_es, benchmarkmode, benchmarkruns) {
  // Module['startTimer']();
  Module['asm']._build_es_ex(
      Module['appStatePtr'], max_es, benchmarkmode, benchmarkruns);
  // Module['stopTimer']();
}

measureMeanAccessTimeWrapper =
    function(samples) {
  // Module['startTimer']();
  var meanAccessTime =
      Module['asm']._measure_mean_access_time(Module['appStatePtr'], samples);
  // Module['stopTimer']();
  return meanAccessTime;
}


setMonitoredEsArrWrapper = function(listEsArr) {
  // example from
  // https://kapadia.github.io/emscripten/2013/09/13/emscripten-pointers-and-pointers.html

  var listEsInt32Arr = new Int32Array(listEsArr.length);
  for (var i = 0; i < listEsArr.length; i++) {
    listEsInt32Arr[i] = parseInt(listEsArr[i], 10);
  }

  var nDataBytes = listEsInt32Arr.length * listEsInt32Arr.BYTES_PER_ELEMENT;
  var dataPtr = Module._malloc(nDataBytes);

  // Copy data to Emscripten heap (directly accessed from Module.HEAPU8)
  var dataHeap = new Uint8Array(Module.HEAPU8.buffer, dataPtr, nDataBytes);
  dataHeap.set(new Uint8Array(listEsInt32Arr.buffer));

  Module['asm']._set_monitored_es_arr(
      Module['appStatePtr'], dataPtr, listEsArr.length);
  var result = new Int32Array(
      dataHeap.buffer, dataHeap.byteOffset, listEsInt32Arr.length);


  // Module.HEAP32.set(listEsInt32Arr, buf);

  // Module.getValue(buf, 'i32');

  // console.log(listEsInt32Arr);
  // console.log(buf);



  // Module._free(buf);
}