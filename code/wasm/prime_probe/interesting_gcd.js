$.loadScript('interesting_cache_sets.js', function(){
    //after load script
    Module['interestingCacheSetsGcd'] = listInterestingCacheSets;

//    function intersection(arr1, arr2){
//         arr1.filter(value => -1 !== arr2.indexOf(value));
//     }


    var interestingCacheSetsShiftFiltered = Module['interestingCacheSetsShift'].filter(value => -1 == Module['interestingCacheSetsSub'].indexOf(value));
    var interestingCacheSetsSubFiltered = Module['interestingCacheSetsSub'].filter(value => -1 == Module['interestingCacheSetsShift'].indexOf(value));
    console.log(interestingCacheSetsShiftFiltered);
    console.log(interestingCacheSetsSubFiltered);


    //intersection of shift and gcd
    var intersectGcdShift = Module['interestingCacheSetsGcd'].filter(value => -1 !== interestingCacheSetsShiftFiltered.indexOf(value));
    console.log("intersectGcdShift: " + intersectGcdShift);

    //intersection of sub and gcd
    var intersectGcdSub = Module['interestingCacheSetsGcd'].filter(value => -1 !== interestingCacheSetsSubFiltered.indexOf(value));
    console.log("intersectGcdSub: " + intersectGcdSub);
});

