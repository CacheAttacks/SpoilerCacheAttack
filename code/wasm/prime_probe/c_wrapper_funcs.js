sampleEsWrapper = function(numberOfSamples, slotTime, printToBrowser){
    Module['startTimer']();
    Module['asm']._sample_es(Module['appStatePtr'], numberOfSamples, slotTime, printToBrowser, document.getElementById('selectPrimeprobe').value);
    Module['stopTimer']();
  }

primeSpamEsWrapper = function(durationSec){
    Module['startTimer']();
    Module['asm']._prime_spam_es(Module['appStatePtr'], durationSec);
    Module['stopTimer']();
}

buildEsWrapper = function(max_es){
    Module['startTimer']();
    while(Module['sharedArrayCounter'] < 10000000)
    {
        if(Module['sharedArrayCounter'] > 0)
        console.log(Module['sharedArrayCounter']);
    }
    console.log("fin");
    Module['asm']._build_es(Module['appStatePtr'], max_es);
    Module['stopTimer']();
}

buildEsExWrapper = function(max_es, benchmarkmode, benchmarkruns){
    Module['startTimer']();
    Module['asm']._build_es_ex(Module['appStatePtr'], max_es, benchmarkmode, benchmarkruns);
    Module['stopTimer']();
}

measureMeanAccessTimeWrapper = function(samples){
    Module['startTimer']();
    var meanAccessTime = Module['asm']._measure_mean_access_time(Module['appStatePtr'], samples);
    Module['stopTimer']();
    return meanAccessTime;
}

