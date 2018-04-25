if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    SAB_lib_get_counter_value: function()
    {
        return Module['sharedArrayCounter'][0];
        //return Atomics.load(Module['sharedArrayCounter'], 0);
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    SAB_terminate_counter_sub_worker: function()
    {
        Module['timerWorker'].terminate();
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    SAB_get_resolution_ns: function(samples)
    {
        var nsPerTick = 0;
        for(var i=0; i<samples; i++)
        {
            var start = wait_edge();
            var start_count = Atomics.load(Module['sharedArrayCounter'], 0);
            var end = wait_edge();
            var end_count = Atomics.load(Module['sharedArrayCounter'], 0);
            nsPerTick += (end - start) / (end_count - start_count) ;
        }
        nsPerTick /= samples;
        //convert from ms to ns
        return nsPerTick * 1000 * 1000;
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    SAB_func_ptr_get_counter_value: function() {
        if(Module['SABFuncPtrGetValue'] == null){
            Module['SABFuncPtrGetValue'] = addFunction(function() {
                return Module['sharedArrayCounter'][0];
                //return Atomics.load(Module['sharedArrayCounter'], 0);
            }, "SABFuncPtrGetValue");
            //console.log(Module['SABFuncPtrGetValue']);
        }
        return Module['SABFuncPtrGetValue'];
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    SAB_lib_wasmMemory_init_buffer: function() {
        var size = 1;
        var offset = Module['asm']._wasmMemory_get_buffer(size);
        //console.log("offset:" + offset);

        //c returns address offset, we need int array offset (sizeof(int)==4)
        Module['wasmMemoryArrayCounterOffset'] = offset/4;
        Module['wasmMemoryArray'] = new Uint32Array(Module['wasmMemory'].buffer);

        // for (var i = 0; i < size; i++) {
        // console.log(Module['wasmMemoryArray'][i+offset/4]);
        // Module['wasmMemoryArray'][i+offset/4] = i;
        // }
        // var value = Module['asm']._read_mem(offset);
        // console.log("value:" + value);
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    SAB_lib_wasmMemory_write_counter_value: function() {
        Module['wasmMemoryArray'][Module['wasmMemoryArrayCounterOffset']] = 
        Module['sharedArrayCounter'][0];
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    SAB_func_ptr_write_counter_value: function() {
        if(Module['SABFuncPtrWriteValue'] == null){
            Module['SABFuncPtrWriteValue'] = addFunction(function() {
                Module['wasmMemoryArray'][Module['wasmMemoryArrayCounterOffset']] = 
                Module['sharedArrayCounter'][0];
            }, "SABFuncPtrWriteValue");
        }
        return Module['SABFuncPtrWriteValue'];
    }
});