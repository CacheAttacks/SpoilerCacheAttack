  (func $f26 (type $t1) (param $p0 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32) (local $l13 i32) (local $l14 i32) (local $l15 i32) (local $l16 i32) (local $l17 i32) (local $l18 i32) (local $l19 i32) (local $l20 i32) (local $l21 i32) (local $l22 i32) (local $l23 i32) (local $l24 i32) (local $l25 i32) (local $l26 i32) (local $l27 i32) (local $l28 i32) (local $l29 i32)
    (set_local $l29
      (get_global $g12))
    (set_global $g12
      (i32.add
        (get_global $g12)
        (i32.const 64)))
    (if $I0
      (i32.ge_s
        (get_global $g12)
        (get_global $g13))
      (then
        (call $env.abortStackOverflow
          (i32.const 64))))
    (set_local $l27
      (i32.add
        (get_local $l29)
        (i32.const 24)))
    (set_local $l26
      (i32.add
        (get_local $l29)
        (i32.const 16)))
    (set_local $l25
      (i32.add
        (get_local $l29)
        (i32.const 8)))
    (set_local $l24
      (get_local $l29))
    (set_local $l0
      (get_local $p0))
    (call $f28)
    (set_local $l21
      (call $env._SAB_lib_get_counter_value))
    (set_local $l11
      (get_local $l21))
    (set_local $l22
      (call $env._SAB_lib_get_counter_value))
    (set_local $l17
      (get_local $l22))
    (set_local $l23
      (call $env._SAB_lib_get_counter_value))
    (set_local $l18
      (get_local $l23))
    (set_local $l1
      (get_local $l17))
    (set_local $l2
      (get_local $l11))
    (set_local $l3
      (i32.sub
        (get_local $l1)
        (get_local $l2)))
    (set_local $l19
      (get_local $l3))
    (set_local $l4
      (get_local $l18))
    (set_local $l5
      (get_local $l17))
    (set_local $l6
      (i32.sub
        (get_local $l4)
        (get_local $l5)))
    (set_local $l20
      (get_local $l6))
    (set_local $l7
      (get_local $l19))
    (i32.store
      (get_local $l24)
      (get_local $l7))
    (drop
      (call $f80
        (i32.const 1440)
        (get_local $l24)))
    (set_local $l8
      (get_local $l20))
    (i32.store
      (get_local $l25)
      (get_local $l8))
    (drop
      (call $f80
        (i32.const 1448)
        (get_local $l25)))
    (set_local $l9
      (get_local $l19))
    (set_local $l10
      (get_local $l20))
    (set_local $l12
      (i32.sub
        (get_local $l9)
        (get_local $l10)))
    (set_local $l13
      (i32.gt_s
        (get_local $l12)
        (i32.const 10)))
    (if $I1
      (get_local $l13)
      (then
        (drop
          (call $f80
            (i32.const 1455)
            (get_local $l26)))
        (set_local $l14
          (get_local $l17))
        (set_local $l15
          (get_local $l11))
        (set_local $l16
          (i32.sub
            (get_local $l14)
            (get_local $l15)))
        (set_global $g12
          (get_local $l29))
        (return
          (get_local $l16)))
      (else
        (drop
          (call $f80
            (i32.const 1472)
            (get_local $l27)))
        (set_local $l14
          (get_local $l17))
        (set_local $l15
          (get_local $l11))
        (set_local $l16
          (i32.sub
            (get_local $l14)
            (get_local $l15)))
        (set_global $g12
          (get_local $l29))
        (return
          (get_local $l16))))
    (unreachable)
    (return
      (i32.const 0)))