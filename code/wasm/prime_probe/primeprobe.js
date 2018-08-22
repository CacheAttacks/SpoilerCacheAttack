var uint8ptrMonitorhead = Module['jsrepeatedprobe']['uint8ptrMonitorhead'];
var uint8ptrBmonitorhead = Module['jsrepeatedprobe']['uint8ptrBmonitorhead'];
var nrecords = Module['jsrepeatedprobe']['nrecords'];
var uint8ptrResults = Module['jsrepeatedprobe']['uint8ptrResults'];

        // var t1;
        // for(var i=1; i<nrecords*2; i++){
        //     t1 += Module['sharedArrayCounter'][0]; 
        // }
        // return t1;
//is faster than "inline" this code into for loop
function JSprobeTime(uint32Arr, uint8ptr){
    var old_ptr = uint8ptr;
    var t1 = Module['sharedArrayCounter'][0];
    //var t1 = Atomics.load(Module['sharedArrayCounter'], 0);   
    do{
        uint8ptr = uint32Arr[uint8ptr / 4];            
    } while(uint8ptr != old_ptr);
    return Module['sharedArrayCounter'][0] - t1;
    //return Atomics.load(Module['sharedArrayCounter'], 0) - t1;
}

var uint32wasmMemory = new Uint32Array(Module['wasmMemory'].buffer);
var uint16wasmMemory = new Uint16Array(Module['wasmMemory'].buffer);
var uint8wasmMemory = new Uint8Array(Module['wasmMemory'].buffer);

var uint16ptrResults = uint8ptrResults / 2; //cause we index uint16 array
// var uint32ptrMonitorhead = uint8ptrMonitorhead / 4;
// var uint32ptrBmonitorhead = uint8ptrBmonitorhead / 4;
// console.log("uint8ptrMonitorhead:"+uint8ptrMonitorhead.toString(16));
// console.log("*uint8ptrMonitorhead:"+uint32wasmMemory[uint32ptrMonitorhead].toString(16));
// console.log("uint8ptrBmonitorhead:"+uint8ptrBmonitorhead.toString(16));
// console.log("*uint8ptrBmonitorhead:"+uint32wasmMemory[uint32ptrBmonitorhead].toString(16));

//var localuint16 = new Uint16Array(nrecords);

var even = true;
for (var bound = uint16ptrResults + nrecords; uint16ptrResults < bound;){
    if (even){
        uint16wasmMemory[++uint16ptrResults] = JSprobeTime(uint32wasmMemory, uint8ptrMonitorhead);
        //localuint16[i] = JSprobeTime(uint32wasmMemory, uint8ptrMonitorhead);
    }
    else{
        uint16wasmMemory[++uint16ptrResults] = JSprobeTime(uint32wasmMemory, uint8ptrBmonitorhead);
        //localuint16[i] = JSprobeTime(uint32wasmMemory, uint8ptrBmonitorhead);
    }
    even = !even;
}