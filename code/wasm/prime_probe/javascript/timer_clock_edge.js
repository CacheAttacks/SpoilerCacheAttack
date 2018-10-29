//Code from Fantastic Timers and Where to Find Them:High-Resolution Microarchitectural Attacks in JavaScript.

function calibrate() {
  var counter = 0, next;
  for (var i = 0; i < 10; i++) {
    next = wait_edge();
    counter += count_edge();
  }
  next = wait_edge();
  return (wait_edge() - next) / (counter / 10.0);
}

function measure(fnc) {
  var start = wait_edge();
  fnc();
  var count = count_edge();
  return (performance.now() - start) - count * calibrate();
}

function wait_edge() {
  var next, last = performance.now();
  while ((next = performance.now()) == last) {
  }
  return next;
}

function count_edge() {
  var last = performance.now(), count = 0;
  while (performance.now() == last) count++;
  return count;
}

function bla() {
  var a = 0;
  for (var i = 0; i < 10000; i++) {
    a += 1;
  }
  return a;

  // console.log(a);
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function demo() {
  console.log('Taking a break...');
  await sleep(2000);
  console.log('Two second later');
}