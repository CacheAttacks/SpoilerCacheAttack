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
        return Atomics.load(Module['sharedArrayCounter'], 0);
    }
});

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    terminate_counter_sub_worker: function()
    {
        Module['timerWorker'].terminate();
    }
});
