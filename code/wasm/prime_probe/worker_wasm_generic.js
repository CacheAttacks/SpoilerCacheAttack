self.addEventListener('message', (m) => {
  // const sharedArray = new Uint32Array(m.data)


  importScripts('javascript/module.js');
  Module['sharedArrayCounter'] = new Uint32Array(m.data);
  importScripts('javascript/c_wrapper_funcs.js');
  importScripts('javascript/timer_clock_edge.js');
  importScripts('eviction_set_finder.js');
  // importScripts(".js");
});