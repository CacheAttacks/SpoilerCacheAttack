// code for covert_channel detection, loaded dynamically for online changes

// first: scan all cache-super-sets but only the lower 32 sets
Module['asm']._set_monitored_es_lower_half(Module['appStatePtr']);
sampleEsWrapper(50, 0, 1);
// mutiply by 2 to get index for all sets
// var POSTstr = Module['createPOSTStr'](Module['wasmMemoryArr'],
// Module['res']/Module['byteFactor'], Module['nrow'], Module['ncol']);
console.log(Module['getxhr']('http://localhost:8000/findnoisycacheset'));
noisy_start_cache_set =
    2 * (Module['getxhr']('http://localhost:8000/findnoisycacheset'));
console.log('possible noisy_start_cache_set:' + noisy_start_cache_set);

// get idle noise values
Module['asm']._set_monitored_es(
    Module['appStatePtr'],
    (noisy_start_cache_set - 64 + NOISY_CHANNEL_OFFSET_SEND_START) %
        Module['ncol'],
    (noisy_start_cache_set - 64 + NOISY_CHANNEL_OFFSET_SEND_END) %
        Module['ncol']);
Module['idle_noise_mean'] = measureMeanAccessTimeWrapper(2000);

// get avg noise level of assumed channel cache sets
Module['asm']._set_monitored_es(
    Module['appStatePtr'],
    noisy_start_cache_set + NOISY_CHANNEL_OFFSET_SEND_START,
    noisy_start_cache_set + NOISY_CHANNEL_OFFSET_SEND_END);
var access_time = measureMeanAccessTimeWrapper(2000);
console.log(
    'idle_noise_mean:' + Module['idle_noise_mean'] +
    ', access_time:' + access_time);

if (access_time > 2 * Module['idle_noise_mean']) {
  // noise the higher 30 sets of the detected cache-super-set
  // make noise for more than 1 sec => server switches between listening and
  // sending every sec
  console.log(
      'noise on set ' +
      (noisy_start_cache_set + NOISY_CHANNEL_OFFSET_REC_START) + ' to ' +
      (noisy_start_cache_set + NOISY_CHANNEL_OFFSET_REC_END));
  Module['asm']._set_monitored_es(
      Module['appStatePtr'],
      noisy_start_cache_set + NOISY_CHANNEL_OFFSET_REC_START,
      noisy_start_cache_set + NOISY_CHANNEL_OFFSET_REC_END);
  var before = performance.now();
  sampleEsWrapper(200000, 0, 0);
  var after = performance.now();
  console.log('time for sample :' + (after - before));

  console.log(
      'noisy_start_cache_set:' + noisy_start_cache_set + ' seems valid');
  Module['noisy_start_cache_set'] = noisy_start_cache_set;
  new Promise(resolve => setTimeout(resolve, 1000));
  console.log('search for covert channel successfully finished');
} else {
  console.log('search for covert channel failed');
}