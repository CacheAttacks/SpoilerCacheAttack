if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    store_for_js: function(uint8ptrBuffer, bufferSize, uint8ptrAddressArr, addressArrSize, uint8ptrCandidate, threadholdSearchForEs, windowSize, rounds, appStatePtr) {
      var startTime = Module['sharedArrayCounter'][0];

      var pageSize = 4096;
      var pageCount = bufferSize / pageSize;
      var movingWindowSize = 10;

      var uint32wasmMem = new Uint32Array(Module['wasmMemory'].buffer);
      var uint32ptrBuffer = uint8ptrBuffer / 4;
      var uint16MeasurementArr = new Uint16Array(pageCount);
      var uint32ptrAdressArr = uint8ptrAddressArr / 4;
      var uint32ptrCandidate = uint8ptrCandidate / 4;
      var lock = 0;
      var numberOfStoreForAdd = 0;

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
           //output += "? " + MeasurementArr[p];
          return true;
        }
        //output += " " + MeasurementArr[p];
        return false;
      }

      console.log("iterate through " + pageCount + " pages...");
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
          //this seems to work quite well, but there should exist better stuff
          val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;
          val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;val++;
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
          var uint8ptrStoreForAdd = (uint8ptrBuffer + (p-1) * pageSize);
          uint32wasmMem[uint32ptrAdressArr + numberOfStoreForAdd] = uint8ptrStoreForAdd;
          numberOfStoreForAdd++;

          if(numberOfStoreForAdd >= threadholdSearchForEs){ //try to create es
            if(Module['asm']._try_to_create_es(uint8ptrAddressArr, numberOfStoreForAdd, startTime, Module['sharedArrayCounter'][0], appStatePtr) != 0){
              //console.log(output);
              return true;
            }
            startTime = Module['sharedArrayCounter'][0];
          }
          //size of AddressArr is limited
          if(numberOfStoreForAdd == addressArrSize){
            console.error("_try_to_create_es failed");
            return false;
          }
          //do not detect colliding addresses for the next 10 blocks
          lock = 10;
        } else {
          //output += " " + uint16MeasurementArr[p];
        }
        lock--;
      }
      console.warn("Buffer exceeded and only numberOfStoreForAdd:" + numberOfStoreForAdd + " found! (need threadholdSearchForEs:" + threadholdSearchForEs + ")");
      console.info("Try to increase STOREFOR_PAGE_COUNT (config.h)");
      return false;
    }
  });