function makeAlert(text) {
    alert(text);
}

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    testExternalJSMethod: function() {
        return 1;
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    shared_array_counter_add_value: function()
    {
        Atomics.add(sharedArray, 1, 10);
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    shared_array_counter_get_value: function()
    {
        //return Module['sharedArrayCounter'][0];
        return Atomics.load(Module['sharedArrayCounter'], 0);
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    terminate_counter_sub_worker: function()
    {
        Module['timerWorker'].terminate();
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    get_resolution_shared_array_buffer_ns: function(samples)
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

