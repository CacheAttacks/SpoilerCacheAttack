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
        if(Module['SABFuncPtr'] == null){
            Module['SABFuncPtr'] = addFunction(function() {
                return Module['sharedArrayCounter'][0];
                //return Atomics.load(Module['sharedArrayCounter'], 0);
            });
            console.log(Module['SABFuncPtr']);
        }
        return Module['SABFuncPtr'];
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    SAB_wasmMemory_write_counter_value: function() {
        Module['wasmMemoryArray'][Module['wasmMemoryArrayCounterOffset']] = 
        Module['sharedArrayCounter'][0];
    }
});