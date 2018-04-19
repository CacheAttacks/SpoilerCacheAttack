function calibrate ()
{
    var counter=0, next;
    for(var i=0;i<10;i++)
    {
        next=wait_edge();
        counter+=count_edge();
    }
    next=wait_edge();
    return(wait_edge()-next)/(counter/10.0);
}

function measure(fnc)
{
    var start=wait_edge();
    fnc();
    var count=count_edge();
    return(performance.now()-start)-count*calibrate();
}

function wait_edge()
{
var next,last=performance.now();
while((next=performance.now())==last){}
return next;
}

function count_edge()
{
var last=performance.now(),count=0;
while(performance.now()==last)
    count++;
return count;
}

function bla()
{
    var a = 0;
    for(var i=0; i<10000; i++){
        a+=1;
    }
    return a;

    //console.log(a);
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
  
  async function demo() {
    console.log('Taking a break...');
    await sleep(2000);
    console.log('Two second later');
  }

//shared array buffer
//test if shared_array_buffer is possible
//https://interactive-examples.mdn.mozilla.net/pages/js/sharedarraybuffer-constructor.html
//disabled by default, enable firefox => about:config => javascript.options.shared_memory;true

function shared_array_counter_init(sharedArray)
{
    //const sharedBuffer = new SharedArrayBuffer(Uint32Array.BYTES_PER_ELEMENT);
    //const sharedArray = new Uint32Array(sharedBuffer);
    const counterWorker = new Worker('worker.js');
    counterWorker.postMessage(sharedBuffer);
    return counterWorker;
}

function shared_arry_counter_get_value(){
    return Atomics.load(sharedArray, 0);
}

function shared_array_counter_test(fnc)
{
    console.log("call shared_array_counter_test");
    const sharedBuffer = new SharedArrayBuffer(Uint32Array.BYTES_PER_ELEMENT);
    const arr = new Uint32Array(sharedBuffer);
    const counter = new Worker('worker.js');
    counter.postMessage(sharedBuffer);

    //const test = new Worker("test_worker.js");

    setTimeout(function() {
        var before = Atomics.load(arr, 0);
        fnc();
        var after = Atomics.load(arr, 0);
        //console.log("sharedBuffer before: " + before);
        //console.log("sharedBuffer after: " + after);
        var diff = after - before;
        var nsPerTick = get_resolution_shared_array_buffer(arr, 10);
        console.log("sharedBuffer resolution: " + nsPerTick + " ns");
        console.log("sharedBuffer diff: " + diff);
        console.log("sharedBuffer ns: " + diff*nsPerTick);
    }, 3000)
}

function get_resolution_shared_array_buffer(count_arr, samples)
{
    var nsPerTick = 0;
    for(var i=0; i<samples; i++)
    {
        var start = wait_edge();
        var start_count = Atomics.load(count_arr, 0);
        var end = wait_edge();
        var end_count = Atomics.load(count_arr, 0);
        nsPerTick += (end - start) / (end_count - start_count) ;
    }
    nsPerTick /= samples;
    //convert from ms to ns
    return nsPerTick * 1000 * 1000;
}


function shared_test(){
    const worker = new Worker('worker.js')
    const length = 10;

    // Creating a shared buffer
    const sharedBuffer = new SharedArrayBuffer(Uint32Array.BYTES_PER_ELEMENT * length)

    // Creating a data structure on top of that shared memory area
    const sharedArray = new Uint32Array(sharedBuffer)

    // Let's build an array with 10 even numbers
    for (let i = 0; i < length; i++) sharedArray[i] = i && sharedArray[i - 1] + 2

    // Send memory area to our worker
    worker.postMessage(sharedBuffer)

    setTimeout(function() {
        console.log('[MASTER] Change triggered.')
        sharedArray[0] = 1337
        console.log("sharedArray[1] = " + sharedArray[1]);
    }, 5000)
}