var colorVec = { 0: 'color: red', 1: 'color: blue', 2: 'color: DeepPink', 3: 'color: green', 4: 'color: Indigo', 5: 'color: DimGrey', 6: 'color: yellow' };
var workerWasmCounter = 2;
var workerWasmArr = {};

var idWorkerSelected = -1;
var currentMessage;

function getSelctedWorkerWasm() {
    var workerWasmId = document.getElementById('selectWorkerWasm').value.substr(0, 1);
    return workerWasmArr[workerWasmId];
  }

function nextWorkerPostMessage() {
    var currentWorker = workerWasmArr[idWorkerSelected];
    idWorkerSelected++;
    //postMessage and wait for reply from worker (postMessage)
      //cannot start with other workers cause some operations like "build es" have to be serialized
    currentWorker.postMessage(currentMessage);
  }

  function workerWasmOnMessage(m) {
    result = m.data;
    //console.log(result + idWorkerSelected);
    if (result === "Finished") {
      if (idWorkerSelected >= 0) {
        if (idWorkerSelected < workerWasmCounter) {
          nextWorkerPostMessage();
        }
        else{
          idWorkerSelected = -1;
        }
      }
    }
  }

  function workerWasmPostMessageSerial(message) {
    if (checkWorkerWasmAll.checked) {
      //workers are always async, so we need to work with worker messages as "callbacks"
      idWorkerSelected = 0;
      currentMessage = message;
      nextWorkerPostMessage();    
    } else {
      getSelctedWorkerWasm().postMessage(message);
    }
  }

  //for prime spam operation
  function workerWasmPostMessageParallel(workersArr, message) {
      for(var i=0; i<workersArr.length; i++){
        workerWasmArr[workersArr[i]].postMessage(message);
      }
  }

  var selectWorkerWasm = document.getElementById("selectWorkerWasm");
  document.getElementById('checkWorkerWasmAll').checked = true;
  selectWorkerWasm.disabled = true;

    for (var i = 0; i < workerWasmCounter; i++) {
      workerWasmArr[i] = new Worker('worker_wasm_generic.js');
      workerWasmArr[i].postMessage(["initWasmAndCounter", sharedBuffer, colorVec[i], i]);
      //"callback" method if all workers are selected
      workerWasmArr[i].onmessage = workerWasmOnMessage;

      var option = document.createElement("option");
      option.id = i;
      option.text = i + ": " + colorVec[i];
      selectWorkerWasm.add(option);
    }

    document.getElementById('checkWorkerWasmAll').onclick = function () {
      selectWorkerWasm.disabled = !selectWorkerWasm.disabled;
    }

    document.getElementById('btnWorkerWasmBuildEs').onclick = function () {
      workerWasmPostMessageSerial(['buildEs', 0]);
    }

    document.getElementById('btnWorkerWasmSetMonitoredEsArr').onclick = function () {
      var listEsString = document.getElementById('textWorkerWasmListEs').value;
      var listEsArr = listEsString.split(',');
      workerWasmPostMessageSerial(['setMonitoredEsArr', listEsArr]);
    }

    document.getElementById('btnWorkerWasmGetIdleTimes').onclick = function () {
      var min_es = document.getElementById('numberWorkerWasmLowerLimitMonitoredEsInteresting').value;
      var max_es = document.getElementById('numberWorkerWasmUpperLimitMonitoredEsInteresting').value;
      workerWasmPostMessageSerial(['getIdleTimes', min_es, max_es]);
    }


    document.getElementById('btnWorkerWasmInterestingShift').onclick = function () {
      workerWasmPostMessageSerial(['interestingShift']);
    }
    document.getElementById('btnWorkerWasmInterestingSub').onclick = function () {
      workerWasmPostMessageSerial(['interestingSub',]);
    }
    document.getElementById('btnWorkerWasmInterestingGcd').onclick = function () {
      workerWasmPostMessageSerial(['interestingGcd',]);
    }

    document.getElementById('btnWorkerWasmPrimeSpam').onclick = function () {
        var duration = document.getElementById('numberWorkerWasmPrimeSpamDurationSec').value;
        var workerIdsString = document.getElementById('textWorkerWasmPrimeSpamWorkers').value;
        var workerIdsArr = workerIdsString.split(',');
        for(var i=0; i<workerIdsArr.length; i++){
            if(workerIdsArr[i] > workerWasmCounter){
                consoleLogEx("workerID: " + workerIdsArr[i] + " does not exists!");
                return;
            }
        }

        workerWasmPostMessageParallel(workerIdsArr, ['primeSpam',duration]);
    }

    document.getElementById('btnSampleEsMerged').onclick = function () {
      //call sample es for main thread e.g shift
      var numberOfSamples = document.getElementById('numberSamples').value;
      //console.log(numberOfSamples);
      var slotTime = document.getElementById('numberSlotTime').value;
      sampleEsWrapper(numberOfSamples, slotTime, 1);

      //call sample es for webworker e.g. sub
      workerWasmPostMessageSerial(['sampleEs', numberOfSamples, slotTime]);
    }    