var workerId = -1;
var textColor = 'color: black';
var textBuffer = '';
function consoleLogExNoNewLine(str) {
  textBuffer += str;
  if (str.substr(str.length - 1) == '\n') {
    console.log(
        '%c' + workerId.toString() + ':' +
            textBuffer.substr(0, textBuffer.length - 1),
        textColor);
    textBuffer = '';
  }
}
function consoleLogEx(str) {
  console.log('%c' + workerId.toString() + ':' + str, textColor);
}

function assertAppStatePtr(func) {
  if (Module['appStatePtr'] != 0) {
    func();
  } else {
    consoleLogEx('Module[\'appStatePtr\'] is null!');
  }
}

onmessage = function(m) {
  // const sharedArray = new Uint32Array(m.data)
  var returnMessage = 'Finished';
  var command = m.data[0];
  if (command === 'initWasmAndCounter') {
    var sharedBuffer = m.data[1];
    textColor = m.data[2];
    workerId = m.data[3];

    importScripts('javascript/module.js');
    Module['sharedArrayCounter'] = new Uint32Array(sharedBuffer);
    importScripts('javascript/c_wrapper_funcs.js');
    importScripts('javascript/timer_clock_edge.js');
    importScripts('eviction_set_finder.js');
    // importScripts(".js");
  } else if (command === 'buildEs') {
    var max_es = m.data[1];
    var search_method = m.data[2];
    assertAppStatePtr(function() {
      buildEsWrapper(max_es, search_method);
    });
  } else if (command === 'setMonitoredEsArr') {
    assertAppStatePtr(function() {
      var listEsArr = m.data[1];
      setMonitoredEsArrWrapper(listEsArr);
    });
  } else if (command === 'sampleEs') {
    assertAppStatePtr(function() {
      var numberOfSamples = m.data[1];
      var slotTime = m.data[2];
      var printToBrowser =
          0;  // always 0, cause document obj not exists in worker context
      var primeprobe_js = m.data[3];
      sampleEsWorkerWrapper(numberOfSamples, slotTime, printToBrowser, primeprobe_js);
    });
  } else if (command === 'getIdleTimes') {
    assertAppStatePtr(function() {
      var min_es = m.data[1];
      var max_es = m.data[2];
      var number_of_samples = 1000;
      Module['asm']._get_idle_times(
          Module['appStatePtr'], min_es, max_es, number_of_samples);
    });
    consoleLogEx("got idle times!");
  } else if (command === 'findInterestingCacheSets') {
    assertAppStatePtr(function() {
      importScripts('javascript/interesting_cache_sets.js');
      // TODO
    });
  }  // TODO implement find shift or sub
     // find gcd
     // merge results of both observations, match by timestamps (R)


  else if (command === 'interestingShift') {
    assertAppStatePtr(function() {
      importScripts('javascript/interesting_cache_sets.js');
      Module['interestingCacheSetsShift'] = listInterestingCacheSets;
    });
  } else if (command === 'interestingSub') {
    assertAppStatePtr(function() {
      importScripts('javascript/interesting_cache_sets.js');
      Module['interestingCacheSetsSub'] = listInterestingCacheSets;
    });
  } else if (command === 'interestingGcd') {
    assertAppStatePtr(function() {
      importScripts('javascript/interesting_cache_sets.js');
      importScripts('javascript/interesting_gcd.js');
    });
  } else if (command === 'primeSpam') {
    assertAppStatePtr(function() {
      var duration = m.data[1];
      var option = m.data[2];
      consoleLogEx("primeSpam for " + duration + "sec");
      primeSpamEsWrapper(duration, option);
      consoleLogEx("primeSpam finished");
      returnMessage = 'Finished primeSpam';
    });
  } else if (command === '') {
    assertAppStatePtr(function() {});
  }
  postMessage(returnMessage);
};