if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    printf_ex_js: function(cStringPtr) {
      consoleLogExNoNewLine(Pointer_stringify(cStringPtr));
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    SAB_lib_get_counter_value: function() {
      // return Module['sharedArrayCounter'][0];
      // far more consistent
      return Atomics.load(Module['sharedArrayCounter'], 0);
    }
  });


  if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    read_mem_ptr: function(ptr) {
      //console.log(ptr);
      var myarr = new Uint32Array(Module['wasmMemory'].buffer);
      return myarr[ptr/4];
    }
  });


if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    SAB_terminate_counter_sub_worker: function() {
      Module['stopTimer']();
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    Performance_now: function() {
      return performance.now();
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    SAB_get_resolution_ns: function(samples) {
      var nsPerTick = 0;
      for (var i = 0; i < samples; i++) {
        var start = wait_edge();
        var start_count = Atomics.load(Module['sharedArrayCounter'], 0);
        var end = wait_edge();
        var end_count = Atomics.load(Module['sharedArrayCounter'], 0);
        if (end_count - start_count == 0) {
          break;
        }
        nsPerTick += (end - start) / (end_count - start_count);
        // console.log(start_count + " " + end_count);
      }
      nsPerTick /= samples;
      // convert from ms to ns
      return nsPerTick * 1000 * 1000;
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    SAB_func_ptr_get_counter_value: function() {
      if (Module['SABFuncPtrGetValue'] == null) {
        Module['SABFuncPtrGetValue'] = addFunction(function() {
          return Module['sharedArrayCounter'][0];
          // return Atomics.load(Module['sharedArrayCounter'], 0);
        }, 'SABFuncPtrGetValue');
        // console.log(Module['SABFuncPtrGetValue']);
      }
      return Module['SABFuncPtrGetValue'];
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    SAB_lib_wasmMemory_init_buffer: function() {
      var size = 1;
      var offset = Module['asm']._wasmMemory_get_buffer(size);
      // console.log("offset:" + offset);

      // c returns address offset, we need int array offset (sizeof(int)==4)
      Module['wasmMemoryArrayCounterOffset'] = offset / 4;
      Module['wasmMemoryArray'] = new Uint32Array(Module['wasmMemory'].buffer);

      // for (var i = 0; i < size; i++) {
      // console.log(Module['wasmMemoryArray'][i+offset/4]);
      // Module['wasmMemoryArray'][i+offset/4] = i;
      // }
      // var value = Module['asm']._read_mem(offset);
      // console.log("value:" + value);
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    SAB_lib_wasmMemory_write_counter_value: function() {
      Module['wasmMemoryArray'][Module['wasmMemoryArrayCounterOffset']] =
          Module['sharedArrayCounter'][0];
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    SAB_func_ptr_write_counter_value: function() {
      if (Module['SABFuncPtrWriteValue'] == null) {
        Module['SABFuncPtrWriteValue'] = addFunction(function() {
          Module['wasmMemoryArray'][Module['wasmMemoryArrayCounterOffset']] =
              Module['sharedArrayCounter'][0];
        }, 'SABFuncPtrWriteValue');
      }
      return Module['SABFuncPtrWriteValue'];
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    set_ptr_to_data: function(ptr, nrow, ncol, type) {
      Module['res'] = ptr;
      Module['nrow'] = nrow;
      Module['ncol'] = ncol;
      if (type == 0) {  //"UInt16"
        Module['byteFactor'] = 2;
        Module['wasmMemoryArr'] = new Uint16Array(Module['wasmMemory'].buffer);
      } else if (type == 1) {  //"UInt32"
        Module['byteFactor'] = 4;
        Module['wasmMemoryArr'] = new Uint32Array(Module['wasmMemory'].buffer);
      } else {
        console.log('type: ' + type + ' not supported. Set byteFactor = 4');
        Module['byteFactor'] = 4;
        Module['wasmMemoryArr'] = new Uint32Array(Module['wasmMemory'].buffer);
      }
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    print_plot_data: function() {
      if (Module['byteFactor'] != 0) {
        var POSTstr = Module['createPOSTStr'](
            Module['wasmMemoryArr'], Module['res'] / Module['byteFactor'],
            Module['nrow'], Module['ncol']);
        Module['postxhr']('http://localhost:8000/changedata', POSTstr);

        var indexVecStartAdd =
            Module['monitoredEsIndexVecPtr'] / Module['byteFactor'];
        var indexVecSize = Module['monitoredEsIndexVecSize'];
        var indexString = '';
        for (var i = 0; i < indexVecSize; i++) {
          indexString +=
              Module['wasmMemoryArr'][indexVecStartAdd + i].toString() + ',';
        }

        Module['postxhr']('http://localhost:8000/changeindexvec', indexString);

        d = new Date();
        Module['imgElement'].src =
            'http://localhost:8000/plotdata?selected_es=' +
            document.getElementById('numberRangeEs').value + '&' + d.getTime();
      }
    }
  });


if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    set_app_state_ptr: function(ptr) {
      Module['appStatePtr'] = ptr;
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    set_idle_times_ptr: function(ptr, byteFactor) {
      Module['idleTimesPtr'] = ptr;
      Module['timesArrayByteFactor'] = byteFactor;
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    set_number_of_observed_cache_sets: function(
        number_of_observed_cache_setsptr) {
      Module['numberOfObservedCacheSets'] = number_of_observed_cache_setsptr;
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    set_current_times_ptr: function(ptr) {
      Module['currentTimesPtr'] = ptr;
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    set_monitored_es_index_vec_ptr: function(ptr, size) {
      Module['monitoredEsIndexVecPtr'] = ptr;
      Module['monitoredEsIndexVecSize'] = size;
    }
  });

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {dummy_for_wat: function() {}});

// int probetime(void *pp) {
//     if (pp == NULL)
//       return 0;
//     int rv = 0;
//     void *p = (void *)pp;
//     uint32_t s = rdtscp();
//     do {
//       p = LNEXT(p);
//     } while (p != (void *) pp);
//     return rdtscp()-s;
//   }

if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    // accepts direct wasm c pointers
    js_repeatedprobe: function(
        uint8ptrMonitorhead, uint8ptrBmonitorhead, nrecords, uint8ptrResults) {
      Module['jsrepeatedprobe'] = {
        uint8ptrMonitorhead: uint8ptrMonitorhead,
        uint8ptrBmonitorhead: uint8ptrBmonitorhead,
        nrecords: nrecords,
        uint8ptrResults: uint8ptrResults
      };

      $.loadScriptSync('javascript/primeprobe.js', function() {});
    }
  });



// cycles through all memory-blocks in a eviction-set
// access them and count accesses with (accesstime > L3_THRESHOLD)
// int l3_repeatedprobe(l3pp_t l3, int nrecords, RES_TYPE *results, int slot,
// int type) {
//     assert(l3 != NULL);
//     assert(results != NULL);

//     if (nrecords == 0)
//       return 0;

//     int len = l3->nmonitored;
//     int (*probetime)(void* pp) = get_probetime_by_type(type);

//     int even = 1;
//     int missed = 0;
//     uint64_t prev_time = rdtscp64();
//     for (int i = 0; i < nrecords; i++, results+=len) {
//       if (missed) {
//         for (int j = 0; j < len; j++)
//             results[j] = 0;
//       } else {
//         if (even)
//             l3_probe(l3, results, probetime);
//         else
//             l3_bprobe(l3, results, probetime);
//         even = !even;
//       }
//       if (slot > 0) {
//         prev_time += slot;
//         missed = slotwait(prev_time);
//       }
//     }
//     return nrecords;
//   }