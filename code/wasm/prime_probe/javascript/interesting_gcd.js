Module['interestingCacheSetsGcd'] = listInterestingCacheSets;

//    function intersection(arr1, arr2){
//         arr1.filter(value => -1 !== arr2.indexOf(value));
//     }

var cacheSetIndiciesShiftMostEffective = [48, 49, 50, 47, 46, 37];

//ref 340,477, 424K
var cacheSetIndiciesShift = {
  32: 's_mp_clamp_0', //s_mp_clamp>: 541,608,549k
  33: 's_mp_clamp_1', //538,605,553k
  //42: 's_mp_rshd_0', //s_mp_rshd>:   522,560,576k
  45: 's_mp_rshd_0', //450,514,479k  468,501,475k
  46: 's_mp_rshd_1', //451,542,486k 474,492,476k
  47: 's_mp_rshd_2', //486,563,581k  501,640,560k b508,555,541k
  48: 's_mp_rshd_3', //520,571,597k  500,536,548k, 509,543,562k
  49: 's_mp_div_2_0', //480,503,474k  468,491,479k 469,493,482k
  56: 's_mp_div_2d_0', //s_mp_div_2d>: 511,560, 544k  526,564,542k
  57: 's_mp_div_2d_1', //503,549, 536k
  58: 's_mp_div_2d_2', //539,557,551k
  59: 's_mp_div_2d_3', //537,547,552k 536,551,557k
  60: 's_mp_div_2d_4' //470,506,485 458,503,489k
};

var cacheSetIndiciesSubMostEffective = [35, 36, 37, 33, 32, 34];

var cacheSetIndiciesSub = {
  //7: 'set_mp_sub',
  17: 'mp_sub_0',//<mp_sub>: //357,643,487k
  18: 'mp_sub_1', //359,684,538k
  19: 'mp_sub_2', //362,681,531k
  20: 'mp_sub_3', //357,700,538k
  21: 'mp_sub_4', //362, 683, 534k
  22: 'mp_sub_5', //358,732,534k
  23: 'mp_sub_6', //359,766,541k
  32: 's_mp_clamp_0',
  33: 's_mp_clamp_1',
  41: 's_mp_sub_3arg_0',//s_mp_sub_3arg>: 357,643,490k
  42: 's_mp_sub_3arg_1', //359,644,494k
  43: 's_mp_sub_3arg_2', //357,675,534k
  44: 's_mp_sub_3arg_3', //358,669,536k
  45: 's_mp_sub_3arg_4', //357,663,533k
  46: 's_mp_sub_3arg_5', //359,676,546k
  47: 's_mp_sub_3arg_6', //356,663, 535k
  48: 's_mp_sub_3arg_7' //352,571,483k
};

//2048 = 340,477, 424K
//4096 = 577,718, 1,2M
//8192 = 959,1223 3,73M

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
