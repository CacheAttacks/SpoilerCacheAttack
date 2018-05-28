if (typeof Module['noisy_start_cache_set'] !== 'undefined') {
    //wait for sending on channels 32 and 33
    console.log("listen on " + (Module['noisy_start_cache_set'] + 32)); //+ " and " + (Module['noisy_start_cache_set'] + 32));
    Module['asm']._set_monitored_es(Module['appStatePtr'], Module['noisy_start_cache_set'] + 32, Module['noisy_start_cache_set'] + 32);
    var before = performance.now();
    sampleEsWrapper(20000, 0, 0);
    
    var POSTstr = Module['createPOSTStr'](Module['wasmMemoryArr'], Module['res']/Module['byteFactor'], Module['nrow'], Module['ncol']);
    Module['postxhr']('http://localhost:8000/changedata', POSTstr);

    d = new Date();
    Module['imgElement'].src = 'http://localhost:8000/plotchannel' + "?" + d.getTime();

    var after = performance.now();
    console.log("time from sample_es: " + (after-before) + "ms");
    bitstr = Module['getxhr']('http://localhost:8000/identifybits');
    console.log(bitstr);
  } else {
    console.log("Module['noisy_start_cache_set'] is undefined! Searched for covert channel?");
  }