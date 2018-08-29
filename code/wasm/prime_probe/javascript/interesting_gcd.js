Module['interestingCacheSetsGcd'] = listInterestingCacheSets;

//    function intersection(arr1, arr2){
//         arr1.filter(value => -1 !== arr2.indexOf(value));
//     }

var cacheSetIndiciesShiftMostEffective = [48, 49, 50, 47, 46, 37];

var cacheSetIndiciesShift = {
  18: 's_mp_clamp_0',
  19: 's_mp_clamp_1',
  20: 's_mp_clamp_2',
  36: 's_mp_rhsd_0',
  37: 's_mp_rhsd_1',
  38: 's_mp_rhsd_2',
  39: 's_mp_div_2_0',
  40: 's_mp_div_2_1',
  46: 's_mp_div_2d_0',
  47: 's_mp_div_2d_1',
  48: 's_mp_div_2d_2',
  49: 's_mp_div_2d_3',
  50: 's_mp_div_2d_1'
};

var cacheSetIndiciesSubMostEffective = [35, 36, 37, 33, 32, 34];

var cacheSetIndiciesSub = {
  7: 'set_mp_sub',
  18: 's_mp_clamp_0',
  19: 's_mp_clamp_1',
  20: 's_mp_clamp_2',
  32: 's_mp_sub_3arg_0',
  33: 's_mp_sub_3arg_1',
  34: 's_mp_sub_3arg_2',
  35: 's_mp_sub_3arg_3',
  36: 's_mp_sub_3arg_4',
  37: 's_mp_sub_3arg_5',
  38: 's_mp_sub_3arg_6',
};

function getCacheSetStr(dict, value, autoSetMonitored, mostEffectiveArr) {
  var str = (value % 64) + '';
  for (var key in dict) {
    if ((value % 64) == key) {
      if (typeof workerId !== 'undefined' && autoSetMonitored && value == mostEffectiveArr[workerId]) {
        setMonitoredEsArrWrapper(value);
      }
      return str + '(' + dict[key] + ')';
    }
  }
  return str;
}

function getCacheSetShiftStr(value, autoSetMonitored) {
  return getCacheSetStr(
      cacheSetIndiciesShift, value, autoSetMonitored,
      cacheSetIndiciesShiftMostEffective);
}

function getCacheSetSubStr(value, autoSetMonitored) {
  return getCacheSetStr(
      cacheSetIndiciesSub, value, autoSetMonitored,
      cacheSetIndiciesSubMostEffective);
}

if (typeof Module['interestingCacheSetsShift'] != 'undefined' &&
    typeof Module['interestingCacheSetsShift'] != 'undefined') {
  var interestingCacheSetsShiftFiltered =
      Module['interestingCacheSetsShift'].filter(
          value => -1 == Module['interestingCacheSetsSub'].indexOf(value));

  // console.log(interestingCacheSetsShiftFiltered);
  // console.log(interestingCacheSetsSubFiltered);

  const reducerShift = (accumulator, currentValue) => accumulator +
      currentValue + '(' + Math.floor(currentValue / 64) + ',' +
      getCacheSetShiftStr(currentValue, true) + ') ';

  // intersection of shift and gcd
  var intersectGcdShift = Module['interestingCacheSetsGcd'].filter(
      value => -1 !== interestingCacheSetsShiftFiltered.indexOf(value));
  consoleLogEx(
      'intersectGcdShift: ' + intersectGcdShift.reduce(reducerShift, ''));

  var interestingCacheSetsSubFiltered =
      Module['interestingCacheSetsSub'].filter(
          value => -1 == Module['interestingCacheSetsShift'].indexOf(value));


  const reducerSub = (accumulator, currentValue) => accumulator + currentValue +
      '(' + Math.floor(currentValue / 64) + ',' +
      getCacheSetSubStr(currentValue, false) + ') ';

  // intersection of sub and gcd
  var intersectGcdSub = Module['interestingCacheSetsGcd'].filter(
      value => -1 !== interestingCacheSetsSubFiltered.indexOf(value));
  consoleLogEx('intersectGcdSub: ' + intersectGcdSub.reduce(reducerSub, ''));
}
