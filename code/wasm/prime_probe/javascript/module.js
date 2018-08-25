var Module = {
  postxhr: function(url, data) {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.send(JSON.stringify({newdata: data}));
  },
  getxhr: function(url) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, false);
    xhr.send(null);
    return JSON.parse(xhr.responseText);
  },
  createPOSTStr: function(arr, arr_offset, nrow, ncol) {
    var POSTstr = '';
    if (nrow * ncol > 2000000) {
      console.log('arr to big!');
      return '';
    }
    for (var i = 0; i < nrow; i++) {
      for (var j = 0; j < ncol; j++) {
        POSTstr += arr[++arr_offset].toString() + ' ';
      }
      POSTstr += '\n';
    }
    return POSTstr;
  },
  preRun: function() {},
  postRun: function() {},
  onExit: function(status) {
    console.log('onExit\n');
  },
  totalDependencies: 0
};