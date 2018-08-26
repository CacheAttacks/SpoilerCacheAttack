var id = -1;
var textColor = 'color: black';
var textBuffer = '';
function consoleLogExNoNewLine(str) {
  textBuffer += str;
  if (str.substr(str.length - 1) == '\n') {
    console.log(
        '%c' + id.toString() + ':' +
            textBuffer.substr(0, textBuffer.length - 1),
        textColor);
    textBuffer = '';
  }
}
function consoleLogEx(str) {
  console.log('%c' + str, textColor);
}



self.addEventListener('message', (m) => {
  // const sharedArray = new Uint32Array(m.data)
  var command = m.data[0];
  if (command === 'initWasmAndCounter') {
    var sharedBuffer = m.data[1];
    textColor = m.data[2];
    id = m.data[3];

    importScripts('javascript/module.js');
    Module['sharedArrayCounter'] = new Uint32Array(sharedBuffer);
    importScripts('javascript/c_wrapper_funcs.js');
    importScripts('javascript/timer_clock_edge.js');
    importScripts('eviction_set_finder.js');
    // importScripts(".js");
  } else if (command === 'buildEs') {
    var max_es = m.data[1];
    buildEsWrapper(max_es);
  } else if (command === 'setMonitoredEsArr') {
    if (Module['appStatePtr'] != 0) {
      var listEsInt32Arr = m.data[1];
      importScripts('set_monitor_es_arr.js');
    } else {
      consoleLogEx('Module[\'appStatePtr\'] is null!');
    }
  } else if (command === 'sampleEs') {
    if (Module['appStatePtr'] != 0) {
      var numberOfSamples = m.data[1];
      var slotTime = m.data[2];
      var printToBrowser =
          0;  // always 0, cause document obj not exists in worker context
      sampleEsWrapper(numberOfSamples, slotTime, printToBrowser);
    } else {
      consoleLogEx('Module[\'appStatePtr\'] is null!');
    }
  } else if (command === 'getIdleTimes') {
    if (Module['appStatePtr'] != 0) {
      var min_es = m.data[1];
      var max_es = m.data[2];
      var number_of_samples = 1000;
      Module['asm']._get_idle_times(
          Module['appStatePtr'], min_es, max_es, number_of_samples);
    } else {
      consoleLogEx('Module[\'appStatePtr\'] is null!');
    }
  } else if (command === 'findInterestingCacheSets') {
    if (Module['appStatePtr'] != 0) {
      importScripts('interesting_cache_sets.js');
      //TODO
    } else {
      consoleLogEx('Module[\'appStatePtr\'] is null!');
    }
  } //TODO implement find shift or sub
    //find gcd
    //merge results of both observations, match by timestamps (R)
  
  else if (command === '') {
    if (Module['appStatePtr'] != 0) {
    } else {
      consoleLogEx('Module[\'appStatePtr\'] is null!');
    }
  }
});