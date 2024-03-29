// shared array buffer
// test if shared_array_buffer is possible
// https://interactive-examples.mdn.mozilla.net/pages/js/sharedarraybuffer-constructor.html
// disabled by default, enable firefox => about:config =>
// javascript.options.shared_memory;true

function get_worker(){
  //https://stackoverflow.com/questions/9847580/how-to-detect-safari-chrome-ie-firefox-and-opera-browser
  if(!!window.chrome && (!!window.chrome.webstore || !!window.chrome.runtime))
  { 
    //isChrome
    console.log("Chrome detected! Use worker.js");
    return new Worker('javascript/worker.js');
  } 
  else 
  {
      if (typeof InstallTrigger !== 'undefined')
      { 
        /*isFirefox*/ 
        console.log("Firefox detected! Use worker_firefox.js");
      } 
      else 
      {
          console.log("Could not detect browser! Use worker_firefox.js");
      }
      return new Worker('javascript/worker_firefox.js');
  }
}

function shared_array_counter_init(sharedBuffer) {
  // const sharedBuffer = new SharedArrayBuffer(Uint32Array.BYTES_PER_ELEMENT);
  // const sharedArray = new Uint32Array(sharedBuffer);
  const counterWorker = get_worker();
  counterWorker.postMessage(sharedBuffer);
  return counterWorker;
}

function shared_arry_counter_get_value() {
  return Atomics.load(sharedArray, 0);
}

function shared_array_counter_test(fnc) {
  console.log('call shared_array_counter_test');
  const sharedBuffer = new SharedArrayBuffer(Uint32Array.BYTES_PER_ELEMENT);
  const arr = new Uint32Array(sharedBuffer);
  const counter = get_worker();
  counter.postMessage(sharedBuffer);

  // const test = new Worker("test_worker.js");

  setTimeout(function() {
    var before = Atomics.load(arr, 0);
    fnc();
    var after = Atomics.load(arr, 0);
    // console.log("sharedBuffer before: " + before);
    // console.log("sharedBuffer after: " + after);
    var diff = after - before;
    var nsPerTick = get_resolution_shared_array_buffer(arr, 10);
    console.log('sharedBuffer resolution: ' + nsPerTick + ' ns');
    console.log('sharedBuffer diff: ' + diff);
    console.log('sharedBuffer ns: ' + diff * nsPerTick);
  }, 3000)
}

function get_resolution_shared_array_buffer(count_arr, samples) {
  var nsPerTick = 0;
  for (var i = 0; i < samples; i++) {
    var start = wait_edge();
    var start_count = Atomics.load(count_arr, 0);
    var end = wait_edge();
    var end_count = Atomics.load(count_arr, 0);
    nsPerTick += (end - start) / (end_count - start_count);
  }
  nsPerTick /= samples;
  // convert from ms to ns
  return nsPerTick * 1000 * 1000;
}


function shared_test() {
  const worker = get_worker();
  const length = 10;

  // Creating a shared buffer
  const sharedBuffer =
      new SharedArrayBuffer(Uint32Array.BYTES_PER_ELEMENT * length)

  // Creating a data structure on top of that shared memory area
  const sharedArray = new Uint32Array(sharedBuffer)

  // Let's build an array with 10 even numbers
  for (let i = 0; i < length; i++) sharedArray[i] = i && sharedArray[i - 1] + 2

  // Send memory area to our worker
  worker.postMessage(sharedBuffer)

  setTimeout(function() {
    console.log('[MASTER] Change triggered.')
    sharedArray[0] = 1337
    console.log('sharedArray[1] = ' + sharedArray[1]);
  }, 5000)
}

function SAB_wasmMemory_init_buffer() {
  var size = 2;
  var offset = Module['asm']._wasmMemory_get_buffer(size);
  console.log('offset:' + offset);
  Module['wasmMemoryArrayCounterOffset'] = offset;
  Module['wasmMemoryArray'] = new Uint32Array(Module['wasmMemory'].buffer);
  for (var i = 0; i < size; i++) {
    console.log(Module['wasmMemoryArray'][i + offset / 4]);
    Module['wasmMemoryArray'][i + offset / 4] = i;
  }
  var value = Module['asm']._read_mem(offset);
  console.log('value:' + value);
}