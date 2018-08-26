// decode listEs string
var listEsString = document.getElementById('textListEs').value;
var listEsArr = listEsString.split(',');

// example from
// https://kapadia.github.io/emscripten/2013/09/13/emscripten-pointers-and-pointers.html

var listEsInt32Arr = new Int32Array(listEsArr.length);
for (var i = 0; i < listEsArr.length; i++) {
  listEsInt32Arr[i] = parseInt(listEsArr[i], 10);
}

var dataPtr = Module._malloc(nDataBytes);
var nDataBytes = listEsInt32Arr.length * listEsInt32Arr.BYTES_PER_ELEMENT;

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
