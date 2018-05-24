if (typeof Module['noisy_start_cache_set'] !== 'undefined') {
    //wait for sending on channels 32 and 33
    console.log("listen on " + (Module['noisy_start_cache_set'] + 32)); //+ " and " + (Module['noisy_start_cache_set'] + 32));
    Module['asm']._set_monitored_es(Module['appStatePtr'], Module['noisy_start_cache_set'] + 32, Module['noisy_start_cache_set'] + 32);
    var before = performance.now();
    sampleEsWrapper(300, 0, 1);
    var after = performance.now();
    console.log("time from sample_es: " + (after-before) + "ms");
    bitstr = Module['getxhr']('http://localhost:8000/identifybits');
    console.log(bitstr);
  } else {
    console.log("Module['noisy_start_cache_set'] is undefined! Searched for covert channel?");
  }