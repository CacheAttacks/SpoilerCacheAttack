if (typeof Module['noisy_start_cache_set'] !== 'undefined') {
    var probe_types = { default:0, split2:22, split4:24, split8:28, maxchase1:11, maxchase2:12, maxchase3:13, maxchase4:14, maxchase5:15, maxchase6:16, maxchase7:17, maxchase8:18, maxchase9:19, maxchase10:110, maxchase11:111, maxchase12:112, maxchase13:113, maxchase14:114, maxchase15:115, maxchase16:116};

    Module['asm']._set_monitored_es(Module['appStatePtr'], Module['noisy_start_cache_set'] + COMMUNICATION_CHANNEL_OFFSET_START, Module['noisy_start_cache_set'] + COMMUNICATION_CHANNEL_OFFSET_END);

    for(var type in probe_types){
        //console.log("bench" + type);
        Module['asm']._change_type(Module['appStatePtr'], probe_types[type]);

        sampleEsWrapper(2000000, 0, 0);
        
        var offset = Module['res']/Module['byteFactor'];
        var length = Module['nrow'] * Module['ncol'];
        var subarray = Module['wasmMemoryArr'].slice(offset, offset + length);
        console.log("median:" + median(subarray) + ", mean:" + mean(subarray));
    }
} else {
    console.log("noisy_start_cache_set undefined!");
}

function median(values) {
    values.sort( function(a,b) {return a - b;} );

    var half = Math.floor(values.length/2);

    if(values.length % 2)
        return values[half];
    else
        return (values[half-1] + values[half]) / 2.0;
}

function mean(values) {
    return values.reduce(function(a, b) { return a + b; }) / values.length;
}