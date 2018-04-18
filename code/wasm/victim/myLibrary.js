function makeAlert(text) {
    alert(text);
}

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    testExternalJSMethod: function() {
        return 1;
    }
});

var sharedArray;
var workerCounter;

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    shared_array_counter_init: function()
    {
        console.log("start shared array counter\n");
        const sharedBuffer = new SharedArrayBuffer(Uint32Array.BYTES_PER_ELEMENT*2);
        sharedArray = new Uint32Array(sharedBuffer);
        sharedArray[1] = 42;
        workerCounter = new Worker('worker.js');
        workerCounter.postMessage(sharedBuffer);

        while(1){
            if(Atomics.load(sharedArray, 0) > 0){
                console.log(Atomics.load(sharedArray, 0));
                break;
            }
        }

        var a;
        setTimeout(function() {
            var before = Atomics.load(sharedArray, 0);
            for(var i=0; i<10000; i++)
            {
                a+=3;
            }
            var after = Atomics.load(sharedArray, 0);
            var diff = after - before;
            var nsPerTick = get_resolution_shared_array_buffer(sharedArray, 10);
            console.log("sharedBuffer resolution: " + nsPerTick + " ns");
            console.log("sharedBuffer diff: " + diff);
            console.log("sharedBuffer ns: " + diff*nsPerTick);
        }, 3000)
        return a;
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    shared_array_counter_add_value: function()
    {
        Atomics.add(sharedArray, 0, 10);
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    shared_array_counter_get_value: function()
    {
        var val = Atomics.load(sharedArray, 0);
        console.log(val);
        return val;
    }
});
