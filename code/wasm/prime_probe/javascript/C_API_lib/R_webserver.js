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
            'http://localhost:8000/plotdata?selected_x=' +
            document.getElementById('numberRangeX').value + '&' + d.getTime();
      }
    }
  });

  if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    transmit_plot_data: function() {
      if (Module['byteFactor'] != 0) {
        var POSTstr = Module['createPOSTStr'](
            Module['wasmMemoryArr'], Module['res'] / Module['byteFactor'],
            Module['nrow'], Module['ncol']);
        Module['postxhr']('http://localhost:8000/changedataworker', POSTstr);

        var indexVecStartAdd =
            Module['monitoredEsIndexVecPtr'] / Module['byteFactor'];
        var indexVecSize = Module['monitoredEsIndexVecSize'];
        var indexString = '';
        for (var i = 0; i < indexVecSize; i++) {
          indexString +=
              Module['wasmMemoryArr'][indexVecStartAdd + i].toString() + ',';
        }

        Module['postxhr']('http://localhost:8000/changeindexvecworker', indexString);
      }
    }
  });

  if (typeof mergeInto !== 'undefined')
  mergeInto(LibraryManager.library, {
    transmit_plot_data_worker: function() {
      if (Module['byteFactor'] != 0) {
        var POSTstr = Module['createPOSTStr'](
            Module['wasmMemoryArr'], Module['res'] / Module['byteFactor'],
            Module['nrow'], Module['ncol']);
        Module['postxhr']('http://localhost:8000/changedataworker', POSTstr);

        var indexVecStartAdd =
            Module['monitoredEsIndexVecPtr'] / Module['byteFactor'];
        var indexVecSize = Module['monitoredEsIndexVecSize'];
        var indexString = '';
        for (var i = 0; i < indexVecSize; i++) {
          indexString +=
              Module['wasmMemoryArr'][indexVecStartAdd + i].toString() + ',';
        }

        Module['postxhr']('http://localhost:8000/changeindexvecworker', indexString);
      }
    }
  });