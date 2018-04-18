self.addEventListener('message', (m) => {
    // Create an Int32Array on top of that shared memory area
    var i32 = new Uint32Array(m.data['wasmMemory'].buffer);
    var offset = m.data['offset'];
    var real_counter_offset = offset/4;

    while(1){
        i32[real_counter_offset]++;
    }
});
