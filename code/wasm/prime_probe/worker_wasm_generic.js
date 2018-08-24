self.addEventListener('message', (m) => {
    //const sharedArray = new Uint32Array(m.data)


    importScripts("module.js");
    Module['sharedArrayCounter'] = new Uint32Array(m.data);
    importScripts("c_wrapper_funcs.js");
    importScripts("timer_clock_edge.js");
    importScripts("eviction_set_finder.js");
    //importScripts(".js");
});