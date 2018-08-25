var textColor = 'color: black';
var textBuffer = "";
function consoleLogExNoNewLine(str) {
  textBuffer += str;
  if(str.substr(str.length - 1) == '\n'){
    console.log('%c' + textBuffer.substr(0, textBuffer.length - 1), textColor);
    textBuffer = "";
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
    importScripts('javascript/module.js');
    Module['sharedArrayCounter'] = new Uint32Array(sharedBuffer);
    importScripts('javascript/c_wrapper_funcs.js');
    importScripts('javascript/timer_clock_edge.js');
    importScripts('eviction_set_finder.js');
    // importScripts(".js");
  } else if (command === 'buildEs') {
    var max_es = m.data[1];
    buildEsWrapper(max_es);
  }
});