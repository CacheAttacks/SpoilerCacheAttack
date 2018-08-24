$.loadScript('javascript/interesting_cache_sets.js', function(){
    //after load script
    Module['interestingCacheSetsGcd'] = listInterestingCacheSets;

//    function intersection(arr1, arr2){
//         arr1.filter(value => -1 !== arr2.indexOf(value));
//     }

    var cache_set_s_mp_div_2 = 39;
    var cache_set_mp_sub = 7;

    var interestingCacheSetsShiftFiltered = Module['interestingCacheSetsShift'].filter(value => -1 == Module['interestingCacheSetsSub'].indexOf(value));
    var interestingCacheSetsSubFiltered = Module['interestingCacheSetsSub'].filter(value => -1 == Module['interestingCacheSetsShift'].indexOf(value));
    //console.log(interestingCacheSetsShiftFiltered);
    //console.log(interestingCacheSetsSubFiltered);

    const reducerShift = (accumulator, currentValue) => accumulator + currentValue + "(" +  Math.floor(currentValue/64) + "," + ((currentValue % 64 == cache_set_s_mp_div_2) ? cache_set_s_mp_div_2 + "(s_mp_div_2)" : currentValue % 64) + ") ";

    //intersection of shift and gcd
    var intersectGcdShift = Module['interestingCacheSetsGcd'].filter(value => -1 !== interestingCacheSetsShiftFiltered.indexOf(value));
    console.log("%cintersectGcdShift: " + intersectGcdShift.reduce(reducerShift, ""), 'color: red');

    const reducerSub = (accumulator, currentValue) => accumulator + currentValue + "(" +  Math.floor(currentValue/64) + "," + ((currentValue % 64 == cache_set_mp_sub) ? cache_set_mp_sub + "(mp_sub)" : currentValue % 64) + ") ";

    //intersection of sub and gcd
    var intersectGcdSub = Module['interestingCacheSetsGcd'].filter(value => -1 !== interestingCacheSetsSubFiltered.indexOf(value));
    console.log("%cintersectGcdSub: " + intersectGcdSub.reduce(reducerSub, ""), 'color: red');
});

