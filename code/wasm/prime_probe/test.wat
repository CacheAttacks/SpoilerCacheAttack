(func $f44 (type $t2) (param $p0 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32)
    (set_local $l0
      (call $env._SAB_lib_get_counter_value))
    (i32.load
        (get_local $p0))
    (set_local $l1
      (call $env._SAB_lib_get_counter_value))
    (i32.load
        (get_local $p0))
    (set_local $l2
      (call $env._SAB_lib_get_counter_value))
    (set_local $l3
      (i32.sub
        (get_local $l1)
        (get_local $l0)))
    (set_local $l4
      (i32.sub
        (get_local $l1)
        (get_local $l0)))
    (return 
        (i32.sub
            (get_local $l3)
            (get_local $l4))))