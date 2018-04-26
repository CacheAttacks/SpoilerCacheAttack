(module
  (type $t0 (func (param i32 i32 i32) (result i32)))
  (type $t1 (func (param i32) (result i32)))
  (type $t2 (func (param i32)))
  (type $t3 (func (result i32)))
  (type $t4 (func (param i32) (result f64)))
  (type $t5 (func (param i32 i32) (result i32)))
  (type $t6 (func (param i32 i32)))
  (type $t7 (func (param i32 i32 i32 i32 i32) (result i32)))
  (type $t8 (func (param i32 i32 i32)))
  (type $t9 (func (param i64 i32 i32) (result i32)))
  (type $t10 (func (param i64 i32) (result i32)))
  (type $t11 (func (param i32 i32 i32 i32 i32)))
  (type $t12 (func (param i32 f64 i32 i32 i32 i32) (result i32)))
  (type $t13 (func (param f64 i32) (result f64)))
  (type $t14 (func (param i32 i32 i32 i32) (result i32)))
  (type $t15 (func (param i32 i32 i32 i32 i32 i32) (result i32)))
  (memory $env.memory (import "env" "memory") 8192 8192)
  (table $env.table (import "env" "table") 6 6 anyfunc)
  (global $env.tableBase (import "env" "tableBase") i32)
  (global $env.DYNAMICTOP_PTR (import "env" "DYNAMICTOP_PTR") i32)
  (global $env.STACKTOP (import "env" "STACKTOP") i32)
  (func $env.abort (import "env" "abort") (type $t2) (param i32))
  (func $env.enlargeMemory (import "env" "enlargeMemory") (type $t3) (result i32))
  (func $env.getTotalMemory (import "env" "getTotalMemory") (type $t3) (result i32))
  (func $env.abortOnCannotGrowMemory (import "env" "abortOnCannotGrowMemory") (type $t3) (result i32))
  (func $env._SAB_get_resolution_ns (import "env" "_SAB_get_resolution_ns") (type $t4) (param i32) (result f64))
  (func $env._SAB_lib_get_counter_value (import "env" "_SAB_lib_get_counter_value") (type $t3) (result i32))
  (func $env.___setErrNo (import "env" "___setErrNo") (type $t2) (param i32))
  (func $env.___syscall140 (import "env" "___syscall140") (type $t5) (param i32 i32) (result i32))
  (func $env.___syscall146 (import "env" "___syscall146") (type $t5) (param i32 i32) (result i32))
  (func $env.___syscall192 (import "env" "___syscall192") (type $t5) (param i32 i32) (result i32))
  (func $env.___syscall54 (import "env" "___syscall54") (type $t5) (param i32 i32) (result i32))
  (func $env.___syscall6 (import "env" "___syscall6") (type $t5) (param i32 i32) (result i32))
  (func $env._emscripten_memcpy_big (import "env" "_emscripten_memcpy_big") (type $t0) (param i32 i32 i32) (result i32))
  (func $env._exit (import "env" "_exit") (type $t2) (param i32))
  (func $f14 (type $t8) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (if $I0
      (i32.eqz
        (i32.and
          (i32.load
            (get_local $p0))
          (i32.const 32)))
      (then
        (drop
          (call $f24
            (get_local $p1)
            (get_local $p2)
            (get_local $p0))))))
  (func $f15 (type $t11) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32)
    (local $l0 i32)
    (set_local $l0
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 256)))
    (if $I0
      (i32.and
        (i32.gt_s
          (get_local $p2)
          (get_local $p3))
        (i32.eqz
          (i32.and
            (get_local $p4)
            (i32.const 73728))))
      (then
        (drop
          (call $_memset
            (get_local $l0)
            (i32.shr_s
              (i32.shl
                (get_local $p1)
                (i32.const 24))
              (i32.const 24))
            (select
              (tee_local $p1
                (i32.sub
                  (get_local $p2)
                  (get_local $p3)))
              (i32.const 256)
              (i32.lt_u
                (get_local $p1)
                (i32.const 256)))))
        (if $I1
          (i32.gt_u
            (get_local $p1)
            (i32.const 255))
          (then
            (set_local $p2
              (i32.sub
                (get_local $p2)
                (get_local $p3)))
            (loop $L2
              (call $f14
                (get_local $p0)
                (get_local $l0)
                (i32.const 256))
              (br_if $L2
                (i32.gt_u
                  (tee_local $p1
                    (i32.add
                      (get_local $p1)
                      (i32.const -256)))
                  (i32.const 255))))
            (set_local $p1
              (i32.and
                (get_local $p2)
                (i32.const 255)))))
        (call $f14
          (get_local $p0)
          (get_local $l0)
          (get_local $p1))))
    (set_global $g4
      (get_local $l0)))
  (func $f16 (type $t1) (param $p0 i32) (result i32)
    (local $l0 i32)
    (if $I0
      (i32.or
        (i32.and
          (i32.gt_s
            (get_local $p0)
            (i32.const 0))
          (i32.lt_s
            (tee_local $p0
              (i32.add
                (tee_local $l0
                  (i32.load
                    (get_global $g3)))
                (get_local $p0)))
            (get_local $l0)))
        (i32.lt_s
          (get_local $p0)
          (i32.const 0)))
      (then
        (drop
          (call $env.abortOnCannotGrowMemory))
        (call $env.___setErrNo
          (i32.const 12))
        (return
          (i32.const -1))))
    (i32.store
      (get_global $g3)
      (get_local $p0))
    (if $I1
      (i32.gt_s
        (get_local $p0)
        (call $env.getTotalMemory))
      (then
        (if $I2
          (i32.eqz
            (call $env.enlargeMemory))
          (then
            (i32.store
              (get_global $g3)
              (get_local $l0))
            (call $env.___setErrNo
              (i32.const 12))
            (return
              (i32.const -1))))))
    (get_local $l0))
  (func $f17 (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (select
      (call $f41
        (get_local $p0))
      (get_local $p0)
      (get_local $p1)))
  (func $f18 (type $t10) (param $p0 i64) (param $p1 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i64)
    (set_local $l1
      (i32.wrap/i64
        (get_local $p0)))
    (if $I0
      (i64.gt_u
        (get_local $p0)
        (i64.const 4294967295))
      (then
        (loop $L1
          (i32.store8
            (tee_local $p1
              (i32.add
                (get_local $p1)
                (i32.const -1)))
            (i32.or
              (i32.and
                (i32.wrap/i64
                  (i64.rem_u
                    (get_local $p0)
                    (i64.const 10)))
                (i32.const 255))
              (i32.const 48)))
          (set_local $l2
            (i64.div_u
              (get_local $p0)
              (i64.const 10)))
          (if $I2
            (i64.gt_u
              (get_local $p0)
              (i64.const 42949672959))
            (then
              (set_local $p0
                (get_local $l2))
              (br $L1))))
        (set_local $l1
          (i32.wrap/i64
            (get_local $l2)))))
    (if $I3
      (get_local $l1)
      (then
        (loop $L4
          (i32.store8
            (tee_local $p1
              (i32.add
                (get_local $p1)
                (i32.const -1)))
            (i32.or
              (i32.rem_u
                (get_local $l1)
                (i32.const 10))
              (i32.const 48)))
          (set_local $l0
            (i32.div_u
              (get_local $l1)
              (i32.const 10)))
          (if $I5
            (i32.ge_u
              (get_local $l1)
              (i32.const 10))
            (then
              (set_local $l1
                (get_local $l0))
              (br $L4))))))
    (get_local $p1))
  (func $_memset (export "_memset") (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32)
    (set_local $l1
      (i32.add
        (get_local $p0)
        (get_local $p2)))
    (set_local $p1
      (i32.and
        (get_local $p1)
        (i32.const 255)))
    (if $I0
      (i32.ge_s
        (get_local $p2)
        (i32.const 67))
      (then
        (loop $L1
          (if $I2
            (i32.and
              (get_local $p0)
              (i32.const 3))
            (then
              (i32.store8
                (get_local $p0)
                (get_local $p1))
              (set_local $p0
                (i32.add
                  (get_local $p0)
                  (i32.const 1)))
              (br $L1))))
        (set_local $l3
          (i32.add
            (tee_local $l2
              (i32.and
                (get_local $l1)
                (i32.const -4)))
            (i32.const -64)))
        (set_local $l0
          (i32.or
            (i32.or
              (i32.or
                (get_local $p1)
                (i32.shl
                  (get_local $p1)
                  (i32.const 8)))
              (i32.shl
                (get_local $p1)
                (i32.const 16)))
            (i32.shl
              (get_local $p1)
              (i32.const 24))))
        (loop $L3
          (if $I4
            (i32.le_s
              (get_local $p0)
              (get_local $l3))
            (then
              (i32.store
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=4
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=8
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=12
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=16
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=20
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=24
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=28
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=32
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=36
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=40
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=44
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=48
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=52
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=56
                (get_local $p0)
                (get_local $l0))
              (i32.store offset=60
                (get_local $p0)
                (get_local $l0))
              (set_local $p0
                (i32.sub
                  (get_local $p0)
                  (i32.const -64)))
              (br $L3))))
        (loop $L5
          (if $I6
            (i32.lt_s
              (get_local $p0)
              (get_local $l2))
            (then
              (i32.store
                (get_local $p0)
                (get_local $l0))
              (set_local $p0
                (i32.add
                  (get_local $p0)
                  (i32.const 4)))
              (br $L5))))))
    (loop $L7
      (if $I8
        (i32.lt_s
          (get_local $p0)
          (get_local $l1))
        (then
          (i32.store8
            (get_local $p0)
            (get_local $p1))
          (set_local $p0
            (i32.add
              (get_local $p0)
              (i32.const 1)))
          (br $L7))))
    (i32.sub
      (get_local $l1)
      (get_local $p2)))
  (func $f20 (type $t1) (param $p0 i32) (result i32)
    (i32.lt_u
      (i32.add
        (get_local $p0)
        (i32.const -48))
      (i32.const 10)))
  (func $f21 (type $t1) (param $p0 i32) (result i32)
    (if $I0 (result i32)
      (i32.gt_u
        (get_local $p0)
        (i32.const -4096))
      (then
        (i32.store
          (i32.const 4488)
          (i32.sub
            (i32.const 0)
            (get_local $p0)))
        (i32.const -1))
      (else
        (get_local $p0))))
  (func $f22 (type $t1) (param $p0 i32) (result i32)
    (local $l0 i32)
    (loop $L0
      (set_local $p0
        (call $env._SAB_lib_get_counter_value))
      (br_if $L0
        (i32.ge_u
          (i32.add
            (call $env._SAB_lib_get_counter_value)
            (i32.xor
              (get_local $p0)
              (i32.const -1)))
          (i32.const 99))))
    (set_local $p0
      (i32.const 0))
    (loop $L1
      (set_local $l0
        (call $env._SAB_lib_get_counter_value))
      (br_if $L1
        (i32.ne
          (tee_local $p0
            (i32.add
              (get_local $p0)
              (i32.const 1)))
          (i32.const 101))))
    (call $f36
      (get_local $l0)
      (call $env._SAB_lib_get_counter_value)))
  (func $f23 (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l0 i32)
    (set_local $l0
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 16)))
    (i32.store
      (get_local $l0)
      (get_local $p1))
    (set_local $p0
      (call $f53
        (i32.load
          (i32.const 1024))
        (get_local $p0)
        (get_local $l0)))
    (set_global $g4
      (get_local $l0))
    (get_local $p0))
  (func $f24 (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32)
    (block $B0
      (block $B1
        (br_if $B1
          (tee_local $l0
            (i32.load
              (tee_local $l2
                (i32.add
                  (get_local $p2)
                  (i32.const 16))))))
        (if $I2
          (call $f29
            (get_local $p2))
          (then
            (set_local $p2
              (i32.const 0)))
          (else
            (set_local $l0
              (i32.load
                (get_local $l2)))
            (br $B1)))
        (br $B0))
      (if $I3
        (i32.lt_u
          (i32.sub
            (get_local $l0)
            (tee_local $l2
              (i32.load
                (tee_local $l3
                  (i32.add
                    (get_local $p2)
                    (i32.const 20))))))
          (get_local $p1))
        (then
          (set_local $p2
            (call_indirect (type $t0)
              (get_local $p2)
              (get_local $p0)
              (get_local $p1)
              (i32.add
                (i32.and
                  (i32.load offset=36
                    (get_local $p2))
                  (i32.const 3))
                (i32.const 2))))
          (br $B0)))
      (block $B4
        (if $I5
          (i32.gt_s
            (i32.load8_s offset=75
              (get_local $p2))
            (i32.const -1))
          (then
            (set_local $l0
              (get_local $p1))
            (loop $L6
              (if $I7
                (i32.eqz
                  (get_local $l0))
                (then
                  (set_local $l0
                    (i32.const 0))
                  (br $B4)))
              (if $I8
                (i32.ne
                  (i32.load8_s
                    (i32.add
                      (get_local $p0)
                      (tee_local $l1
                        (i32.add
                          (get_local $l0)
                          (i32.const -1)))))
                  (i32.const 10))
                (then
                  (set_local $l0
                    (get_local $l1))
                  (br $L6))))
            (br_if $B0
              (i32.lt_u
                (tee_local $p2
                  (call_indirect (type $t0)
                    (get_local $p2)
                    (get_local $p0)
                    (get_local $l0)
                    (i32.add
                      (i32.and
                        (i32.load offset=36
                          (get_local $p2))
                        (i32.const 3))
                      (i32.const 2))))
                (get_local $l0)))
            (set_local $p0
              (i32.add
                (get_local $p0)
                (get_local $l0)))
            (set_local $p1
              (i32.sub
                (get_local $p1)
                (get_local $l0)))
            (set_local $l2
              (i32.load
                (get_local $l3))))
          (else
            (set_local $l0
              (i32.const 0)))))
      (drop
        (call $f40
          (get_local $l2)
          (get_local $p0)
          (get_local $p1)))
      (i32.store
        (get_local $l3)
        (i32.add
          (i32.load
            (get_local $l3))
          (get_local $p1)))
      (set_local $p2
        (i32.add
          (get_local $l0)
          (get_local $p1))))
    (get_local $p2))
  (func $f25 (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32) (local $l13 i32) (local $l14 i32) (local $l15 i32) (local $l16 i32) (local $l17 i32) (local $l18 i32) (local $l19 i32) (local $l20 i32) (local $l21 i64)
    (set_local $l5
      (get_global $g4))
    (set_global $g4
      (i32.sub
        (get_global $g4)
        (i32.const -64)))
    (set_local $l15
      (i32.add
        (get_local $l5)
        (i32.const 20)))
    (i32.store
      (tee_local $l8
        (i32.add
          (get_local $l5)
          (i32.const 16)))
      (get_local $p1))
    (set_local $l13
      (i32.ne
        (get_local $p0)
        (i32.const 0)))
    (set_local $l17
      (tee_local $l12
        (i32.add
          (tee_local $p1
            (i32.add
              (get_local $l5)
              (i32.const 24)))
          (i32.const 40))))
    (set_local $l18
      (i32.add
        (get_local $p1)
        (i32.const 39)))
    (set_local $l19
      (i32.add
        (tee_local $l16
          (i32.add
            (get_local $l5)
            (i32.const 8)))
        (i32.const 4)))
    (set_local $p1
      (i32.const 0))
    (block $B0
      (block $B1
        (loop $L2
          (block $B3
            (if $I4
              (i32.gt_s
                (get_local $l6)
                (i32.const -1))
              (then
                (set_local $l6
                  (if $I5 (result i32)
                    (i32.gt_s
                      (get_local $l0)
                      (i32.sub
                        (i32.const 2147483647)
                        (get_local $l6)))
                    (then
                      (i32.store
                        (i32.const 4488)
                        (i32.const 75))
                      (i32.const -1))
                    (else
                      (i32.add
                        (get_local $l0)
                        (get_local $l6)))))))
            (br_if $B1
              (i32.eqz
                (tee_local $l1
                  (i32.load8_s
                    (tee_local $l4
                      (i32.load
                        (get_local $l8)))))))
            (set_local $l0
              (get_local $l4))
            (block $B6
              (block $B7
                (loop $L8
                  (block $B9
                    (block $B10
                      (br_if $B9
                        (i32.eqz
                          (tee_local $l1
                            (i32.shr_s
                              (i32.shl
                                (get_local $l1)
                                (i32.const 24))
                              (i32.const 24)))))
                      (br_if $B10
                        (i32.ne
                          (get_local $l1)
                          (i32.const 37)))
                      (set_local $l1
                        (get_local $l0))
                      (br $B7))
                    (i32.store
                      (get_local $l8)
                      (tee_local $l0
                        (i32.add
                          (get_local $l0)
                          (i32.const 1))))
                    (set_local $l1
                      (i32.load8_s
                        (get_local $l0)))
                    (br $L8)))
                (br $B6))
              (loop $L11
                (br_if $B6
                  (i32.ne
                    (i32.load8_s offset=1
                      (get_local $l1))
                    (i32.const 37)))
                (set_local $l0
                  (i32.add
                    (get_local $l0)
                    (i32.const 1)))
                (i32.store
                  (get_local $l8)
                  (tee_local $l1
                    (i32.add
                      (get_local $l1)
                      (i32.const 2))))
                (br_if $L11
                  (i32.eq
                    (i32.load8_s
                      (get_local $l1))
                    (i32.const 37)))))
            (set_local $l0
              (i32.sub
                (get_local $l0)
                (get_local $l4)))
            (if $I12
              (get_local $l13)
              (then
                (call $f14
                  (get_local $p0)
                  (get_local $l4)
                  (get_local $l0))))
            (br_if $L2
              (get_local $l0))
            (set_local $l1
              (i32.eqz
                (call $f20
                  (i32.load8_s offset=1
                    (i32.load
                      (get_local $l8))))))
            (i32.store
              (get_local $l8)
              (tee_local $l0
                (i32.add
                  (tee_local $l0
                    (i32.load
                      (get_local $l8)))
                  (if $I13 (result i32)
                    (get_local $l1)
                    (then
                      (set_local $l10
                        (i32.const -1))
                      (i32.const 1))
                    (else
                      (if $I14 (result i32)
                        (i32.eq
                          (i32.load8_s offset=2
                            (get_local $l0))
                          (i32.const 36))
                        (then
                          (set_local $l10
                            (i32.add
                              (i32.load8_s offset=1
                                (get_local $l0))
                              (i32.const -48)))
                          (set_local $p1
                            (i32.const 1))
                          (i32.const 3))
                        (else
                          (set_local $l10
                            (i32.const -1))
                          (i32.const 1))))))))
            (if $I15
              (i32.or
                (i32.gt_u
                  (tee_local $l1
                    (i32.add
                      (tee_local $l2
                        (i32.load8_s
                          (get_local $l0)))
                      (i32.const -32)))
                  (i32.const 31))
                (i32.eqz
                  (i32.and
                    (i32.shl
                      (i32.const 1)
                      (get_local $l1))
                    (i32.const 75913))))
              (then
                (set_local $l1
                  (i32.const 0)))
              (else
                (set_local $l3
                  (i32.const 0))
                (set_local $l1
                  (get_local $l2))
                (loop $L16
                  (set_local $l1
                    (i32.or
                      (i32.shl
                        (i32.const 1)
                        (i32.add
                          (i32.shr_s
                            (i32.shl
                              (get_local $l1)
                              (i32.const 24))
                            (i32.const 24))
                          (i32.const -32)))
                      (get_local $l3)))
                  (i32.store
                    (get_local $l8)
                    (tee_local $l0
                      (i32.add
                        (get_local $l0)
                        (i32.const 1))))
                  (if $I17
                    (i32.eqz
                      (i32.or
                        (i32.gt_u
                          (tee_local $l3
                            (i32.add
                              (tee_local $l2
                                (i32.load8_s
                                  (get_local $l0)))
                              (i32.const -32)))
                          (i32.const 31))
                        (i32.eqz
                          (i32.and
                            (i32.shl
                              (i32.const 1)
                              (get_local $l3))
                            (i32.const 75913)))))
                    (then
                      (set_local $l3
                        (get_local $l1))
                      (set_local $l1
                        (get_local $l2))
                      (br $L16))))))
            (block $B18
              (if $I25
                (i32.eq
                  (i32.load8_s
                    (tee_local $l1
                      (if $I19 (result i32)
                        (i32.eq
                          (i32.and
                            (get_local $l2)
                            (i32.const 255))
                          (i32.const 42))
                        (then
                          (set_local $l0
                            (block $B20 (result i32)
                              (block $B21
                                (br_if $B21
                                  (i32.eqz
                                    (call $f20
                                      (i32.load8_s offset=1
                                        (get_local $l0)))))
                                (br_if $B21
                                  (i32.ne
                                    (i32.load8_s offset=2
                                      (tee_local $l0
                                        (i32.load
                                          (get_local $l8))))
                                    (i32.const 36)))
                                (i32.store
                                  (i32.add
                                    (get_local $p4)
                                    (i32.shl
                                      (i32.add
                                        (i32.load8_s
                                          (tee_local $p1
                                            (i32.add
                                              (get_local $l0)
                                              (i32.const 1))))
                                        (i32.const -48))
                                      (i32.const 2)))
                                  (i32.const 10))
                                (set_local $p1
                                  (i32.wrap/i64
                                    (i64.load
                                      (i32.add
                                        (get_local $p3)
                                        (i32.shl
                                          (i32.add
                                            (i32.load8_s
                                              (get_local $p1))
                                            (i32.const -48))
                                          (i32.const 3))))))
                                (set_local $l2
                                  (i32.const 1))
                                (br $B20
                                  (i32.add
                                    (get_local $l0)
                                    (i32.const 3))))
                              (if $I22
                                (get_local $p1)
                                (then
                                  (set_local $l6
                                    (i32.const -1))
                                  (br $B3)))
                              (if $I23
                                (get_local $l13)
                                (then
                                  (set_local $p1
                                    (i32.load
                                      (tee_local $l0
                                        (i32.and
                                          (i32.add
                                            (i32.load
                                              (get_local $p2))
                                            (i32.const 3))
                                          (i32.const -4)))))
                                  (i32.store
                                    (get_local $p2)
                                    (i32.add
                                      (get_local $l0)
                                      (i32.const 4))))
                                (else
                                  (set_local $p1
                                    (i32.const 0))))
                              (set_local $l2
                                (i32.const 0))
                              (i32.add
                                (i32.load
                                  (get_local $l8))
                                (i32.const 1))))
                          (i32.store
                            (get_local $l8)
                            (get_local $l0))
                          (set_local $l11
                            (select
                              (i32.sub
                                (i32.const 0)
                                (get_local $p1))
                              (get_local $p1)
                              (tee_local $p1
                                (i32.lt_s
                                  (get_local $p1)
                                  (i32.const 0)))))
                          (set_local $l7
                            (select
                              (i32.or
                                (get_local $l1)
                                (i32.const 8192))
                              (get_local $l1)
                              (get_local $p1)))
                          (set_local $p1
                            (get_local $l2))
                          (get_local $l0))
                        (else
                          (if $I24
                            (i32.lt_s
                              (tee_local $l11
                                (call $f33
                                  (get_local $l8)))
                              (i32.const 0))
                            (then
                              (set_local $l6
                                (i32.const -1))
                              (br $B3)))
                          (set_local $l7
                            (get_local $l1))
                          (i32.load
                            (get_local $l8))))))
                  (i32.const 46))
                (then
                  (if $I26
                    (i32.ne
                      (i32.load8_s offset=1
                        (get_local $l1))
                      (i32.const 42))
                    (then
                      (i32.store
                        (get_local $l8)
                        (i32.add
                          (get_local $l1)
                          (i32.const 1)))
                      (set_local $l0
                        (call $f33
                          (get_local $l8)))
                      (set_local $l1
                        (i32.load
                          (get_local $l8)))
                      (br $B18)))
                  (if $I27
                    (call $f20
                      (i32.load8_s offset=2
                        (get_local $l1)))
                    (then
                      (if $I28
                        (i32.eq
                          (i32.load8_s offset=3
                            (tee_local $l1
                              (i32.load
                                (get_local $l8))))
                          (i32.const 36))
                        (then
                          (i32.store
                            (i32.add
                              (get_local $p4)
                              (i32.shl
                                (i32.add
                                  (i32.load8_s
                                    (tee_local $l0
                                      (i32.add
                                        (get_local $l1)
                                        (i32.const 2))))
                                  (i32.const -48))
                                (i32.const 2)))
                            (i32.const 10))
                          (set_local $l0
                            (i32.wrap/i64
                              (i64.load
                                (i32.add
                                  (get_local $p3)
                                  (i32.shl
                                    (i32.add
                                      (i32.load8_s
                                        (get_local $l0))
                                      (i32.const -48))
                                    (i32.const 3))))))
                          (i32.store
                            (get_local $l8)
                            (tee_local $l1
                              (i32.add
                                (get_local $l1)
                                (i32.const 4))))
                          (br $B18)))))
                  (if $I29
                    (get_local $p1)
                    (then
                      (set_local $l6
                        (i32.const -1))
                      (br $B3)))
                  (if $I30
                    (get_local $l13)
                    (then
                      (set_local $l0
                        (i32.load
                          (tee_local $l1
                            (i32.and
                              (i32.add
                                (i32.load
                                  (get_local $p2))
                                (i32.const 3))
                              (i32.const -4)))))
                      (i32.store
                        (get_local $p2)
                        (i32.add
                          (get_local $l1)
                          (i32.const 4))))
                    (else
                      (set_local $l0
                        (i32.const 0))))
                  (i32.store
                    (get_local $l8)
                    (tee_local $l1
                      (i32.add
                        (i32.load
                          (get_local $l8))
                        (i32.const 2)))))
                (else
                  (set_local $l0
                    (i32.const -1)))))
            (set_local $l9
              (i32.const 0))
            (loop $L31
              (if $I32
                (i32.gt_u
                  (i32.add
                    (i32.load8_s
                      (get_local $l1))
                    (i32.const -65))
                  (i32.const 57))
                (then
                  (set_local $l6
                    (i32.const -1))
                  (br $B3)))
              (i32.store
                (get_local $l8)
                (tee_local $l2
                  (i32.add
                    (get_local $l1)
                    (i32.const 1))))
              (if $I33
                (i32.lt_u
                  (i32.add
                    (tee_local $l1
                      (i32.and
                        (tee_local $l3
                          (i32.load8_s
                            (i32.add
                              (i32.add
                                (i32.mul
                                  (get_local $l9)
                                  (i32.const 58))
                                (i32.load8_s
                                  (get_local $l1)))
                              (i32.const 1426))))
                        (i32.const 255)))
                    (i32.const -1))
                  (i32.const 8))
                (then
                  (set_local $l9
                    (get_local $l1))
                  (set_local $l1
                    (get_local $l2))
                  (br $L31))))
            (if $I34
              (i32.eqz
                (get_local $l3))
              (then
                (set_local $l6
                  (i32.const -1))
                (br $B3)))
            (set_local $l14
              (i32.gt_s
                (get_local $l10)
                (i32.const -1)))
            (block $B35
              (block $B36
                (if $I37
                  (i32.eq
                    (get_local $l3)
                    (i32.const 19))
                  (then
                    (if $I38
                      (get_local $l14)
                      (then
                        (set_local $l6
                          (i32.const -1))
                        (br $B3))
                      (else
                        (br $B36)))
                    (unreachable))
                  (else
                    (if $I39
                      (get_local $l14)
                      (then
                        (i32.store
                          (i32.add
                            (get_local $p4)
                            (i32.shl
                              (get_local $l10)
                              (i32.const 2)))
                          (get_local $l1))
                        (i64.store
                          (get_local $l5)
                          (i64.load
                            (i32.add
                              (get_local $p3)
                              (i32.shl
                                (get_local $l10)
                                (i32.const 3)))))
                        (br $B36)))
                    (if $I40
                      (i32.eqz
                        (get_local $l13))
                      (then
                        (set_local $l6
                          (i32.const 0))
                        (br $B3)))
                    (call $f32
                      (get_local $l5)
                      (get_local $l1)
                      (get_local $p2))
                    (set_local $l2
                      (i32.load
                        (get_local $l8)))))
                (br $B35))
              (if $I41
                (i32.eqz
                  (get_local $l13))
                (then
                  (set_local $l0
                    (i32.const 0))
                  (br $L2))))
            (set_local $l1
              (select
                (tee_local $l3
                  (i32.and
                    (get_local $l7)
                    (i32.const -65537)))
                (get_local $l7)
                (i32.and
                  (get_local $l7)
                  (i32.const 8192))))
            (block $B42
              (block $B43
                (block $B44
                  (block $B45
                    (block $B46
                      (block $B47
                        (block $B48
                          (block $B49
                            (block $B50
                              (block $B51
                                (block $B52
                                  (block $B53
                                    (block $B54
                                      (block $B55
                                        (block $B56
                                          (block $B57
                                            (block $B58
                                              (block $B59
                                                (block $B60
                                                  (block $B61
                                                    (br_table $B50 $B49 $B52 $B49 $B50 $B50 $B50 $B49 $B49 $B49 $B49 $B49 $B49 $B49 $B49 $B49 $B49 $B49 $B51 $B49 $B49 $B49 $B49 $B59 $B49 $B49 $B49 $B49 $B49 $B49 $B49 $B49 $B50 $B49 $B55 $B57 $B50 $B50 $B50 $B49 $B57 $B49 $B49 $B49 $B54 $B61 $B58 $B60 $B49 $B49 $B53 $B49 $B56 $B49 $B49 $B59 $B49
                                                      (i32.sub
                                                        (tee_local $l2
                                                          (select
                                                            (i32.and
                                                              (tee_local $l2
                                                                (i32.load8_s
                                                                  (i32.add
                                                                    (get_local $l2)
                                                                    (i32.const -1))))
                                                              (i32.const -33))
                                                            (get_local $l2)
                                                            (i32.and
                                                              (i32.ne
                                                                (get_local $l9)
                                                                (i32.const 0))
                                                              (i32.eq
                                                                (i32.and
                                                                  (get_local $l2)
                                                                  (i32.const 15))
                                                                (i32.const 3)))))
                                                        (i32.const 65))))
                                                  (block $B62
                                                    (block $B63
                                                      (block $B64
                                                        (block $B65
                                                          (block $B66
                                                            (block $B67
                                                              (block $B68
                                                                (block $B69
                                                                  (br_table $B69 $B68 $B67 $B66 $B65 $B62 $B64 $B63 $B62
                                                                    (i32.shr_s
                                                                      (i32.shl
                                                                        (i32.and
                                                                          (get_local $l9)
                                                                          (i32.const 255))
                                                                        (i32.const 24))
                                                                      (i32.const 24))))
                                                                (i32.store
                                                                  (i32.load
                                                                    (get_local $l5))
                                                                  (get_local $l6))
                                                                (set_local $l0
                                                                  (i32.const 0))
                                                                (br $L2))
                                                              (i32.store
                                                                (i32.load
                                                                  (get_local $l5))
                                                                (get_local $l6))
                                                              (set_local $l0
                                                                (i32.const 0))
                                                              (br $L2))
                                                            (i64.store
                                                              (i32.load
                                                                (get_local $l5))
                                                              (i64.extend_s/i32
                                                                (get_local $l6)))
                                                            (set_local $l0
                                                              (i32.const 0))
                                                            (br $L2))
                                                          (i32.store16
                                                            (i32.load
                                                              (get_local $l5))
                                                            (get_local $l6))
                                                          (set_local $l0
                                                            (i32.const 0))
                                                          (br $L2))
                                                        (i32.store8
                                                          (i32.load
                                                            (get_local $l5))
                                                          (get_local $l6))
                                                        (set_local $l0
                                                          (i32.const 0))
                                                        (br $L2))
                                                      (i32.store
                                                        (i32.load
                                                          (get_local $l5))
                                                        (get_local $l6))
                                                      (set_local $l0
                                                        (i32.const 0))
                                                      (br $L2))
                                                    (i64.store
                                                      (i32.load
                                                        (get_local $l5))
                                                      (i64.extend_s/i32
                                                        (get_local $l6)))
                                                    (set_local $l0
                                                      (i32.const 0))
                                                    (br $L2))
                                                  (set_local $l0
                                                    (i32.const 0))
                                                  (br $L2))
                                                (set_local $l2
                                                  (i32.const 120))
                                                (set_local $l0
                                                  (select
                                                    (get_local $l0)
                                                    (i32.const 8)
                                                    (i32.gt_u
                                                      (get_local $l0)
                                                      (i32.const 8))))
                                                (set_local $l1
                                                  (i32.or
                                                    (get_local $l1)
                                                    (i32.const 8)))
                                                (br $B48))
                                              (br $B48))
                                            (set_local $l4
                                              (i32.const 0))
                                            (set_local $l3
                                              (i32.const 1955))
                                            (set_local $l0
                                              (select
                                                (get_local $l0)
                                                (i32.add
                                                  (tee_local $l2
                                                    (i32.sub
                                                      (get_local $l17)
                                                      (tee_local $l7
                                                        (call $f51
                                                          (tee_local $l21
                                                            (i64.load
                                                              (get_local $l5)))
                                                          (get_local $l12)))))
                                                  (i32.const 1))
                                                (i32.or
                                                  (i32.eqz
                                                    (i32.and
                                                      (get_local $l1)
                                                      (i32.const 8)))
                                                  (i32.gt_s
                                                    (get_local $l0)
                                                    (get_local $l2)))))
                                            (br $B44))
                                          (set_local $l4
                                            (if $I70 (result i32)
                                              (i64.lt_s
                                                (tee_local $l21
                                                  (i64.load
                                                    (get_local $l5)))
                                                (i64.const 0))
                                              (then
                                                (i64.store
                                                  (get_local $l5)
                                                  (tee_local $l21
                                                    (i64.sub
                                                      (i64.const 0)
                                                      (get_local $l21))))
                                                (set_local $l3
                                                  (i32.const 1955))
                                                (i32.const 1))
                                              (else
                                                (set_local $l3
                                                  (select
                                                    (i32.const 1956)
                                                    (select
                                                      (i32.const 1957)
                                                      (i32.const 1955)
                                                      (i32.and
                                                        (get_local $l1)
                                                        (i32.const 1)))
                                                    (i32.and
                                                      (get_local $l1)
                                                      (i32.const 2048))))
                                                (i32.ne
                                                  (i32.and
                                                    (get_local $l1)
                                                    (i32.const 2049))
                                                  (i32.const 0)))))
                                          (br $B47))
                                        (set_local $l4
                                          (i32.const 0))
                                        (set_local $l3
                                          (i32.const 1955))
                                        (set_local $l21
                                          (i64.load
                                            (get_local $l5)))
                                        (br $B47))
                                      (i64.store8
                                        (get_local $l18)
                                        (i64.load
                                          (get_local $l5)))
                                      (set_local $l2
                                        (get_local $l18))
                                      (set_local $l9
                                        (i32.const 0))
                                      (set_local $l10
                                        (i32.const 1955))
                                      (set_local $l4
                                        (get_local $l12))
                                      (set_local $l7
                                        (i32.const 1))
                                      (set_local $l1
                                        (get_local $l3))
                                      (br $B42))
                                    (set_local $l2
                                      (call $f47
                                        (i32.load
                                          (i32.const 4488))
                                        (i32.load offset=188
                                          (i32.const 1152))))
                                    (br $B46))
                                  (set_local $l2
                                    (select
                                      (tee_local $l1
                                        (i32.load
                                          (get_local $l5)))
                                      (i32.const 1965)
                                      (get_local $l1)))
                                  (br $B46))
                                (i64.store32
                                  (get_local $l16)
                                  (i64.load
                                    (get_local $l5)))
                                (i32.store
                                  (get_local $l19)
                                  (i32.const 0))
                                (i32.store
                                  (get_local $l5)
                                  (get_local $l16))
                                (set_local $l9
                                  (i32.const -1))
                                (set_local $l2
                                  (get_local $l16))
                                (br $B45))
                              (set_local $l2
                                (i32.load
                                  (get_local $l5)))
                              (if $I71
                                (get_local $l0)
                                (then
                                  (set_local $l9
                                    (get_local $l0))
                                  (br $B45))
                                (else
                                  (call $f15
                                    (get_local $p0)
                                    (i32.const 32)
                                    (get_local $l11)
                                    (i32.const 0)
                                    (get_local $l1))
                                  (set_local $l0
                                    (i32.const 0))
                                  (br $B43)))
                              (unreachable))
                            (set_local $l0
                              (call $f49
                                (get_local $p0)
                                (f64.load
                                  (get_local $l5))
                                (get_local $l11)
                                (get_local $l0)
                                (get_local $l1)
                                (get_local $l2)))
                            (br $L2))
                          (set_local $l2
                            (get_local $l4))
                          (set_local $l9
                            (i32.const 0))
                          (set_local $l10
                            (i32.const 1955))
                          (set_local $l4
                            (get_local $l12))
                          (set_local $l7
                            (get_local $l0))
                          (br $B42))
                        (set_local $l3
                          (i32.or
                            (i32.eqz
                              (i32.and
                                (get_local $l1)
                                (i32.const 8)))
                            (i64.eq
                              (tee_local $l21
                                (i64.load
                                  (get_local $l5)))
                              (i64.const 0))))
                        (set_local $l7
                          (call $f52
                            (get_local $l21)
                            (get_local $l12)
                            (i32.and
                              (get_local $l2)
                              (i32.const 32))))
                        (set_local $l4
                          (select
                            (i32.const 0)
                            (i32.const 2)
                            (get_local $l3)))
                        (set_local $l3
                          (select
                            (i32.const 1955)
                            (i32.add
                              (i32.shr_s
                                (get_local $l2)
                                (i32.const 4))
                              (i32.const 1955))
                            (get_local $l3)))
                        (br $B44))
                      (set_local $l7
                        (call $f18
                          (get_local $l21)
                          (get_local $l12)))
                      (br $B44))
                    (set_local $l7
                      (i32.eqz
                        (tee_local $l1
                          (call $f50
                            (get_local $l2)
                            (i32.const 0)
                            (get_local $l0)))))
                    (set_local $l9
                      (i32.const 0))
                    (set_local $l10
                      (i32.const 1955))
                    (set_local $l4
                      (select
                        (i32.add
                          (get_local $l2)
                          (get_local $l0))
                        (get_local $l1)
                        (get_local $l7)))
                    (set_local $l7
                      (select
                        (get_local $l0)
                        (i32.sub
                          (get_local $l1)
                          (get_local $l2))
                        (get_local $l7)))
                    (set_local $l1
                      (get_local $l3))
                    (br $B42))
                  (set_local $l3
                    (get_local $l2))
                  (set_local $l0
                    (i32.const 0))
                  (set_local $l4
                    (i32.const 0))
                  (loop $L72
                    (block $B73
                      (br_if $B73
                        (i32.eqz
                          (tee_local $l7
                            (i32.load
                              (get_local $l3)))))
                      (br_if $B73
                        (i32.or
                          (i32.lt_s
                            (tee_local $l4
                              (call $f31
                                (get_local $l15)
                                (get_local $l7)))
                            (i32.const 0))
                          (i32.gt_u
                            (get_local $l4)
                            (i32.sub
                              (get_local $l9)
                              (get_local $l0)))))
                      (set_local $l3
                        (i32.add
                          (get_local $l3)
                          (i32.const 4)))
                      (br_if $L72
                        (i32.gt_u
                          (get_local $l9)
                          (tee_local $l0
                            (i32.add
                              (get_local $l4)
                              (get_local $l0)))))))
                  (if $I74
                    (i32.lt_s
                      (get_local $l4)
                      (i32.const 0))
                    (then
                      (set_local $l6
                        (i32.const -1))
                      (br $B3)))
                  (call $f15
                    (get_local $p0)
                    (i32.const 32)
                    (get_local $l11)
                    (get_local $l0)
                    (get_local $l1))
                  (if $I75
                    (get_local $l0)
                    (then
                      (set_local $l4
                        (i32.const 0))
                      (loop $L76
                        (br_if $B43
                          (i32.eqz
                            (tee_local $l3
                              (i32.load
                                (get_local $l2)))))
                        (br_if $B43
                          (i32.gt_s
                            (tee_local $l4
                              (i32.add
                                (tee_local $l3
                                  (call $f31
                                    (get_local $l15)
                                    (get_local $l3)))
                                (get_local $l4)))
                            (get_local $l0)))
                        (set_local $l2
                          (i32.add
                            (get_local $l2)
                            (i32.const 4)))
                        (call $f14
                          (get_local $p0)
                          (get_local $l15)
                          (get_local $l3))
                        (br_if $L76
                          (i32.lt_u
                            (get_local $l4)
                            (get_local $l0)))
                        (br $B43))
                      (unreachable))
                    (else
                      (set_local $l0
                        (i32.const 0))
                      (br $B43)))
                  (unreachable))
                (set_local $l2
                  (select
                    (get_local $l7)
                    (get_local $l12)
                    (tee_local $l20
                      (i32.or
                        (i32.ne
                          (get_local $l0)
                          (i32.const 0))
                        (tee_local $l14
                          (i64.ne
                            (get_local $l21)
                            (i64.const 0)))))))
                (set_local $l9
                  (get_local $l4))
                (set_local $l10
                  (get_local $l3))
                (set_local $l4
                  (get_local $l12))
                (set_local $l7
                  (select
                    (select
                      (get_local $l0)
                      (tee_local $l3
                        (i32.add
                          (i32.sub
                            (get_local $l17)
                            (get_local $l7))
                          (i32.xor
                            (get_local $l14)
                            (i32.const 1))))
                      (i32.gt_s
                        (get_local $l0)
                        (get_local $l3)))
                    (get_local $l0)
                    (get_local $l20)))
                (set_local $l1
                  (select
                    (i32.and
                      (get_local $l1)
                      (i32.const -65537))
                    (get_local $l1)
                    (i32.gt_s
                      (get_local $l0)
                      (i32.const -1))))
                (br $B42))
              (call $f15
                (get_local $p0)
                (i32.const 32)
                (get_local $l11)
                (get_local $l0)
                (i32.xor
                  (get_local $l1)
                  (i32.const 8192)))
              (set_local $l0
                (select
                  (get_local $l11)
                  (get_local $l0)
                  (i32.gt_s
                    (get_local $l11)
                    (get_local $l0))))
              (br $L2))
            (call $f15
              (get_local $p0)
              (i32.const 32)
              (tee_local $l0
                (select
                  (tee_local $l4
                    (i32.add
                      (tee_local $l7
                        (select
                          (tee_local $l3
                            (i32.sub
                              (get_local $l4)
                              (get_local $l2)))
                          (get_local $l7)
                          (i32.lt_s
                            (get_local $l7)
                            (get_local $l3))))
                      (get_local $l9)))
                  (get_local $l11)
                  (i32.lt_s
                    (get_local $l11)
                    (get_local $l4))))
              (get_local $l4)
              (get_local $l1))
            (call $f14
              (get_local $p0)
              (get_local $l10)
              (get_local $l9))
            (call $f15
              (get_local $p0)
              (i32.const 48)
              (get_local $l0)
              (get_local $l4)
              (i32.xor
                (get_local $l1)
                (i32.const 65536)))
            (call $f15
              (get_local $p0)
              (i32.const 48)
              (get_local $l7)
              (get_local $l3)
              (i32.const 0))
            (call $f14
              (get_local $p0)
              (get_local $l2)
              (get_local $l3))
            (call $f15
              (get_local $p0)
              (i32.const 32)
              (get_local $l0)
              (get_local $l4)
              (i32.xor
                (get_local $l1)
                (i32.const 8192)))
            (br $L2)))
        (br $B0))
      (if $I77
        (i32.eqz
          (get_local $p0))
        (then
          (if $I78
            (get_local $p1)
            (then
              (set_local $p0
                (i32.const 1))
              (loop $L79
                (if $I80
                  (tee_local $p1
                    (i32.load
                      (i32.add
                        (get_local $p4)
                        (i32.shl
                          (get_local $p0)
                          (i32.const 2)))))
                  (then
                    (call $f32
                      (i32.add
                        (get_local $p3)
                        (i32.shl
                          (get_local $p0)
                          (i32.const 3)))
                      (get_local $p1)
                      (get_local $p2))
                    (set_local $p1
                      (i32.add
                        (get_local $p0)
                        (i32.const 1)))
                    (if $I81
                      (i32.lt_s
                        (get_local $p0)
                        (i32.const 9))
                      (then
                        (set_local $p0
                          (get_local $p1))
                        (br $L79))
                      (else
                        (set_local $p0
                          (get_local $p1)))))))
              (if $I82
                (i32.lt_s
                  (get_local $p0)
                  (i32.const 10))
                (then
                  (loop $L83
                    (if $I84
                      (i32.load
                        (i32.add
                          (get_local $p4)
                          (i32.shl
                            (get_local $p0)
                            (i32.const 2))))
                      (then
                        (set_local $l6
                          (i32.const -1))
                        (br $B0)))
                    (set_local $p1
                      (i32.add
                        (get_local $p0)
                        (i32.const 1)))
                    (if $I85
                      (i32.lt_s
                        (get_local $p0)
                        (i32.const 9))
                      (then
                        (set_local $p0
                          (get_local $p1))
                        (br $L83))
                      (else
                        (set_local $l6
                          (i32.const 1))))))
                (else
                  (set_local $l6
                    (i32.const 1)))))
            (else
              (set_local $l6
                (i32.const 0)))))))
    (set_global $g4
      (get_local $l5))
    (get_local $l6))
  (func $_malloc (export "_malloc") (type $t1) (param $p0 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32)
    (block $B0
      (block $B1
        (block $B2
          (set_local $l0
            (get_global $g4))
          (set_global $g4
            (i32.add
              (get_global $g4)
              (i32.const 16)))
          (set_local $l9
            (get_local $l0))
          (block $B3
            (if $I4
              (i32.lt_u
                (get_local $p0)
                (i32.const 245))
              (then
                (if $I5
                  (i32.and
                    (tee_local $l0
                      (i32.shr_u
                        (tee_local $l6
                          (i32.load
                            (i32.const 3928)))
                        (tee_local $p0
                          (i32.shr_u
                            (tee_local $l2
                              (select
                                (i32.const 16)
                                (i32.and
                                  (i32.add
                                    (get_local $p0)
                                    (i32.const 11))
                                  (i32.const -8))
                                (i32.lt_u
                                  (get_local $p0)
                                  (i32.const 11))))
                            (i32.const 3)))))
                    (i32.const 3))
                  (then
                    (if $I6
                      (i32.eq
                        (tee_local $l1
                          (i32.load
                            (tee_local $l4
                              (i32.add
                                (tee_local $l2
                                  (i32.load
                                    (tee_local $l3
                                      (i32.add
                                        (tee_local $l0
                                          (i32.add
                                            (i32.shl
                                              (tee_local $p0
                                                (i32.add
                                                  (i32.xor
                                                    (i32.and
                                                      (get_local $l0)
                                                      (i32.const 1))
                                                    (i32.const 1))
                                                  (get_local $p0)))
                                              (i32.const 3))
                                            (i32.const 3968)))
                                        (i32.const 8)))))
                                (i32.const 8)))))
                        (get_local $l0))
                      (then
                        (i32.store
                          (i32.const 3928)
                          (i32.and
                            (get_local $l6)
                            (i32.xor
                              (i32.shl
                                (i32.const 1)
                                (get_local $p0))
                              (i32.const -1)))))
                      (else
                        (i32.store offset=12
                          (get_local $l1)
                          (get_local $l0))
                        (i32.store
                          (get_local $l3)
                          (get_local $l1))))
                    (i32.store offset=4
                      (get_local $l2)
                      (i32.or
                        (tee_local $p0
                          (i32.shl
                            (get_local $p0)
                            (i32.const 3)))
                        (i32.const 3)))
                    (i32.store
                      (tee_local $p0
                        (i32.add
                          (i32.add
                            (get_local $l2)
                            (get_local $p0))
                          (i32.const 4)))
                      (i32.or
                        (i32.load
                          (get_local $p0))
                        (i32.const 1)))
                    (set_global $g4
                      (get_local $l9))
                    (return
                      (get_local $l4))))
                (if $I7
                  (i32.gt_u
                    (get_local $l2)
                    (tee_local $l7
                      (i32.load
                        (i32.const 3936))))
                  (then
                    (if $I8
                      (get_local $l0)
                      (then
                        (set_local $p0
                          (i32.and
                            (i32.shr_u
                              (tee_local $l0
                                (i32.add
                                  (i32.and
                                    (tee_local $p0
                                      (i32.and
                                        (i32.shl
                                          (get_local $l0)
                                          (get_local $p0))
                                        (i32.or
                                          (tee_local $p0
                                            (i32.shl
                                              (i32.const 2)
                                              (get_local $p0)))
                                          (i32.sub
                                            (i32.const 0)
                                            (get_local $p0)))))
                                    (i32.sub
                                      (i32.const 0)
                                      (get_local $p0)))
                                  (i32.const -1)))
                              (i32.const 12))
                            (i32.const 16)))
                        (if $I9
                          (i32.eq
                            (tee_local $l3
                              (i32.load
                                (tee_local $l5
                                  (i32.add
                                    (tee_local $l0
                                      (i32.load
                                        (tee_local $l4
                                          (i32.add
                                            (tee_local $p0
                                              (i32.add
                                                (i32.shl
                                                  (tee_local $l1
                                                    (i32.add
                                                      (i32.or
                                                        (i32.or
                                                          (i32.or
                                                            (i32.or
                                                              (tee_local $l1
                                                                (i32.and
                                                                  (i32.shr_u
                                                                    (tee_local $l0
                                                                      (i32.shr_u
                                                                        (get_local $l0)
                                                                        (get_local $p0)))
                                                                    (i32.const 5))
                                                                  (i32.const 8)))
                                                              (get_local $p0))
                                                            (tee_local $l0
                                                              (i32.and
                                                                (i32.shr_u
                                                                  (tee_local $p0
                                                                    (i32.shr_u
                                                                      (get_local $l0)
                                                                      (get_local $l1)))
                                                                  (i32.const 2))
                                                                (i32.const 4))))
                                                          (tee_local $l0
                                                            (i32.and
                                                              (i32.shr_u
                                                                (tee_local $p0
                                                                  (i32.shr_u
                                                                    (get_local $p0)
                                                                    (get_local $l0)))
                                                                (i32.const 1))
                                                              (i32.const 2))))
                                                        (tee_local $l0
                                                          (i32.and
                                                            (i32.shr_u
                                                              (tee_local $p0
                                                                (i32.shr_u
                                                                  (get_local $p0)
                                                                  (get_local $l0)))
                                                              (i32.const 1))
                                                            (i32.const 1))))
                                                      (i32.shr_u
                                                        (get_local $p0)
                                                        (get_local $l0))))
                                                  (i32.const 3))
                                                (i32.const 3968)))
                                            (i32.const 8)))))
                                    (i32.const 8)))))
                            (get_local $p0))
                          (then
                            (i32.store
                              (i32.const 3928)
                              (tee_local $p0
                                (i32.and
                                  (get_local $l6)
                                  (i32.xor
                                    (i32.shl
                                      (i32.const 1)
                                      (get_local $l1))
                                    (i32.const -1))))))
                          (else
                            (i32.store offset=12
                              (get_local $l3)
                              (get_local $p0))
                            (i32.store
                              (get_local $l4)
                              (get_local $l3))
                            (set_local $p0
                              (get_local $l6))))
                        (i32.store offset=4
                          (get_local $l0)
                          (i32.or
                            (get_local $l2)
                            (i32.const 3)))
                        (i32.store offset=4
                          (tee_local $l4
                            (i32.add
                              (get_local $l0)
                              (get_local $l2)))
                          (i32.or
                            (tee_local $l3
                              (i32.sub
                                (tee_local $l1
                                  (i32.shl
                                    (get_local $l1)
                                    (i32.const 3)))
                                (get_local $l2)))
                            (i32.const 1)))
                        (i32.store
                          (i32.add
                            (get_local $l0)
                            (get_local $l1))
                          (get_local $l3))
                        (if $I10
                          (get_local $l7)
                          (then
                            (set_local $l1
                              (i32.load
                                (i32.const 3948)))
                            (set_local $l0
                              (i32.add
                                (i32.shl
                                  (tee_local $l2
                                    (i32.shr_u
                                      (get_local $l7)
                                      (i32.const 3)))
                                  (i32.const 3))
                                (i32.const 3968)))
                            (set_local $p0
                              (if $I11 (result i32)
                                (i32.and
                                  (get_local $p0)
                                  (tee_local $l2
                                    (i32.shl
                                      (i32.const 1)
                                      (get_local $l2))))
                                (then
                                  (i32.load
                                    (tee_local $l2
                                      (i32.add
                                        (get_local $l0)
                                        (i32.const 8)))))
                                (else
                                  (i32.store
                                    (i32.const 3928)
                                    (i32.or
                                      (get_local $p0)
                                      (get_local $l2)))
                                  (set_local $l2
                                    (i32.add
                                      (get_local $l0)
                                      (i32.const 8)))
                                  (get_local $l0))))
                            (i32.store
                              (get_local $l2)
                              (get_local $l1))
                            (i32.store offset=12
                              (get_local $p0)
                              (get_local $l1))
                            (i32.store offset=8
                              (get_local $l1)
                              (get_local $p0))
                            (i32.store offset=12
                              (get_local $l1)
                              (get_local $l0))))
                        (i32.store
                          (i32.const 3936)
                          (get_local $l3))
                        (i32.store
                          (i32.const 3948)
                          (get_local $l4))
                        (set_global $g4
                          (get_local $l9))
                        (return
                          (get_local $l5))))
                    (if $I12
                      (tee_local $l10
                        (i32.load
                          (i32.const 3932)))
                      (then
                        (set_local $p0
                          (i32.and
                            (i32.shr_u
                              (tee_local $l0
                                (i32.add
                                  (i32.and
                                    (get_local $l10)
                                    (i32.sub
                                      (i32.const 0)
                                      (get_local $l10)))
                                  (i32.const -1)))
                              (i32.const 12))
                            (i32.const 16)))
                        (set_local $l0
                          (i32.sub
                            (i32.and
                              (i32.load offset=4
                                (tee_local $l1
                                  (i32.load
                                    (i32.add
                                      (i32.shl
                                        (i32.add
                                          (i32.or
                                            (i32.or
                                              (i32.or
                                                (i32.or
                                                  (tee_local $l1
                                                    (i32.and
                                                      (i32.shr_u
                                                        (tee_local $l0
                                                          (i32.shr_u
                                                            (get_local $l0)
                                                            (get_local $p0)))
                                                        (i32.const 5))
                                                      (i32.const 8)))
                                                  (get_local $p0))
                                                (tee_local $l0
                                                  (i32.and
                                                    (i32.shr_u
                                                      (tee_local $p0
                                                        (i32.shr_u
                                                          (get_local $l0)
                                                          (get_local $l1)))
                                                      (i32.const 2))
                                                    (i32.const 4))))
                                              (tee_local $l0
                                                (i32.and
                                                  (i32.shr_u
                                                    (tee_local $p0
                                                      (i32.shr_u
                                                        (get_local $p0)
                                                        (get_local $l0)))
                                                    (i32.const 1))
                                                  (i32.const 2))))
                                            (tee_local $l0
                                              (i32.and
                                                (i32.shr_u
                                                  (tee_local $p0
                                                    (i32.shr_u
                                                      (get_local $p0)
                                                      (get_local $l0)))
                                                  (i32.const 1))
                                                (i32.const 1))))
                                          (i32.shr_u
                                            (get_local $p0)
                                            (get_local $l0)))
                                        (i32.const 2))
                                      (i32.const 4232)))))
                              (i32.const -8))
                            (get_local $l2)))
                        (if $I13
                          (tee_local $p0
                            (i32.load
                              (i32.add
                                (tee_local $p0
                                  (i32.add
                                    (get_local $l1)
                                    (i32.const 16)))
                                (i32.shl
                                  (i32.eqz
                                    (i32.load
                                      (get_local $p0)))
                                  (i32.const 2)))))
                          (then
                            (loop $L14
                              (set_local $l3
                                (i32.lt_u
                                  (tee_local $l4
                                    (i32.sub
                                      (i32.and
                                        (i32.load offset=4
                                          (get_local $p0))
                                        (i32.const -8))
                                      (get_local $l2)))
                                  (get_local $l0)))
                              (set_local $l0
                                (select
                                  (get_local $l4)
                                  (get_local $l0)
                                  (get_local $l3)))
                              (set_local $l1
                                (select
                                  (get_local $p0)
                                  (get_local $l1)
                                  (get_local $l3)))
                              (br_if $L14
                                (tee_local $p0
                                  (i32.load
                                    (i32.add
                                      (tee_local $p0
                                        (i32.add
                                          (get_local $p0)
                                          (i32.const 16)))
                                      (i32.shl
                                        (i32.eqz
                                          (i32.load
                                            (get_local $p0)))
                                        (i32.const 2))))))
                              (set_local $l3
                                (get_local $l0))))
                          (else
                            (set_local $l3
                              (get_local $l0))))
                        (if $I15
                          (i32.gt_u
                            (tee_local $l11
                              (i32.add
                                (get_local $l1)
                                (get_local $l2)))
                            (get_local $l1))
                          (then
                            (set_local $l8
                              (i32.load offset=24
                                (get_local $l1)))
                            (block $B16
                              (if $I17
                                (i32.eq
                                  (tee_local $p0
                                    (i32.load offset=12
                                      (get_local $l1)))
                                  (get_local $l1))
                                (then
                                  (if $I18
                                    (i32.eqz
                                      (tee_local $p0
                                        (i32.load
                                          (tee_local $l0
                                            (i32.add
                                              (get_local $l1)
                                              (i32.const 20))))))
                                    (then
                                      (if $I19
                                        (i32.eqz
                                          (tee_local $p0
                                            (i32.load
                                              (tee_local $l0
                                                (i32.add
                                                  (get_local $l1)
                                                  (i32.const 16))))))
                                        (then
                                          (set_local $p0
                                            (i32.const 0))
                                          (br $B16)))))
                                  (loop $L20
                                    (if $I21
                                      (tee_local $l5
                                        (i32.load
                                          (tee_local $l4
                                            (i32.add
                                              (get_local $p0)
                                              (i32.const 20)))))
                                      (then
                                        (set_local $p0
                                          (get_local $l5))
                                        (set_local $l0
                                          (get_local $l4))
                                        (br $L20)))
                                    (if $I22
                                      (tee_local $l5
                                        (i32.load
                                          (tee_local $l4
                                            (i32.add
                                              (get_local $p0)
                                              (i32.const 16)))))
                                      (then
                                        (set_local $p0
                                          (get_local $l5))
                                        (set_local $l0
                                          (get_local $l4))
                                        (br $L20))))
                                  (i32.store
                                    (get_local $l0)
                                    (i32.const 0)))
                                (else
                                  (i32.store offset=12
                                    (tee_local $l0
                                      (i32.load offset=8
                                        (get_local $l1)))
                                    (get_local $p0))
                                  (i32.store offset=8
                                    (get_local $p0)
                                    (get_local $l0)))))
                            (block $B23
                              (if $I24
                                (get_local $l8)
                                (then
                                  (if $I25
                                    (i32.eq
                                      (get_local $l1)
                                      (i32.load
                                        (tee_local $l4
                                          (i32.add
                                            (i32.shl
                                              (tee_local $l0
                                                (i32.load offset=28
                                                  (get_local $l1)))
                                              (i32.const 2))
                                            (i32.const 4232)))))
                                    (then
                                      (i32.store
                                        (get_local $l4)
                                        (get_local $p0))
                                      (if $I26
                                        (i32.eqz
                                          (get_local $p0))
                                        (then
                                          (i32.store
                                            (i32.const 3932)
                                            (i32.and
                                              (get_local $l10)
                                              (i32.xor
                                                (i32.shl
                                                  (i32.const 1)
                                                  (get_local $l0))
                                                (i32.const -1))))
                                          (br $B23))))
                                    (else
                                      (i32.store
                                        (i32.add
                                          (tee_local $l0
                                            (i32.add
                                              (get_local $l8)
                                              (i32.const 16)))
                                          (i32.shl
                                            (i32.ne
                                              (i32.load
                                                (get_local $l0))
                                              (get_local $l1))
                                            (i32.const 2)))
                                        (get_local $p0))
                                      (br_if $B23
                                        (i32.eqz
                                          (get_local $p0)))))
                                  (i32.store offset=24
                                    (get_local $p0)
                                    (get_local $l8))
                                  (if $I27
                                    (tee_local $l0
                                      (i32.load offset=16
                                        (get_local $l1)))
                                    (then
                                      (i32.store offset=16
                                        (get_local $p0)
                                        (get_local $l0))
                                      (i32.store offset=24
                                        (get_local $l0)
                                        (get_local $p0))))
                                  (if $I28
                                    (tee_local $l0
                                      (i32.load offset=20
                                        (get_local $l1)))
                                    (then
                                      (i32.store offset=20
                                        (get_local $p0)
                                        (get_local $l0))
                                      (i32.store offset=24
                                        (get_local $l0)
                                        (get_local $p0)))))))
                            (if $I29
                              (i32.lt_u
                                (get_local $l3)
                                (i32.const 16))
                              (then
                                (i32.store offset=4
                                  (get_local $l1)
                                  (i32.or
                                    (tee_local $p0
                                      (i32.add
                                        (get_local $l3)
                                        (get_local $l2)))
                                    (i32.const 3)))
                                (i32.store
                                  (tee_local $p0
                                    (i32.add
                                      (i32.add
                                        (get_local $l1)
                                        (get_local $p0))
                                      (i32.const 4)))
                                  (i32.or
                                    (i32.load
                                      (get_local $p0))
                                    (i32.const 1))))
                              (else
                                (i32.store offset=4
                                  (get_local $l1)
                                  (i32.or
                                    (get_local $l2)
                                    (i32.const 3)))
                                (i32.store offset=4
                                  (get_local $l11)
                                  (i32.or
                                    (get_local $l3)
                                    (i32.const 1)))
                                (i32.store
                                  (i32.add
                                    (get_local $l11)
                                    (get_local $l3))
                                  (get_local $l3))
                                (if $I30
                                  (get_local $l7)
                                  (then
                                    (set_local $l4
                                      (i32.load
                                        (i32.const 3948)))
                                    (set_local $p0
                                      (i32.add
                                        (i32.shl
                                          (tee_local $l0
                                            (i32.shr_u
                                              (get_local $l7)
                                              (i32.const 3)))
                                          (i32.const 3))
                                        (i32.const 3968)))
                                    (set_local $l0
                                      (if $I31 (result i32)
                                        (i32.and
                                          (get_local $l6)
                                          (tee_local $l0
                                            (i32.shl
                                              (i32.const 1)
                                              (get_local $l0))))
                                        (then
                                          (i32.load
                                            (tee_local $l2
                                              (i32.add
                                                (get_local $p0)
                                                (i32.const 8)))))
                                        (else
                                          (i32.store
                                            (i32.const 3928)
                                            (i32.or
                                              (get_local $l6)
                                              (get_local $l0)))
                                          (set_local $l2
                                            (i32.add
                                              (get_local $p0)
                                              (i32.const 8)))
                                          (get_local $p0))))
                                    (i32.store
                                      (get_local $l2)
                                      (get_local $l4))
                                    (i32.store offset=12
                                      (get_local $l0)
                                      (get_local $l4))
                                    (i32.store offset=8
                                      (get_local $l4)
                                      (get_local $l0))
                                    (i32.store offset=12
                                      (get_local $l4)
                                      (get_local $p0))))
                                (i32.store
                                  (i32.const 3936)
                                  (get_local $l3))
                                (i32.store
                                  (i32.const 3948)
                                  (get_local $l11))))
                            (set_global $g4
                              (get_local $l9))
                            (return
                              (i32.add
                                (get_local $l1)
                                (i32.const 8))))
                          (else
                            (set_local $p0
                              (get_local $l2)))))
                      (else
                        (set_local $p0
                          (get_local $l2)))))
                  (else
                    (set_local $p0
                      (get_local $l2)))))
              (else
                (if $I32
                  (i32.gt_u
                    (get_local $p0)
                    (i32.const -65))
                  (then
                    (set_local $p0
                      (i32.const -1)))
                  (else
                    (set_local $l1
                      (i32.and
                        (tee_local $p0
                          (i32.add
                            (get_local $p0)
                            (i32.const 11)))
                        (i32.const -8)))
                    (if $I33
                      (tee_local $l3
                        (i32.load
                          (i32.const 3932)))
                      (then
                        (set_local $l7
                          (if $I34 (result i32)
                            (tee_local $p0
                              (i32.shr_u
                                (get_local $p0)
                                (i32.const 8)))
                            (then
                              (if $I35 (result i32)
                                (i32.gt_u
                                  (get_local $l1)
                                  (i32.const 16777215))
                                (then
                                  (i32.const 31))
                                (else
                                  (i32.or
                                    (i32.and
                                      (i32.shr_u
                                        (get_local $l1)
                                        (i32.add
                                          (tee_local $p0
                                            (i32.add
                                              (i32.sub
                                                (i32.const 14)
                                                (i32.or
                                                  (i32.or
                                                    (tee_local $l2
                                                      (i32.and
                                                        (i32.shr_u
                                                          (i32.add
                                                            (tee_local $l0
                                                              (i32.shl
                                                                (get_local $p0)
                                                                (tee_local $p0
                                                                  (i32.and
                                                                    (i32.shr_u
                                                                      (i32.add
                                                                        (get_local $p0)
                                                                        (i32.const 1048320))
                                                                      (i32.const 16))
                                                                    (i32.const 8)))))
                                                            (i32.const 520192))
                                                          (i32.const 16))
                                                        (i32.const 4)))
                                                    (get_local $p0))
                                                  (tee_local $l0
                                                    (i32.and
                                                      (i32.shr_u
                                                        (i32.add
                                                          (tee_local $p0
                                                            (i32.shl
                                                              (get_local $l0)
                                                              (get_local $l2)))
                                                          (i32.const 245760))
                                                        (i32.const 16))
                                                      (i32.const 2)))))
                                              (i32.shr_u
                                                (i32.shl
                                                  (get_local $p0)
                                                  (get_local $l0))
                                                (i32.const 15))))
                                          (i32.const 7)))
                                      (i32.const 1))
                                    (i32.shl
                                      (get_local $p0)
                                      (i32.const 1))))))
                            (else
                              (i32.const 0))))
                        (set_local $l2
                          (i32.sub
                            (i32.const 0)
                            (get_local $l1)))
                        (block $B36
                          (block $B37
                            (if $I38
                              (tee_local $p0
                                (i32.load
                                  (i32.add
                                    (i32.shl
                                      (get_local $l7)
                                      (i32.const 2))
                                    (i32.const 4232))))
                              (then
                                (set_local $l0
                                  (i32.const 0))
                                (set_local $l5
                                  (i32.shl
                                    (get_local $l1)
                                    (select
                                      (i32.const 0)
                                      (i32.sub
                                        (i32.const 25)
                                        (i32.shr_u
                                          (get_local $l7)
                                          (i32.const 1)))
                                      (i32.eq
                                        (get_local $l7)
                                        (i32.const 31)))))
                                (loop $L39
                                  (if $I40
                                    (i32.lt_u
                                      (tee_local $l6
                                        (i32.sub
                                          (i32.and
                                            (i32.load offset=4
                                              (get_local $p0))
                                            (i32.const -8))
                                          (get_local $l1)))
                                      (get_local $l2))
                                    (then
                                      (if $I41
                                        (get_local $l6)
                                        (then
                                          (set_local $l0
                                            (get_local $p0))
                                          (set_local $l2
                                            (get_local $l6)))
                                        (else
                                          (set_local $l2
                                            (i32.const 0))
                                          (set_local $l0
                                            (get_local $p0))
                                          (br $B37)))))
                                  (set_local $l4
                                    (select
                                      (get_local $l4)
                                      (tee_local $l4
                                        (i32.load offset=20
                                          (get_local $p0)))
                                      (i32.or
                                        (i32.eqz
                                          (get_local $l4))
                                        (i32.eq
                                          (get_local $l4)
                                          (tee_local $p0
                                            (i32.load
                                              (i32.add
                                                (i32.add
                                                  (get_local $p0)
                                                  (i32.const 16))
                                                (i32.shl
                                                  (i32.shr_u
                                                    (get_local $l5)
                                                    (i32.const 31))
                                                  (i32.const 2)))))))))
                                  (set_local $l5
                                    (i32.shl
                                      (get_local $l5)
                                      (i32.xor
                                        (tee_local $l6
                                          (i32.eqz
                                            (get_local $p0)))
                                        (i32.const 1))))
                                  (br_if $L39
                                    (i32.eqz
                                      (get_local $l6)))))
                              (else
                                (set_local $l0
                                  (i32.const 0))))
                            (br_if $B37
                              (tee_local $p0
                                (if $I42 (result i32)
                                  (i32.or
                                    (get_local $l4)
                                    (get_local $l0))
                                  (then
                                    (get_local $l4))
                                  (else
                                    (if $I43
                                      (i32.eqz
                                        (tee_local $p0
                                          (i32.and
                                            (get_local $l3)
                                            (i32.or
                                              (tee_local $p0
                                                (i32.shl
                                                  (i32.const 2)
                                                  (get_local $l7)))
                                              (i32.sub
                                                (i32.const 0)
                                                (get_local $p0))))))
                                      (then
                                        (set_local $p0
                                          (get_local $l1))
                                        (br $B3)))
                                    (set_local $p0
                                      (i32.and
                                        (i32.shr_u
                                          (tee_local $l4
                                            (i32.add
                                              (i32.and
                                                (get_local $p0)
                                                (i32.sub
                                                  (i32.const 0)
                                                  (get_local $p0)))
                                              (i32.const -1)))
                                          (i32.const 12))
                                        (i32.const 16)))
                                    (set_local $l0
                                      (i32.const 0))
                                    (i32.load
                                      (i32.add
                                        (i32.shl
                                          (i32.add
                                            (i32.or
                                              (i32.or
                                                (i32.or
                                                  (i32.or
                                                    (tee_local $l5
                                                      (i32.and
                                                        (i32.shr_u
                                                          (tee_local $l4
                                                            (i32.shr_u
                                                              (get_local $l4)
                                                              (get_local $p0)))
                                                          (i32.const 5))
                                                        (i32.const 8)))
                                                    (get_local $p0))
                                                  (tee_local $l4
                                                    (i32.and
                                                      (i32.shr_u
                                                        (tee_local $p0
                                                          (i32.shr_u
                                                            (get_local $l4)
                                                            (get_local $l5)))
                                                        (i32.const 2))
                                                      (i32.const 4))))
                                                (tee_local $l4
                                                  (i32.and
                                                    (i32.shr_u
                                                      (tee_local $p0
                                                        (i32.shr_u
                                                          (get_local $p0)
                                                          (get_local $l4)))
                                                      (i32.const 1))
                                                    (i32.const 2))))
                                              (tee_local $l4
                                                (i32.and
                                                  (i32.shr_u
                                                    (tee_local $p0
                                                      (i32.shr_u
                                                        (get_local $p0)
                                                        (get_local $l4)))
                                                    (i32.const 1))
                                                  (i32.const 1))))
                                            (i32.shr_u
                                              (get_local $p0)
                                              (get_local $l4)))
                                          (i32.const 2))
                                        (i32.const 4232)))))))
                            (set_local $l4
                              (get_local $l0))
                            (br $B36))
                          (loop $L44
                            (set_local $l4
                              (i32.lt_u
                                (tee_local $l5
                                  (i32.sub
                                    (i32.and
                                      (i32.load offset=4
                                        (get_local $p0))
                                      (i32.const -8))
                                    (get_local $l1)))
                                (get_local $l2)))
                            (set_local $l2
                              (select
                                (get_local $l5)
                                (get_local $l2)
                                (get_local $l4)))
                            (set_local $l0
                              (select
                                (get_local $p0)
                                (get_local $l0)
                                (get_local $l4)))
                            (br_if $L44
                              (tee_local $p0
                                (i32.load
                                  (i32.add
                                    (tee_local $p0
                                      (i32.add
                                        (get_local $p0)
                                        (i32.const 16)))
                                    (i32.shl
                                      (i32.eqz
                                        (i32.load
                                          (get_local $p0)))
                                      (i32.const 2))))))
                            (set_local $l4
                              (get_local $l0))))
                        (if $I45
                          (get_local $l4)
                          (then
                            (if $I46
                              (i32.lt_u
                                (get_local $l2)
                                (i32.sub
                                  (i32.load
                                    (i32.const 3936))
                                  (get_local $l1)))
                              (then
                                (br_if $B2
                                  (i32.le_u
                                    (tee_local $l7
                                      (i32.add
                                        (get_local $l4)
                                        (get_local $l1)))
                                    (get_local $l4)))
                                (set_local $l8
                                  (i32.load offset=24
                                    (get_local $l4)))
                                (block $B47
                                  (if $I48
                                    (i32.eq
                                      (tee_local $p0
                                        (i32.load offset=12
                                          (get_local $l4)))
                                      (get_local $l4))
                                    (then
                                      (if $I49
                                        (i32.eqz
                                          (tee_local $p0
                                            (i32.load
                                              (tee_local $l0
                                                (i32.add
                                                  (get_local $l4)
                                                  (i32.const 20))))))
                                        (then
                                          (if $I50
                                            (i32.eqz
                                              (tee_local $p0
                                                (i32.load
                                                  (tee_local $l0
                                                    (i32.add
                                                      (get_local $l4)
                                                      (i32.const 16))))))
                                            (then
                                              (set_local $p0
                                                (i32.const 0))
                                              (br $B47)))))
                                      (loop $L51
                                        (if $I52
                                          (tee_local $l6
                                            (i32.load
                                              (tee_local $l5
                                                (i32.add
                                                  (get_local $p0)
                                                  (i32.const 20)))))
                                          (then
                                            (set_local $p0
                                              (get_local $l6))
                                            (set_local $l0
                                              (get_local $l5))
                                            (br $L51)))
                                        (if $I53
                                          (tee_local $l6
                                            (i32.load
                                              (tee_local $l5
                                                (i32.add
                                                  (get_local $p0)
                                                  (i32.const 16)))))
                                          (then
                                            (set_local $p0
                                              (get_local $l6))
                                            (set_local $l0
                                              (get_local $l5))
                                            (br $L51))))
                                      (i32.store
                                        (get_local $l0)
                                        (i32.const 0)))
                                    (else
                                      (i32.store offset=12
                                        (tee_local $l0
                                          (i32.load offset=8
                                            (get_local $l4)))
                                        (get_local $p0))
                                      (i32.store offset=8
                                        (get_local $p0)
                                        (get_local $l0)))))
                                (block $B54
                                  (set_local $p0
                                    (if $I55 (result i32)
                                      (get_local $l8)
                                      (then
                                        (if $I56
                                          (i32.eq
                                            (get_local $l4)
                                            (i32.load
                                              (tee_local $l5
                                                (i32.add
                                                  (i32.shl
                                                    (tee_local $l0
                                                      (i32.load offset=28
                                                        (get_local $l4)))
                                                    (i32.const 2))
                                                  (i32.const 4232)))))
                                          (then
                                            (i32.store
                                              (get_local $l5)
                                              (get_local $p0))
                                            (if $I57
                                              (i32.eqz
                                                (get_local $p0))
                                              (then
                                                (i32.store
                                                  (i32.const 3932)
                                                  (tee_local $p0
                                                    (i32.and
                                                      (get_local $l3)
                                                      (i32.xor
                                                        (i32.shl
                                                          (i32.const 1)
                                                          (get_local $l0))
                                                        (i32.const -1)))))
                                                (br $B54))))
                                          (else
                                            (i32.store
                                              (i32.add
                                                (tee_local $l0
                                                  (i32.add
                                                    (get_local $l8)
                                                    (i32.const 16)))
                                                (i32.shl
                                                  (i32.ne
                                                    (i32.load
                                                      (get_local $l0))
                                                    (get_local $l4))
                                                  (i32.const 2)))
                                              (get_local $p0))
                                            (if $I58
                                              (i32.eqz
                                                (get_local $p0))
                                              (then
                                                (set_local $p0
                                                  (get_local $l3))
                                                (br $B54)))))
                                        (i32.store offset=24
                                          (get_local $p0)
                                          (get_local $l8))
                                        (if $I59
                                          (tee_local $l0
                                            (i32.load offset=16
                                              (get_local $l4)))
                                          (then
                                            (i32.store offset=16
                                              (get_local $p0)
                                              (get_local $l0))
                                            (i32.store offset=24
                                              (get_local $l0)
                                              (get_local $p0))))
                                        (if $I60 (result i32)
                                          (tee_local $l0
                                            (i32.load offset=20
                                              (get_local $l4)))
                                          (then
                                            (i32.store offset=20
                                              (get_local $p0)
                                              (get_local $l0))
                                            (i32.store offset=24
                                              (get_local $l0)
                                              (get_local $p0))
                                            (get_local $l3))
                                          (else
                                            (get_local $l3))))
                                      (else
                                        (get_local $l3)))))
                                (block $B61
                                  (if $I62
                                    (i32.lt_u
                                      (get_local $l2)
                                      (i32.const 16))
                                    (then
                                      (i32.store offset=4
                                        (get_local $l4)
                                        (i32.or
                                          (tee_local $p0
                                            (i32.add
                                              (get_local $l2)
                                              (get_local $l1)))
                                          (i32.const 3)))
                                      (i32.store
                                        (tee_local $p0
                                          (i32.add
                                            (i32.add
                                              (get_local $l4)
                                              (get_local $p0))
                                            (i32.const 4)))
                                        (i32.or
                                          (i32.load
                                            (get_local $p0))
                                          (i32.const 1))))
                                    (else
                                      (i32.store offset=4
                                        (get_local $l4)
                                        (i32.or
                                          (get_local $l1)
                                          (i32.const 3)))
                                      (i32.store offset=4
                                        (get_local $l7)
                                        (i32.or
                                          (get_local $l2)
                                          (i32.const 1)))
                                      (i32.store
                                        (i32.add
                                          (get_local $l7)
                                          (get_local $l2))
                                        (get_local $l2))
                                      (set_local $l0
                                        (i32.shr_u
                                          (get_local $l2)
                                          (i32.const 3)))
                                      (if $I63
                                        (i32.lt_u
                                          (get_local $l2)
                                          (i32.const 256))
                                        (then
                                          (set_local $p0
                                            (i32.add
                                              (i32.shl
                                                (get_local $l0)
                                                (i32.const 3))
                                              (i32.const 3968)))
                                          (set_local $l0
                                            (if $I64 (result i32)
                                              (i32.and
                                                (tee_local $l2
                                                  (i32.load
                                                    (i32.const 3928)))
                                                (tee_local $l0
                                                  (i32.shl
                                                    (i32.const 1)
                                                    (get_local $l0))))
                                              (then
                                                (i32.load
                                                  (tee_local $l2
                                                    (i32.add
                                                      (get_local $p0)
                                                      (i32.const 8)))))
                                              (else
                                                (i32.store
                                                  (i32.const 3928)
                                                  (i32.or
                                                    (get_local $l2)
                                                    (get_local $l0)))
                                                (set_local $l2
                                                  (i32.add
                                                    (get_local $p0)
                                                    (i32.const 8)))
                                                (get_local $p0))))
                                          (i32.store
                                            (get_local $l2)
                                            (get_local $l7))
                                          (i32.store offset=12
                                            (get_local $l0)
                                            (get_local $l7))
                                          (i32.store offset=8
                                            (get_local $l7)
                                            (get_local $l0))
                                          (i32.store offset=12
                                            (get_local $l7)
                                            (get_local $p0))
                                          (br $B61)))
                                      (set_local $l1
                                        (i32.add
                                          (i32.shl
                                            (tee_local $l0
                                              (if $I65 (result i32)
                                                (tee_local $l0
                                                  (i32.shr_u
                                                    (get_local $l2)
                                                    (i32.const 8)))
                                                (then
                                                  (if $I66 (result i32)
                                                    (i32.gt_u
                                                      (get_local $l2)
                                                      (i32.const 16777215))
                                                    (then
                                                      (i32.const 31))
                                                    (else
                                                      (i32.or
                                                        (i32.and
                                                          (i32.shr_u
                                                            (get_local $l2)
                                                            (i32.add
                                                              (tee_local $l0
                                                                (i32.add
                                                                  (i32.sub
                                                                    (i32.const 14)
                                                                    (i32.or
                                                                      (i32.or
                                                                        (tee_local $l3
                                                                          (i32.and
                                                                            (i32.shr_u
                                                                              (i32.add
                                                                                (tee_local $l1
                                                                                  (i32.shl
                                                                                    (get_local $l0)
                                                                                    (tee_local $l0
                                                                                      (i32.and
                                                                                        (i32.shr_u
                                                                                          (i32.add
                                                                                            (get_local $l0)
                                                                                            (i32.const 1048320))
                                                                                          (i32.const 16))
                                                                                        (i32.const 8)))))
                                                                                (i32.const 520192))
                                                                              (i32.const 16))
                                                                            (i32.const 4)))
                                                                        (get_local $l0))
                                                                      (tee_local $l1
                                                                        (i32.and
                                                                          (i32.shr_u
                                                                            (i32.add
                                                                              (tee_local $l0
                                                                                (i32.shl
                                                                                  (get_local $l1)
                                                                                  (get_local $l3)))
                                                                              (i32.const 245760))
                                                                            (i32.const 16))
                                                                          (i32.const 2)))))
                                                                  (i32.shr_u
                                                                    (i32.shl
                                                                      (get_local $l0)
                                                                      (get_local $l1))
                                                                    (i32.const 15))))
                                                              (i32.const 7)))
                                                          (i32.const 1))
                                                        (i32.shl
                                                          (get_local $l0)
                                                          (i32.const 1))))))
                                                (else
                                                  (i32.const 0))))
                                            (i32.const 2))
                                          (i32.const 4232)))
                                      (i32.store offset=28
                                        (get_local $l7)
                                        (get_local $l0))
                                      (i32.store offset=4
                                        (tee_local $l3
                                          (i32.add
                                            (get_local $l7)
                                            (i32.const 16)))
                                        (i32.const 0))
                                      (i32.store
                                        (get_local $l3)
                                        (i32.const 0))
                                      (if $I67
                                        (i32.eqz
                                          (i32.and
                                            (get_local $p0)
                                            (tee_local $l3
                                              (i32.shl
                                                (i32.const 1)
                                                (get_local $l0)))))
                                        (then
                                          (i32.store
                                            (i32.const 3932)
                                            (i32.or
                                              (get_local $p0)
                                              (get_local $l3)))
                                          (i32.store
                                            (get_local $l1)
                                            (get_local $l7))
                                          (i32.store offset=24
                                            (get_local $l7)
                                            (get_local $l1))
                                          (i32.store offset=12
                                            (get_local $l7)
                                            (get_local $l7))
                                          (i32.store offset=8
                                            (get_local $l7)
                                            (get_local $l7))
                                          (br $B61)))
                                      (set_local $l0
                                        (i32.shl
                                          (get_local $l2)
                                          (select
                                            (i32.const 0)
                                            (i32.sub
                                              (i32.const 25)
                                              (i32.shr_u
                                                (get_local $l0)
                                                (i32.const 1)))
                                            (i32.eq
                                              (get_local $l0)
                                              (i32.const 31)))))
                                      (set_local $p0
                                        (i32.load
                                          (get_local $l1)))
                                      (block $B68
                                        (loop $L69
                                          (br_if $B68
                                            (i32.eq
                                              (i32.and
                                                (i32.load offset=4
                                                  (get_local $p0))
                                                (i32.const -8))
                                              (get_local $l2)))
                                          (set_local $l1
                                            (i32.shl
                                              (get_local $l0)
                                              (i32.const 1)))
                                          (if $I70
                                            (tee_local $l3
                                              (i32.load
                                                (tee_local $l0
                                                  (i32.add
                                                    (i32.add
                                                      (get_local $p0)
                                                      (i32.const 16))
                                                    (i32.shl
                                                      (i32.shr_u
                                                        (get_local $l0)
                                                        (i32.const 31))
                                                      (i32.const 2))))))
                                            (then
                                              (set_local $l0
                                                (get_local $l1))
                                              (set_local $p0
                                                (get_local $l3))
                                              (br $L69))))
                                        (i32.store
                                          (get_local $l0)
                                          (get_local $l7))
                                        (i32.store offset=24
                                          (get_local $l7)
                                          (get_local $p0))
                                        (i32.store offset=12
                                          (get_local $l7)
                                          (get_local $l7))
                                        (i32.store offset=8
                                          (get_local $l7)
                                          (get_local $l7))
                                        (br $B61))
                                      (i32.store offset=12
                                        (tee_local $l2
                                          (i32.load
                                            (tee_local $l0
                                              (i32.add
                                                (get_local $p0)
                                                (i32.const 8)))))
                                        (get_local $l7))
                                      (i32.store
                                        (get_local $l0)
                                        (get_local $l7))
                                      (i32.store offset=8
                                        (get_local $l7)
                                        (get_local $l2))
                                      (i32.store offset=12
                                        (get_local $l7)
                                        (get_local $p0))
                                      (i32.store offset=24
                                        (get_local $l7)
                                        (i32.const 0)))))
                                (set_global $g4
                                  (get_local $l9))
                                (return
                                  (i32.add
                                    (get_local $l4)
                                    (i32.const 8))))
                              (else
                                (set_local $p0
                                  (get_local $l1)))))
                          (else
                            (set_local $p0
                              (get_local $l1)))))
                      (else
                        (set_local $p0
                          (get_local $l1)))))))))
          (if $I71
            (i32.ge_u
              (tee_local $l2
                (i32.load
                  (i32.const 3936)))
              (get_local $p0))
            (then
              (set_local $l0
                (i32.load
                  (i32.const 3948)))
              (if $I72
                (i32.gt_u
                  (tee_local $l1
                    (i32.sub
                      (get_local $l2)
                      (get_local $p0)))
                  (i32.const 15))
                (then
                  (i32.store
                    (i32.const 3948)
                    (tee_local $l3
                      (i32.add
                        (get_local $l0)
                        (get_local $p0))))
                  (i32.store
                    (i32.const 3936)
                    (get_local $l1))
                  (i32.store offset=4
                    (get_local $l3)
                    (i32.or
                      (get_local $l1)
                      (i32.const 1)))
                  (i32.store
                    (i32.add
                      (get_local $l0)
                      (get_local $l2))
                    (get_local $l1))
                  (i32.store offset=4
                    (get_local $l0)
                    (i32.or
                      (get_local $p0)
                      (i32.const 3))))
                (else
                  (i32.store
                    (i32.const 3936)
                    (i32.const 0))
                  (i32.store
                    (i32.const 3948)
                    (i32.const 0))
                  (i32.store offset=4
                    (get_local $l0)
                    (i32.or
                      (get_local $l2)
                      (i32.const 3)))
                  (i32.store
                    (tee_local $p0
                      (i32.add
                        (i32.add
                          (get_local $l0)
                          (get_local $l2))
                        (i32.const 4)))
                    (i32.or
                      (i32.load
                        (get_local $p0))
                      (i32.const 1)))))
              (br $B0)))
          (if $I73
            (i32.gt_u
              (tee_local $l2
                (i32.load
                  (i32.const 3940)))
              (get_local $p0))
            (then
              (i32.store
                (i32.const 3940)
                (tee_local $l2
                  (i32.sub
                    (get_local $l2)
                    (get_local $p0))))
              (br $B1)))
          (br_if $B2
            (i32.le_u
              (tee_local $l3
                (i32.and
                  (tee_local $l5
                    (i32.add
                      (tee_local $l0
                        (if $I74 (result i32)
                          (i32.load
                            (i32.const 4400))
                          (then
                            (i32.load
                              (i32.const 4408)))
                          (else
                            (i32.store
                              (i32.const 4408)
                              (i32.const 4096))
                            (i32.store
                              (i32.const 4404)
                              (i32.const 4096))
                            (i32.store
                              (i32.const 4412)
                              (i32.const -1))
                            (i32.store
                              (i32.const 4416)
                              (i32.const -1))
                            (i32.store
                              (i32.const 4420)
                              (i32.const 0))
                            (i32.store
                              (i32.const 4372)
                              (i32.const 0))
                            (i32.store
                              (i32.const 4400)
                              (i32.xor
                                (i32.and
                                  (get_local $l9)
                                  (i32.const -16))
                                (i32.const 1431655768)))
                            (i32.const 4096))))
                      (tee_local $l4
                        (i32.add
                          (get_local $p0)
                          (i32.const 47)))))
                  (tee_local $l6
                    (i32.sub
                      (i32.const 0)
                      (get_local $l0)))))
              (get_local $p0)))
          (if $I75
            (tee_local $l0
              (i32.load
                (i32.const 4368)))
            (then
              (br_if $B2
                (i32.or
                  (i32.le_u
                    (tee_local $l7
                      (i32.add
                        (tee_local $l1
                          (i32.load
                            (i32.const 4360)))
                        (get_local $l3)))
                    (get_local $l1))
                  (i32.gt_u
                    (get_local $l7)
                    (get_local $l0))))))
          (set_local $l7
            (i32.add
              (get_local $p0)
              (i32.const 48)))
          (block $B76
            (block $B77
              (if $I78
                (i32.and
                  (i32.load
                    (i32.const 4372))
                  (i32.const 4))
                (then
                  (set_local $l2
                    (i32.const 0)))
                (else
                  (block $B79
                    (block $B80
                      (block $B81
                        (br_if $B81
                          (i32.eqz
                            (tee_local $l0
                              (i32.load
                                (i32.const 3952)))))
                        (set_local $l1
                          (i32.const 4376))
                        (loop $L82
                          (block $B83
                            (if $I84
                              (i32.le_u
                                (tee_local $l8
                                  (i32.load
                                    (get_local $l1)))
                                (get_local $l0))
                              (then
                                (br_if $B83
                                  (i32.gt_u
                                    (i32.add
                                      (get_local $l8)
                                      (i32.load
                                        (tee_local $l8
                                          (i32.add
                                            (get_local $l1)
                                            (i32.const 4)))))
                                    (get_local $l0)))))
                            (br_if $L82
                              (tee_local $l1
                                (i32.load offset=8
                                  (get_local $l1))))
                            (br $B81)))
                        (if $I85
                          (i32.lt_u
                            (tee_local $l2
                              (i32.and
                                (i32.sub
                                  (get_local $l5)
                                  (get_local $l2))
                                (get_local $l6)))
                            (i32.const 2147483647))
                          (then
                            (if $I86
                              (i32.eq
                                (tee_local $l0
                                  (call $f16
                                    (get_local $l2)))
                                (i32.add
                                  (i32.load
                                    (get_local $l1))
                                  (i32.load
                                    (get_local $l8))))
                              (then
                                (br_if $B77
                                  (i32.ne
                                    (get_local $l0)
                                    (i32.const -1))))
                              (else
                                (br $B80))))
                          (else
                            (set_local $l2
                              (i32.const 0))))
                        (br $B79))
                      (if $I87
                        (i32.eq
                          (tee_local $l0
                            (call $f16
                              (i32.const 0)))
                          (i32.const -1))
                        (then
                          (set_local $l2
                            (i32.const 0)))
                        (else
                          (set_local $l1
                            (i32.add
                              (tee_local $l2
                                (i32.add
                                  (select
                                    (i32.sub
                                      (i32.and
                                        (i32.add
                                          (tee_local $l1
                                            (i32.add
                                              (tee_local $l2
                                                (i32.load
                                                  (i32.const 4404)))
                                              (i32.const -1)))
                                          (get_local $l0))
                                        (i32.sub
                                          (i32.const 0)
                                          (get_local $l2)))
                                      (get_local $l0))
                                    (i32.const 0)
                                    (i32.and
                                      (get_local $l1)
                                      (get_local $l0)))
                                  (get_local $l3)))
                              (tee_local $l5
                                (i32.load
                                  (i32.const 4360)))))
                          (if $I88
                            (i32.and
                              (i32.gt_u
                                (get_local $l2)
                                (get_local $p0))
                              (i32.lt_u
                                (get_local $l2)
                                (i32.const 2147483647)))
                            (then
                              (if $I89
                                (tee_local $l6
                                  (i32.load
                                    (i32.const 4368)))
                                (then
                                  (if $I90
                                    (i32.or
                                      (i32.le_u
                                        (get_local $l1)
                                        (get_local $l5))
                                      (i32.gt_u
                                        (get_local $l1)
                                        (get_local $l6)))
                                    (then
                                      (set_local $l2
                                        (i32.const 0))
                                      (br $B79)))))
                              (br_if $B77
                                (i32.eq
                                  (tee_local $l1
                                    (call $f16
                                      (get_local $l2)))
                                  (get_local $l0)))
                              (set_local $l0
                                (get_local $l1))
                              (br $B80))
                            (else
                              (set_local $l2
                                (i32.const 0))))))
                      (br $B79))
                    (if $I91
                      (i32.eqz
                        (i32.and
                          (i32.gt_u
                            (get_local $l7)
                            (get_local $l2))
                          (i32.and
                            (i32.lt_u
                              (get_local $l2)
                              (i32.const 2147483647))
                            (i32.ne
                              (get_local $l0)
                              (i32.const -1)))))
                      (then
                        (if $I92
                          (i32.eq
                            (get_local $l0)
                            (i32.const -1))
                          (then
                            (set_local $l2
                              (i32.const 0))
                            (br $B79))
                          (else
                            (br $B77)))
                        (unreachable)))
                    (br_if $B77
                      (i32.ge_u
                        (tee_local $l1
                          (i32.and
                            (i32.add
                              (i32.sub
                                (get_local $l4)
                                (get_local $l2))
                              (tee_local $l1
                                (i32.load
                                  (i32.const 4408))))
                            (i32.sub
                              (i32.const 0)
                              (get_local $l1))))
                        (i32.const 2147483647)))
                    (set_local $l4
                      (i32.sub
                        (i32.const 0)
                        (get_local $l2)))
                    (if $I93
                      (i32.eq
                        (call $f16
                          (get_local $l1))
                        (i32.const -1))
                      (then
                        (drop
                          (call $f16
                            (get_local $l4)))
                        (set_local $l2
                          (i32.const 0)))
                      (else
                        (set_local $l2
                          (i32.add
                            (get_local $l1)
                            (get_local $l2)))
                        (br $B77))))
                  (i32.store
                    (i32.const 4372)
                    (i32.or
                      (i32.load
                        (i32.const 4372))
                      (i32.const 4)))))
              (if $I94
                (i32.lt_u
                  (get_local $l3)
                  (i32.const 2147483647))
                (then
                  (set_local $l0
                    (call $f16
                      (get_local $l3)))
                  (set_local $l3
                    (i32.gt_u
                      (tee_local $l4
                        (i32.sub
                          (tee_local $l1
                            (call $f16
                              (i32.const 0)))
                          (get_local $l0)))
                      (i32.add
                        (get_local $p0)
                        (i32.const 40))))
                  (set_local $l2
                    (select
                      (get_local $l4)
                      (get_local $l2)
                      (get_local $l3)))
                  (br_if $B77
                    (i32.eqz
                      (i32.or
                        (i32.or
                          (i32.eq
                            (get_local $l0)
                            (i32.const -1))
                          (i32.xor
                            (get_local $l3)
                            (i32.const 1)))
                        (i32.xor
                          (i32.and
                            (i32.lt_u
                              (get_local $l0)
                              (get_local $l1))
                            (i32.and
                              (i32.ne
                                (get_local $l0)
                                (i32.const -1))
                              (i32.ne
                                (get_local $l1)
                                (i32.const -1))))
                          (i32.const 1)))))))
              (br $B76))
            (i32.store
              (i32.const 4360)
              (tee_local $l1
                (i32.add
                  (i32.load
                    (i32.const 4360))
                  (get_local $l2))))
            (if $I95
              (i32.gt_u
                (get_local $l1)
                (i32.load
                  (i32.const 4364)))
              (then
                (i32.store
                  (i32.const 4364)
                  (get_local $l1))))
            (block $B96
              (if $I97
                (tee_local $l5
                  (i32.load
                    (i32.const 3952)))
                (then
                  (set_local $l1
                    (i32.const 4376))
                  (block $B98
                    (block $B99
                      (loop $L100
                        (br_if $B99
                          (i32.eq
                            (get_local $l0)
                            (i32.add
                              (tee_local $l3
                                (i32.load
                                  (get_local $l1)))
                              (tee_local $l6
                                (i32.load
                                  (tee_local $l4
                                    (i32.add
                                      (get_local $l1)
                                      (i32.const 4))))))))
                        (br_if $L100
                          (tee_local $l1
                            (i32.load offset=8
                              (get_local $l1)))))
                      (br $B98))
                    (if $I101
                      (i32.eqz
                        (i32.and
                          (i32.load offset=12
                            (get_local $l1))
                          (i32.const 8)))
                      (then
                        (if $I102
                          (i32.and
                            (i32.gt_u
                              (get_local $l0)
                              (get_local $l5))
                            (i32.le_u
                              (get_local $l3)
                              (get_local $l5)))
                          (then
                            (i32.store
                              (get_local $l4)
                              (i32.add
                                (get_local $l6)
                                (get_local $l2)))
                            (set_local $l0
                              (i32.add
                                (get_local $l5)
                                (tee_local $l1
                                  (select
                                    (i32.and
                                      (i32.sub
                                        (i32.const 0)
                                        (tee_local $l0
                                          (i32.add
                                            (get_local $l5)
                                            (i32.const 8))))
                                      (i32.const 7))
                                    (i32.const 0)
                                    (i32.and
                                      (get_local $l0)
                                      (i32.const 7))))))
                            (set_local $l2
                              (i32.sub
                                (tee_local $l3
                                  (i32.add
                                    (i32.load
                                      (i32.const 3940))
                                    (get_local $l2)))
                                (get_local $l1)))
                            (i32.store
                              (i32.const 3952)
                              (get_local $l0))
                            (i32.store
                              (i32.const 3940)
                              (get_local $l2))
                            (i32.store offset=4
                              (get_local $l0)
                              (i32.or
                                (get_local $l2)
                                (i32.const 1)))
                            (i32.store offset=4
                              (i32.add
                                (get_local $l5)
                                (get_local $l3))
                              (i32.const 40))
                            (i32.store
                              (i32.const 3956)
                              (i32.load
                                (i32.const 4416)))
                            (br $B96))))))
                  (if $I103
                    (i32.lt_u
                      (get_local $l0)
                      (i32.load
                        (i32.const 3944)))
                    (then
                      (i32.store
                        (i32.const 3944)
                        (get_local $l0))))
                  (set_local $l3
                    (i32.add
                      (get_local $l0)
                      (get_local $l2)))
                  (set_local $l1
                    (i32.const 4376))
                  (block $B104
                    (block $B105
                      (loop $L106
                        (br_if $B105
                          (i32.eq
                            (i32.load
                              (get_local $l1))
                            (get_local $l3)))
                        (br_if $L106
                          (tee_local $l1
                            (i32.load offset=8
                              (get_local $l1))))
                        (set_local $l1
                          (i32.const 4376)))
                      (br $B104))
                    (if $I107
                      (i32.and
                        (i32.load offset=12
                          (get_local $l1))
                        (i32.const 8))
                      (then
                        (set_local $l1
                          (i32.const 4376)))
                      (else
                        (i32.store
                          (get_local $l1)
                          (get_local $l0))
                        (i32.store
                          (tee_local $l1
                            (i32.add
                              (get_local $l1)
                              (i32.const 4)))
                          (i32.add
                            (i32.load
                              (get_local $l1))
                            (get_local $l2)))
                        (set_local $l6
                          (i32.add
                            (tee_local $l7
                              (i32.add
                                (get_local $l0)
                                (select
                                  (i32.and
                                    (i32.sub
                                      (i32.const 0)
                                      (tee_local $l0
                                        (i32.add
                                          (get_local $l0)
                                          (i32.const 8))))
                                    (i32.const 7))
                                  (i32.const 0)
                                  (i32.and
                                    (get_local $l0)
                                    (i32.const 7)))))
                            (get_local $p0)))
                        (set_local $l4
                          (i32.sub
                            (i32.sub
                              (tee_local $l3
                                (i32.add
                                  (get_local $l3)
                                  (select
                                    (i32.and
                                      (i32.sub
                                        (i32.const 0)
                                        (tee_local $l0
                                          (i32.add
                                            (get_local $l3)
                                            (i32.const 8))))
                                      (i32.const 7))
                                    (i32.const 0)
                                    (i32.and
                                      (get_local $l0)
                                      (i32.const 7)))))
                              (get_local $l7))
                            (get_local $p0)))
                        (i32.store offset=4
                          (get_local $l7)
                          (i32.or
                            (get_local $p0)
                            (i32.const 3)))
                        (block $B108
                          (if $I109
                            (i32.eq
                              (get_local $l5)
                              (get_local $l3))
                            (then
                              (i32.store
                                (i32.const 3940)
                                (tee_local $p0
                                  (i32.add
                                    (i32.load
                                      (i32.const 3940))
                                    (get_local $l4))))
                              (i32.store
                                (i32.const 3952)
                                (get_local $l6))
                              (i32.store offset=4
                                (get_local $l6)
                                (i32.or
                                  (get_local $p0)
                                  (i32.const 1))))
                            (else
                              (if $I110
                                (i32.eq
                                  (i32.load
                                    (i32.const 3948))
                                  (get_local $l3))
                                (then
                                  (i32.store
                                    (i32.const 3936)
                                    (tee_local $p0
                                      (i32.add
                                        (i32.load
                                          (i32.const 3936))
                                        (get_local $l4))))
                                  (i32.store
                                    (i32.const 3948)
                                    (get_local $l6))
                                  (i32.store offset=4
                                    (get_local $l6)
                                    (i32.or
                                      (get_local $p0)
                                      (i32.const 1)))
                                  (i32.store
                                    (i32.add
                                      (get_local $l6)
                                      (get_local $p0))
                                    (get_local $p0))
                                  (br $B108)))
                              (set_local $l3
                                (if $I111 (result i32)
                                  (i32.eq
                                    (i32.and
                                      (tee_local $p0
                                        (i32.load offset=4
                                          (get_local $l3)))
                                      (i32.const 3))
                                    (i32.const 1))
                                  (then
                                    (set_local $l8
                                      (i32.and
                                        (get_local $p0)
                                        (i32.const -8)))
                                    (set_local $l2
                                      (i32.shr_u
                                        (get_local $p0)
                                        (i32.const 3)))
                                    (block $B112
                                      (if $I113
                                        (i32.lt_u
                                          (get_local $p0)
                                          (i32.const 256))
                                        (then
                                          (if $I114
                                            (i32.eq
                                              (tee_local $p0
                                                (i32.load offset=12
                                                  (get_local $l3)))
                                              (tee_local $l0
                                                (i32.load offset=8
                                                  (get_local $l3))))
                                            (then
                                              (i32.store
                                                (i32.const 3928)
                                                (i32.and
                                                  (i32.load
                                                    (i32.const 3928))
                                                  (i32.xor
                                                    (i32.shl
                                                      (i32.const 1)
                                                      (get_local $l2))
                                                    (i32.const -1)))))
                                            (else
                                              (i32.store offset=12
                                                (get_local $l0)
                                                (get_local $p0))
                                              (i32.store offset=8
                                                (get_local $p0)
                                                (get_local $l0)))))
                                        (else
                                          (set_local $l5
                                            (i32.load offset=24
                                              (get_local $l3)))
                                          (block $B115
                                            (if $I116
                                              (i32.eq
                                                (tee_local $p0
                                                  (i32.load offset=12
                                                    (get_local $l3)))
                                                (get_local $l3))
                                              (then
                                                (if $I117
                                                  (tee_local $p0
                                                    (i32.load
                                                      (tee_local $l2
                                                        (i32.add
                                                          (tee_local $l0
                                                            (i32.add
                                                              (get_local $l3)
                                                              (i32.const 16)))
                                                          (i32.const 4)))))
                                                  (then
                                                    (set_local $l0
                                                      (get_local $l2)))
                                                  (else
                                                    (if $I118
                                                      (i32.eqz
                                                        (tee_local $p0
                                                          (i32.load
                                                            (get_local $l0))))
                                                      (then
                                                        (set_local $p0
                                                          (i32.const 0))
                                                        (br $B115)))))
                                                (loop $L119
                                                  (if $I120
                                                    (tee_local $l1
                                                      (i32.load
                                                        (tee_local $l2
                                                          (i32.add
                                                            (get_local $p0)
                                                            (i32.const 20)))))
                                                    (then
                                                      (set_local $p0
                                                        (get_local $l1))
                                                      (set_local $l0
                                                        (get_local $l2))
                                                      (br $L119)))
                                                  (if $I121
                                                    (tee_local $l1
                                                      (i32.load
                                                        (tee_local $l2
                                                          (i32.add
                                                            (get_local $p0)
                                                            (i32.const 16)))))
                                                    (then
                                                      (set_local $p0
                                                        (get_local $l1))
                                                      (set_local $l0
                                                        (get_local $l2))
                                                      (br $L119))))
                                                (i32.store
                                                  (get_local $l0)
                                                  (i32.const 0)))
                                              (else
                                                (i32.store offset=12
                                                  (tee_local $l0
                                                    (i32.load offset=8
                                                      (get_local $l3)))
                                                  (get_local $p0))
                                                (i32.store offset=8
                                                  (get_local $p0)
                                                  (get_local $l0)))))
                                          (br_if $B112
                                            (i32.eqz
                                              (get_local $l5)))
                                          (block $B122
                                            (if $I123
                                              (i32.eq
                                                (i32.load
                                                  (tee_local $l2
                                                    (i32.add
                                                      (i32.shl
                                                        (tee_local $l0
                                                          (i32.load offset=28
                                                            (get_local $l3)))
                                                        (i32.const 2))
                                                      (i32.const 4232))))
                                                (get_local $l3))
                                              (then
                                                (i32.store
                                                  (get_local $l2)
                                                  (get_local $p0))
                                                (br_if $B122
                                                  (get_local $p0))
                                                (i32.store
                                                  (i32.const 3932)
                                                  (i32.and
                                                    (i32.load
                                                      (i32.const 3932))
                                                    (i32.xor
                                                      (i32.shl
                                                        (i32.const 1)
                                                        (get_local $l0))
                                                      (i32.const -1))))
                                                (br $B112))
                                              (else
                                                (i32.store
                                                  (i32.add
                                                    (tee_local $l0
                                                      (i32.add
                                                        (get_local $l5)
                                                        (i32.const 16)))
                                                    (i32.shl
                                                      (i32.ne
                                                        (i32.load
                                                          (get_local $l0))
                                                        (get_local $l3))
                                                      (i32.const 2)))
                                                  (get_local $p0))
                                                (br_if $B112
                                                  (i32.eqz
                                                    (get_local $p0))))))
                                          (i32.store offset=24
                                            (get_local $p0)
                                            (get_local $l5))
                                          (if $I124
                                            (tee_local $l0
                                              (i32.load
                                                (tee_local $l2
                                                  (i32.add
                                                    (get_local $l3)
                                                    (i32.const 16)))))
                                            (then
                                              (i32.store offset=16
                                                (get_local $p0)
                                                (get_local $l0))
                                              (i32.store offset=24
                                                (get_local $l0)
                                                (get_local $p0))))
                                          (br_if $B112
                                            (i32.eqz
                                              (tee_local $l0
                                                (i32.load offset=4
                                                  (get_local $l2)))))
                                          (i32.store offset=20
                                            (get_local $p0)
                                            (get_local $l0))
                                          (i32.store offset=24
                                            (get_local $l0)
                                            (get_local $p0)))))
                                    (set_local $p0
                                      (i32.add
                                        (get_local $l3)
                                        (get_local $l8)))
                                    (i32.add
                                      (get_local $l8)
                                      (get_local $l4)))
                                  (else
                                    (set_local $p0
                                      (get_local $l3))
                                    (get_local $l4))))
                              (i32.store
                                (tee_local $p0
                                  (i32.add
                                    (get_local $p0)
                                    (i32.const 4)))
                                (i32.and
                                  (i32.load
                                    (get_local $p0))
                                  (i32.const -2)))
                              (i32.store offset=4
                                (get_local $l6)
                                (i32.or
                                  (get_local $l3)
                                  (i32.const 1)))
                              (i32.store
                                (i32.add
                                  (get_local $l6)
                                  (get_local $l3))
                                (get_local $l3))
                              (set_local $l0
                                (i32.shr_u
                                  (get_local $l3)
                                  (i32.const 3)))
                              (if $I125
                                (i32.lt_u
                                  (get_local $l3)
                                  (i32.const 256))
                                (then
                                  (set_local $p0
                                    (i32.add
                                      (i32.shl
                                        (get_local $l0)
                                        (i32.const 3))
                                      (i32.const 3968)))
                                  (set_local $l0
                                    (if $I126 (result i32)
                                      (i32.and
                                        (tee_local $l2
                                          (i32.load
                                            (i32.const 3928)))
                                        (tee_local $l0
                                          (i32.shl
                                            (i32.const 1)
                                            (get_local $l0))))
                                      (then
                                        (i32.load
                                          (tee_local $l2
                                            (i32.add
                                              (get_local $p0)
                                              (i32.const 8)))))
                                      (else
                                        (i32.store
                                          (i32.const 3928)
                                          (i32.or
                                            (get_local $l2)
                                            (get_local $l0)))
                                        (set_local $l2
                                          (i32.add
                                            (get_local $p0)
                                            (i32.const 8)))
                                        (get_local $p0))))
                                  (i32.store
                                    (get_local $l2)
                                    (get_local $l6))
                                  (i32.store offset=12
                                    (get_local $l0)
                                    (get_local $l6))
                                  (i32.store offset=8
                                    (get_local $l6)
                                    (get_local $l0))
                                  (i32.store offset=12
                                    (get_local $l6)
                                    (get_local $p0))
                                  (br $B108)))
                              (set_local $l2
                                (i32.add
                                  (i32.shl
                                    (tee_local $p0
                                      (block $B127 (result i32)
                                        (if $I128 (result i32)
                                          (tee_local $p0
                                            (i32.shr_u
                                              (get_local $l3)
                                              (i32.const 8)))
                                          (then
                                            (drop
                                              (br_if $B127
                                                (i32.const 31)
                                                (i32.gt_u
                                                  (get_local $l3)
                                                  (i32.const 16777215))))
                                            (i32.or
                                              (i32.and
                                                (i32.shr_u
                                                  (get_local $l3)
                                                  (i32.add
                                                    (tee_local $p0
                                                      (i32.add
                                                        (i32.sub
                                                          (i32.const 14)
                                                          (i32.or
                                                            (i32.or
                                                              (tee_local $l2
                                                                (i32.and
                                                                  (i32.shr_u
                                                                    (i32.add
                                                                      (tee_local $l0
                                                                        (i32.shl
                                                                          (get_local $p0)
                                                                          (tee_local $p0
                                                                            (i32.and
                                                                              (i32.shr_u
                                                                                (i32.add
                                                                                  (get_local $p0)
                                                                                  (i32.const 1048320))
                                                                                (i32.const 16))
                                                                              (i32.const 8)))))
                                                                      (i32.const 520192))
                                                                    (i32.const 16))
                                                                  (i32.const 4)))
                                                              (get_local $p0))
                                                            (tee_local $l0
                                                              (i32.and
                                                                (i32.shr_u
                                                                  (i32.add
                                                                    (tee_local $p0
                                                                      (i32.shl
                                                                        (get_local $l0)
                                                                        (get_local $l2)))
                                                                    (i32.const 245760))
                                                                  (i32.const 16))
                                                                (i32.const 2)))))
                                                        (i32.shr_u
                                                          (i32.shl
                                                            (get_local $p0)
                                                            (get_local $l0))
                                                          (i32.const 15))))
                                                    (i32.const 7)))
                                                (i32.const 1))
                                              (i32.shl
                                                (get_local $p0)
                                                (i32.const 1))))
                                          (else
                                            (i32.const 0)))))
                                    (i32.const 2))
                                  (i32.const 4232)))
                              (i32.store offset=28
                                (get_local $l6)
                                (get_local $p0))
                              (i32.store offset=4
                                (tee_local $l0
                                  (i32.add
                                    (get_local $l6)
                                    (i32.const 16)))
                                (i32.const 0))
                              (i32.store
                                (get_local $l0)
                                (i32.const 0))
                              (if $I129
                                (i32.eqz
                                  (i32.and
                                    (tee_local $l0
                                      (i32.load
                                        (i32.const 3932)))
                                    (tee_local $l1
                                      (i32.shl
                                        (i32.const 1)
                                        (get_local $p0)))))
                                (then
                                  (i32.store
                                    (i32.const 3932)
                                    (i32.or
                                      (get_local $l0)
                                      (get_local $l1)))
                                  (i32.store
                                    (get_local $l2)
                                    (get_local $l6))
                                  (i32.store offset=24
                                    (get_local $l6)
                                    (get_local $l2))
                                  (i32.store offset=12
                                    (get_local $l6)
                                    (get_local $l6))
                                  (i32.store offset=8
                                    (get_local $l6)
                                    (get_local $l6))
                                  (br $B108)))
                              (set_local $l0
                                (i32.shl
                                  (get_local $l3)
                                  (select
                                    (i32.const 0)
                                    (i32.sub
                                      (i32.const 25)
                                      (i32.shr_u
                                        (get_local $p0)
                                        (i32.const 1)))
                                    (i32.eq
                                      (get_local $p0)
                                      (i32.const 31)))))
                              (set_local $p0
                                (i32.load
                                  (get_local $l2)))
                              (block $B130
                                (loop $L131
                                  (br_if $B130
                                    (i32.eq
                                      (i32.and
                                        (i32.load offset=4
                                          (get_local $p0))
                                        (i32.const -8))
                                      (get_local $l3)))
                                  (set_local $l2
                                    (i32.shl
                                      (get_local $l0)
                                      (i32.const 1)))
                                  (if $I132
                                    (tee_local $l1
                                      (i32.load
                                        (tee_local $l0
                                          (i32.add
                                            (i32.add
                                              (get_local $p0)
                                              (i32.const 16))
                                            (i32.shl
                                              (i32.shr_u
                                                (get_local $l0)
                                                (i32.const 31))
                                              (i32.const 2))))))
                                    (then
                                      (set_local $l0
                                        (get_local $l2))
                                      (set_local $p0
                                        (get_local $l1))
                                      (br $L131))))
                                (i32.store
                                  (get_local $l0)
                                  (get_local $l6))
                                (i32.store offset=24
                                  (get_local $l6)
                                  (get_local $p0))
                                (i32.store offset=12
                                  (get_local $l6)
                                  (get_local $l6))
                                (i32.store offset=8
                                  (get_local $l6)
                                  (get_local $l6))
                                (br $B108))
                              (i32.store offset=12
                                (tee_local $l2
                                  (i32.load
                                    (tee_local $l0
                                      (i32.add
                                        (get_local $p0)
                                        (i32.const 8)))))
                                (get_local $l6))
                              (i32.store
                                (get_local $l0)
                                (get_local $l6))
                              (i32.store offset=8
                                (get_local $l6)
                                (get_local $l2))
                              (i32.store offset=12
                                (get_local $l6)
                                (get_local $p0))
                              (i32.store offset=24
                                (get_local $l6)
                                (i32.const 0)))))
                        (set_global $g4
                          (get_local $l9))
                        (return
                          (i32.add
                            (get_local $l7)
                            (i32.const 8))))))
                  (loop $L133
                    (block $B134
                      (if $I135
                        (i32.le_u
                          (tee_local $l3
                            (i32.load
                              (get_local $l1)))
                          (get_local $l5))
                        (then
                          (br_if $B134
                            (i32.gt_u
                              (tee_local $l4
                                (i32.add
                                  (get_local $l3)
                                  (i32.load offset=4
                                    (get_local $l1))))
                              (get_local $l5)))))
                      (set_local $l1
                        (i32.load offset=8
                          (get_local $l1)))
                      (br $L133)))
                  (set_local $l1
                    (i32.add
                      (tee_local $l3
                        (i32.add
                          (get_local $l4)
                          (i32.const -47)))
                      (i32.const 8)))
                  (set_local $l3
                    (i32.add
                      (tee_local $l1
                        (select
                          (get_local $l5)
                          (tee_local $l1
                            (i32.add
                              (get_local $l3)
                              (select
                                (i32.and
                                  (i32.sub
                                    (i32.const 0)
                                    (get_local $l1))
                                  (i32.const 7))
                                (i32.const 0)
                                (i32.and
                                  (get_local $l1)
                                  (i32.const 7)))))
                          (i32.lt_u
                            (get_local $l1)
                            (tee_local $l7
                              (i32.add
                                (get_local $l5)
                                (i32.const 16))))))
                      (i32.const 8)))
                  (i32.store
                    (i32.const 3952)
                    (tee_local $l8
                      (i32.add
                        (get_local $l0)
                        (tee_local $l6
                          (select
                            (i32.and
                              (i32.sub
                                (i32.const 0)
                                (tee_local $l6
                                  (i32.add
                                    (get_local $l0)
                                    (i32.const 8))))
                              (i32.const 7))
                            (i32.const 0)
                            (i32.and
                              (get_local $l6)
                              (i32.const 7)))))))
                  (i32.store
                    (i32.const 3940)
                    (tee_local $l6
                      (i32.sub
                        (tee_local $l10
                          (i32.add
                            (get_local $l2)
                            (i32.const -40)))
                        (get_local $l6))))
                  (i32.store offset=4
                    (get_local $l8)
                    (i32.or
                      (get_local $l6)
                      (i32.const 1)))
                  (i32.store offset=4
                    (i32.add
                      (get_local $l0)
                      (get_local $l10))
                    (i32.const 40))
                  (i32.store
                    (i32.const 3956)
                    (i32.load
                      (i32.const 4416)))
                  (i32.store
                    (tee_local $l6
                      (i32.add
                        (get_local $l1)
                        (i32.const 4)))
                    (i32.const 27))
                  (i64.store align=4
                    (get_local $l3)
                    (i64.load align=4
                      (i32.const 4376)))
                  (i64.store offset=8 align=4
                    (get_local $l3)
                    (i64.load align=4
                      (i32.const 4384)))
                  (i32.store
                    (i32.const 4376)
                    (get_local $l0))
                  (i32.store
                    (i32.const 4380)
                    (get_local $l2))
                  (i32.store
                    (i32.const 4388)
                    (i32.const 0))
                  (i32.store
                    (i32.const 4384)
                    (get_local $l3))
                  (set_local $l0
                    (i32.add
                      (get_local $l1)
                      (i32.const 24)))
                  (loop $L136
                    (i32.store
                      (tee_local $l2
                        (i32.add
                          (get_local $l0)
                          (i32.const 4)))
                      (i32.const 7))
                    (if $I137
                      (i32.lt_u
                        (i32.add
                          (get_local $l0)
                          (i32.const 8))
                        (get_local $l4))
                      (then
                        (set_local $l0
                          (get_local $l2))
                        (br $L136))))
                  (if $I138
                    (i32.ne
                      (get_local $l1)
                      (get_local $l5))
                    (then
                      (i32.store
                        (get_local $l6)
                        (i32.and
                          (i32.load
                            (get_local $l6))
                          (i32.const -2)))
                      (i32.store offset=4
                        (get_local $l5)
                        (i32.or
                          (tee_local $l4
                            (i32.sub
                              (get_local $l1)
                              (get_local $l5)))
                          (i32.const 1)))
                      (i32.store
                        (get_local $l1)
                        (get_local $l4))
                      (set_local $l2
                        (i32.shr_u
                          (get_local $l4)
                          (i32.const 3)))
                      (if $I139
                        (i32.lt_u
                          (get_local $l4)
                          (i32.const 256))
                        (then
                          (set_local $l0
                            (i32.add
                              (i32.shl
                                (get_local $l2)
                                (i32.const 3))
                              (i32.const 3968)))
                          (set_local $l2
                            (if $I140 (result i32)
                              (i32.and
                                (tee_local $l1
                                  (i32.load
                                    (i32.const 3928)))
                                (tee_local $l2
                                  (i32.shl
                                    (i32.const 1)
                                    (get_local $l2))))
                              (then
                                (i32.load
                                  (tee_local $l1
                                    (i32.add
                                      (get_local $l0)
                                      (i32.const 8)))))
                              (else
                                (i32.store
                                  (i32.const 3928)
                                  (i32.or
                                    (get_local $l1)
                                    (get_local $l2)))
                                (set_local $l1
                                  (i32.add
                                    (get_local $l0)
                                    (i32.const 8)))
                                (get_local $l0))))
                          (i32.store
                            (get_local $l1)
                            (get_local $l5))
                          (i32.store offset=12
                            (get_local $l2)
                            (get_local $l5))
                          (i32.store offset=8
                            (get_local $l5)
                            (get_local $l2))
                          (i32.store offset=12
                            (get_local $l5)
                            (get_local $l0))
                          (br $B96)))
                      (set_local $l1
                        (i32.add
                          (i32.shl
                            (tee_local $l0
                              (if $I141 (result i32)
                                (tee_local $l0
                                  (i32.shr_u
                                    (get_local $l4)
                                    (i32.const 8)))
                                (then
                                  (if $I142 (result i32)
                                    (i32.gt_u
                                      (get_local $l4)
                                      (i32.const 16777215))
                                    (then
                                      (i32.const 31))
                                    (else
                                      (i32.or
                                        (i32.and
                                          (i32.shr_u
                                            (get_local $l4)
                                            (i32.add
                                              (tee_local $l0
                                                (i32.add
                                                  (i32.sub
                                                    (i32.const 14)
                                                    (i32.or
                                                      (i32.or
                                                        (tee_local $l1
                                                          (i32.and
                                                            (i32.shr_u
                                                              (i32.add
                                                                (tee_local $l2
                                                                  (i32.shl
                                                                    (get_local $l0)
                                                                    (tee_local $l0
                                                                      (i32.and
                                                                        (i32.shr_u
                                                                          (i32.add
                                                                            (get_local $l0)
                                                                            (i32.const 1048320))
                                                                          (i32.const 16))
                                                                        (i32.const 8)))))
                                                                (i32.const 520192))
                                                              (i32.const 16))
                                                            (i32.const 4)))
                                                        (get_local $l0))
                                                      (tee_local $l2
                                                        (i32.and
                                                          (i32.shr_u
                                                            (i32.add
                                                              (tee_local $l0
                                                                (i32.shl
                                                                  (get_local $l2)
                                                                  (get_local $l1)))
                                                              (i32.const 245760))
                                                            (i32.const 16))
                                                          (i32.const 2)))))
                                                  (i32.shr_u
                                                    (i32.shl
                                                      (get_local $l0)
                                                      (get_local $l2))
                                                    (i32.const 15))))
                                              (i32.const 7)))
                                          (i32.const 1))
                                        (i32.shl
                                          (get_local $l0)
                                          (i32.const 1))))))
                                (else
                                  (i32.const 0))))
                            (i32.const 2))
                          (i32.const 4232)))
                      (i32.store offset=28
                        (get_local $l5)
                        (get_local $l0))
                      (i32.store offset=20
                        (get_local $l5)
                        (i32.const 0))
                      (i32.store
                        (get_local $l7)
                        (i32.const 0))
                      (if $I143
                        (i32.eqz
                          (i32.and
                            (tee_local $l2
                              (i32.load
                                (i32.const 3932)))
                            (tee_local $l3
                              (i32.shl
                                (i32.const 1)
                                (get_local $l0)))))
                        (then
                          (i32.store
                            (i32.const 3932)
                            (i32.or
                              (get_local $l2)
                              (get_local $l3)))
                          (i32.store
                            (get_local $l1)
                            (get_local $l5))
                          (i32.store offset=24
                            (get_local $l5)
                            (get_local $l1))
                          (i32.store offset=12
                            (get_local $l5)
                            (get_local $l5))
                          (i32.store offset=8
                            (get_local $l5)
                            (get_local $l5))
                          (br $B96)))
                      (set_local $l2
                        (i32.shl
                          (get_local $l4)
                          (select
                            (i32.const 0)
                            (i32.sub
                              (i32.const 25)
                              (i32.shr_u
                                (get_local $l0)
                                (i32.const 1)))
                            (i32.eq
                              (get_local $l0)
                              (i32.const 31)))))
                      (set_local $l0
                        (i32.load
                          (get_local $l1)))
                      (block $B144
                        (loop $L145
                          (br_if $B144
                            (i32.eq
                              (i32.and
                                (i32.load offset=4
                                  (get_local $l0))
                                (i32.const -8))
                              (get_local $l4)))
                          (set_local $l1
                            (i32.shl
                              (get_local $l2)
                              (i32.const 1)))
                          (if $I146
                            (tee_local $l3
                              (i32.load
                                (tee_local $l2
                                  (i32.add
                                    (i32.add
                                      (get_local $l0)
                                      (i32.const 16))
                                    (i32.shl
                                      (i32.shr_u
                                        (get_local $l2)
                                        (i32.const 31))
                                      (i32.const 2))))))
                            (then
                              (set_local $l2
                                (get_local $l1))
                              (set_local $l0
                                (get_local $l3))
                              (br $L145))))
                        (i32.store
                          (get_local $l2)
                          (get_local $l5))
                        (i32.store offset=24
                          (get_local $l5)
                          (get_local $l0))
                        (i32.store offset=12
                          (get_local $l5)
                          (get_local $l5))
                        (i32.store offset=8
                          (get_local $l5)
                          (get_local $l5))
                        (br $B96))
                      (i32.store offset=12
                        (tee_local $l1
                          (i32.load
                            (tee_local $l2
                              (i32.add
                                (get_local $l0)
                                (i32.const 8)))))
                        (get_local $l5))
                      (i32.store
                        (get_local $l2)
                        (get_local $l5))
                      (i32.store offset=8
                        (get_local $l5)
                        (get_local $l1))
                      (i32.store offset=12
                        (get_local $l5)
                        (get_local $l0))
                      (i32.store offset=24
                        (get_local $l5)
                        (i32.const 0)))))
                (else
                  (if $I147
                    (i32.or
                      (i32.eqz
                        (tee_local $l1
                          (i32.load
                            (i32.const 3944))))
                      (i32.lt_u
                        (get_local $l0)
                        (get_local $l1)))
                    (then
                      (i32.store
                        (i32.const 3944)
                        (get_local $l0))))
                  (i32.store
                    (i32.const 4376)
                    (get_local $l0))
                  (i32.store
                    (i32.const 4380)
                    (get_local $l2))
                  (i32.store
                    (i32.const 4388)
                    (i32.const 0))
                  (i32.store
                    (i32.const 3964)
                    (i32.load
                      (i32.const 4400)))
                  (i32.store
                    (i32.const 3960)
                    (i32.const -1))
                  (i32.store
                    (i32.const 3980)
                    (i32.const 3968))
                  (i32.store
                    (i32.const 3976)
                    (i32.const 3968))
                  (i32.store
                    (i32.const 3988)
                    (i32.const 3976))
                  (i32.store
                    (i32.const 3984)
                    (i32.const 3976))
                  (i32.store
                    (i32.const 3996)
                    (i32.const 3984))
                  (i32.store
                    (i32.const 3992)
                    (i32.const 3984))
                  (i32.store
                    (i32.const 4004)
                    (i32.const 3992))
                  (i32.store
                    (i32.const 4000)
                    (i32.const 3992))
                  (i32.store
                    (i32.const 4012)
                    (i32.const 4000))
                  (i32.store
                    (i32.const 4008)
                    (i32.const 4000))
                  (i32.store
                    (i32.const 4020)
                    (i32.const 4008))
                  (i32.store
                    (i32.const 4016)
                    (i32.const 4008))
                  (i32.store
                    (i32.const 4028)
                    (i32.const 4016))
                  (i32.store
                    (i32.const 4024)
                    (i32.const 4016))
                  (i32.store
                    (i32.const 4036)
                    (i32.const 4024))
                  (i32.store
                    (i32.const 4032)
                    (i32.const 4024))
                  (i32.store
                    (i32.const 4044)
                    (i32.const 4032))
                  (i32.store
                    (i32.const 4040)
                    (i32.const 4032))
                  (i32.store
                    (i32.const 4052)
                    (i32.const 4040))
                  (i32.store
                    (i32.const 4048)
                    (i32.const 4040))
                  (i32.store
                    (i32.const 4060)
                    (i32.const 4048))
                  (i32.store
                    (i32.const 4056)
                    (i32.const 4048))
                  (i32.store
                    (i32.const 4068)
                    (i32.const 4056))
                  (i32.store
                    (i32.const 4064)
                    (i32.const 4056))
                  (i32.store
                    (i32.const 4076)
                    (i32.const 4064))
                  (i32.store
                    (i32.const 4072)
                    (i32.const 4064))
                  (i32.store
                    (i32.const 4084)
                    (i32.const 4072))
                  (i32.store
                    (i32.const 4080)
                    (i32.const 4072))
                  (i32.store
                    (i32.const 4092)
                    (i32.const 4080))
                  (i32.store
                    (i32.const 4088)
                    (i32.const 4080))
                  (i32.store
                    (i32.const 4100)
                    (i32.const 4088))
                  (i32.store
                    (i32.const 4096)
                    (i32.const 4088))
                  (i32.store
                    (i32.const 4108)
                    (i32.const 4096))
                  (i32.store
                    (i32.const 4104)
                    (i32.const 4096))
                  (i32.store
                    (i32.const 4116)
                    (i32.const 4104))
                  (i32.store
                    (i32.const 4112)
                    (i32.const 4104))
                  (i32.store
                    (i32.const 4124)
                    (i32.const 4112))
                  (i32.store
                    (i32.const 4120)
                    (i32.const 4112))
                  (i32.store
                    (i32.const 4132)
                    (i32.const 4120))
                  (i32.store
                    (i32.const 4128)
                    (i32.const 4120))
                  (i32.store
                    (i32.const 4140)
                    (i32.const 4128))
                  (i32.store
                    (i32.const 4136)
                    (i32.const 4128))
                  (i32.store
                    (i32.const 4148)
                    (i32.const 4136))
                  (i32.store
                    (i32.const 4144)
                    (i32.const 4136))
                  (i32.store
                    (i32.const 4156)
                    (i32.const 4144))
                  (i32.store
                    (i32.const 4152)
                    (i32.const 4144))
                  (i32.store
                    (i32.const 4164)
                    (i32.const 4152))
                  (i32.store
                    (i32.const 4160)
                    (i32.const 4152))
                  (i32.store
                    (i32.const 4172)
                    (i32.const 4160))
                  (i32.store
                    (i32.const 4168)
                    (i32.const 4160))
                  (i32.store
                    (i32.const 4180)
                    (i32.const 4168))
                  (i32.store
                    (i32.const 4176)
                    (i32.const 4168))
                  (i32.store
                    (i32.const 4188)
                    (i32.const 4176))
                  (i32.store
                    (i32.const 4184)
                    (i32.const 4176))
                  (i32.store
                    (i32.const 4196)
                    (i32.const 4184))
                  (i32.store
                    (i32.const 4192)
                    (i32.const 4184))
                  (i32.store
                    (i32.const 4204)
                    (i32.const 4192))
                  (i32.store
                    (i32.const 4200)
                    (i32.const 4192))
                  (i32.store
                    (i32.const 4212)
                    (i32.const 4200))
                  (i32.store
                    (i32.const 4208)
                    (i32.const 4200))
                  (i32.store
                    (i32.const 4220)
                    (i32.const 4208))
                  (i32.store
                    (i32.const 4216)
                    (i32.const 4208))
                  (i32.store
                    (i32.const 4228)
                    (i32.const 4216))
                  (i32.store
                    (i32.const 4224)
                    (i32.const 4216))
                  (i32.store
                    (i32.const 3952)
                    (tee_local $l3
                      (i32.add
                        (get_local $l0)
                        (tee_local $l1
                          (select
                            (i32.and
                              (i32.sub
                                (i32.const 0)
                                (tee_local $l1
                                  (i32.add
                                    (get_local $l0)
                                    (i32.const 8))))
                              (i32.const 7))
                            (i32.const 0)
                            (i32.and
                              (get_local $l1)
                              (i32.const 7)))))))
                  (i32.store
                    (i32.const 3940)
                    (tee_local $l1
                      (i32.sub
                        (tee_local $l2
                          (i32.add
                            (get_local $l2)
                            (i32.const -40)))
                        (get_local $l1))))
                  (i32.store offset=4
                    (get_local $l3)
                    (i32.or
                      (get_local $l1)
                      (i32.const 1)))
                  (i32.store offset=4
                    (i32.add
                      (get_local $l0)
                      (get_local $l2))
                    (i32.const 40))
                  (i32.store
                    (i32.const 3956)
                    (i32.load
                      (i32.const 4416))))))
            (if $I148
              (i32.gt_u
                (tee_local $l0
                  (i32.load
                    (i32.const 3940)))
                (get_local $p0))
              (then
                (i32.store
                  (i32.const 3940)
                  (tee_local $l2
                    (i32.sub
                      (get_local $l0)
                      (get_local $p0))))
                (br $B1))))
          (i32.store
            (i32.const 4488)
            (i32.const 12))
          (set_global $g4
            (get_local $l9))
          (return
            (i32.const 0)))
        (set_global $g4
          (get_local $l9))
        (return
          (i32.const 0)))
      (i32.store
        (i32.const 3952)
        (tee_local $l1
          (i32.add
            (tee_local $l0
              (i32.load
                (i32.const 3952)))
            (get_local $p0))))
      (i32.store offset=4
        (get_local $l1)
        (i32.or
          (get_local $l2)
          (i32.const 1)))
      (i32.store offset=4
        (get_local $l0)
        (i32.or
          (get_local $p0)
          (i32.const 3))))
    (set_global $g4
      (get_local $l9))
    (i32.add
      (get_local $l0)
      (i32.const 8)))
  (func $f27 (type $t2) (param $p0 i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i64)
    (set_local $l2
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 32)))
    (set_local $l1
      (i32.add
        (get_local $l2)
        (i32.const 8)))
    (set_local $l3
      (call $f42
        (i32.const 0)
        (i32.const 167772160)
        (i32.const 3)
        (i32.const 34)
        (i32.const -1)
        (i32.const 0)))
    (i64.store
      (i32.const 3920)
      (i64.const 31))
    (set_local $l4
      (i32.eqz
        (get_local $p0)))
    (set_local $p0
      (i32.const 0))
    (loop $L0
      (if $I1
        (i32.ne
          (get_local $p0)
          (i32.const 20))
        (then
          (i32.store
            (get_local $l2)
            (tee_local $l0
              (i32.add
                (get_local $l3)
                (if $I2 (result i32)
                  (get_local $l4)
                  (then
                    (get_local $p0))
                  (else
                    (i64.store
                      (i32.const 3920)
                      (tee_local $l8
                        (i64.add
                          (i64.mul
                            (i64.load
                              (i32.const 3920))
                            (i64.const 6364136223846793005))
                          (i64.const 1))))
                    (i32.shl
                      (i32.rem_s
                        (i32.wrap/i64
                          (i64.shr_u
                            (get_local $l8)
                            (i64.const 33)))
                        (i32.const 20971520))
                      (i32.const 3)))))))
          (drop
            (call $f23
              (i32.const 1396)
              (get_local $l2)))
          (set_local $l5
            (call $f22
              (get_local $l0)))
          (set_local $l6
            (call $f22
              (get_local $l0)))
          (set_local $l7
            (call $f22
              (get_local $l0)))
          (set_local $l0
            (call $f22
              (get_local $l0)))
          (i32.store
            (get_local $l1)
            (get_local $l5))
          (i32.store offset=4
            (get_local $l1)
            (get_local $l6))
          (i32.store offset=8
            (get_local $l1)
            (get_local $l7))
          (i32.store offset=12
            (get_local $l1)
            (get_local $l0))
          (drop
            (call $f23
              (i32.const 1408)
              (get_local $l1)))
          (set_local $p0
            (i32.add
              (get_local $p0)
              (i32.const 1)))
          (br $L0))))
    (set_global $g4
      (get_local $l2)))
  (func $f28 (type $t1) (param $p0 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32)
    (set_local $l2
      (if $I0 (result i32)
        (i32.gt_s
          (i32.load offset=76
            (tee_local $l0
              (i32.load
                (i32.const 1024))))
          (i32.const -1))
        (then
          (i32.const 0))
        (else
          (i32.const 0))))
    (set_local $p0
      (block $B1 (result i32)
        (if $I2 (result i32)
          (i32.lt_s
            (i32.shr_s
              (i32.shl
                (i32.ne
                  (call $f44
                    (get_local $p0)
                    (i32.const 1)
                    (tee_local $p0
                      (call $f45
                        (get_local $p0)))
                    (tee_local $l1
                      (get_local $l0)))
                  (get_local $p0))
                (i32.const 31))
              (i32.const 31))
            (i32.const 0))
          (then
            (i32.const -1))
          (else
            (if $I3
              (i32.ne
                (i32.load8_s offset=75
                  (get_local $l0))
                (i32.const 10))
              (then
                (if $I4
                  (i32.lt_u
                    (tee_local $p0
                      (i32.load
                        (tee_local $l1
                          (i32.add
                            (get_local $l0)
                            (i32.const 20)))))
                    (i32.load offset=16
                      (get_local $l0)))
                  (then
                    (i32.store
                      (get_local $l1)
                      (i32.add
                        (get_local $p0)
                        (i32.const 1)))
                    (i32.store8
                      (get_local $p0)
                      (i32.const 10))
                    (br $B1
                      (i32.const 0))))))
            (i32.shr_s
              (call $f43
                (get_local $l0)
                (i32.const 10))
              (i32.const 31))))))
    (get_local $p0))
  (func $f29 (type $t1) (param $p0 i32) (result i32)
    (local $l0 i32) (local $l1 i32)
    (set_local $l0
      (i32.load8_s
        (tee_local $l1
          (i32.add
            (get_local $p0)
            (i32.const 74)))))
    (i32.store8
      (get_local $l1)
      (i32.or
        (i32.add
          (get_local $l0)
          (i32.const 255))
        (get_local $l0)))
    (if $I0 (result i32)
      (i32.and
        (tee_local $l0
          (i32.load
            (get_local $p0)))
        (i32.const 8))
      (then
        (i32.store
          (get_local $p0)
          (i32.or
            (get_local $l0)
            (i32.const 32)))
        (i32.const -1))
      (else
        (i32.store offset=8
          (get_local $p0)
          (i32.const 0))
        (i32.store offset=4
          (get_local $p0)
          (i32.const 0))
        (i32.store offset=28
          (get_local $p0)
          (tee_local $l0
            (i32.load offset=44
              (get_local $p0))))
        (i32.store offset=20
          (get_local $p0)
          (get_local $l0))
        (i32.store offset=16
          (get_local $p0)
          (i32.add
            (get_local $l0)
            (i32.load offset=48
              (get_local $p0))))
        (i32.const 0))))
  (func $f30 (type $t13) (param $p0 f64) (param $p1 i32) (result f64)
    (local $l0 i32) (local $l1 i64) (local $l2 i64)
    (block $B0
      (block $B1
        (block $B2
          (if $I3
            (tee_local $l0
              (i32.and
                (i32.wrap/i64
                  (tee_local $l2
                    (i64.shr_u
                      (tee_local $l1
                        (i64.reinterpret/f64
                          (get_local $p0)))
                      (i64.const 52))))
                (i32.const 2047)))
            (then
              (if $I4
                (i32.eq
                  (get_local $l0)
                  (i32.const 2047))
                (then
                  (br $B0))
                (else
                  (br $B1)))
              (unreachable)))
          (i32.store
            (get_local $p1)
            (if $I5 (result i32)
              (f64.ne
                (get_local $p0)
                (f64.const 0x0p+0 (;=0;)))
              (then
                (set_local $p0
                  (call $f30
                    (f64.mul
                      (get_local $p0)
                      (f64.const 0x1p+64 (;=1.84467e+19;)))
                    (get_local $p1)))
                (i32.add
                  (i32.load
                    (get_local $p1))
                  (i32.const -64)))
              (else
                (i32.const 0))))
          (br $B0)
          (unreachable))
        (unreachable)
        (unreachable))
      (i32.store
        (get_local $p1)
        (i32.add
          (i32.and
            (i32.wrap/i64
              (get_local $l2))
            (i32.const 2047))
          (i32.const -1022)))
      (set_local $p0
        (f64.reinterpret/i64
          (i64.or
            (i64.and
              (get_local $l1)
              (i64.const -9218868437227405313))
            (i64.const 4602678819172646912)))))
    (get_local $p0))
  (func $f31 (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (if $I0 (result i32)
      (get_local $p0)
      (then
        (call $f48
          (get_local $p0)
          (get_local $p1)
          (i32.const 0)))
      (else
        (i32.const 0))))
  (func $f32 (type $t8) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l0 i32) (local $l1 i64) (local $l2 f64)
    (block $B0
      (if $I1
        (i32.le_u
          (get_local $p1)
          (i32.const 20))
        (then
          (block $B2
            (block $B3
              (block $B4
                (block $B5
                  (block $B6
                    (block $B7
                      (block $B8
                        (block $B9
                          (block $B10
                            (block $B11
                              (block $B12
                                (br_table $B12 $B11 $B10 $B9 $B8 $B7 $B6 $B5 $B4 $B3 $B2
                                  (i32.sub
                                    (get_local $p1)
                                    (i32.const 9))))
                              (set_local $l0
                                (i32.load
                                  (tee_local $p1
                                    (i32.and
                                      (i32.add
                                        (i32.load
                                          (get_local $p2))
                                        (i32.const 3))
                                      (i32.const -4)))))
                              (i32.store
                                (get_local $p2)
                                (i32.add
                                  (get_local $p1)
                                  (i32.const 4)))
                              (i32.store
                                (get_local $p0)
                                (get_local $l0))
                              (br $B0))
                            (set_local $l0
                              (i32.load
                                (tee_local $p1
                                  (i32.and
                                    (i32.add
                                      (i32.load
                                        (get_local $p2))
                                      (i32.const 3))
                                    (i32.const -4)))))
                            (i32.store
                              (get_local $p2)
                              (i32.add
                                (get_local $p1)
                                (i32.const 4)))
                            (i64.store
                              (get_local $p0)
                              (i64.extend_s/i32
                                (get_local $l0)))
                            (br $B0))
                          (set_local $l0
                            (i32.load
                              (tee_local $p1
                                (i32.and
                                  (i32.add
                                    (i32.load
                                      (get_local $p2))
                                    (i32.const 3))
                                  (i32.const -4)))))
                          (i32.store
                            (get_local $p2)
                            (i32.add
                              (get_local $p1)
                              (i32.const 4)))
                          (i64.store
                            (get_local $p0)
                            (i64.extend_u/i32
                              (get_local $l0)))
                          (br $B0))
                        (set_local $l1
                          (i64.load
                            (tee_local $p1
                              (i32.and
                                (i32.add
                                  (i32.load
                                    (get_local $p2))
                                  (i32.const 7))
                                (i32.const -8)))))
                        (i32.store
                          (get_local $p2)
                          (i32.add
                            (get_local $p1)
                            (i32.const 8)))
                        (i64.store
                          (get_local $p0)
                          (get_local $l1))
                        (br $B0))
                      (set_local $l0
                        (i32.load
                          (tee_local $p1
                            (i32.and
                              (i32.add
                                (i32.load
                                  (get_local $p2))
                                (i32.const 3))
                              (i32.const -4)))))
                      (i32.store
                        (get_local $p2)
                        (i32.add
                          (get_local $p1)
                          (i32.const 4)))
                      (i64.store
                        (get_local $p0)
                        (i64.extend_s/i32
                          (i32.shr_s
                            (i32.shl
                              (i32.and
                                (get_local $l0)
                                (i32.const 65535))
                              (i32.const 16))
                            (i32.const 16))))
                      (br $B0))
                    (set_local $l0
                      (i32.load
                        (tee_local $p1
                          (i32.and
                            (i32.add
                              (i32.load
                                (get_local $p2))
                              (i32.const 3))
                            (i32.const -4)))))
                    (i32.store
                      (get_local $p2)
                      (i32.add
                        (get_local $p1)
                        (i32.const 4)))
                    (i64.store
                      (get_local $p0)
                      (i64.extend_u/i32
                        (i32.and
                          (get_local $l0)
                          (i32.const 65535))))
                    (br $B0))
                  (set_local $l0
                    (i32.load
                      (tee_local $p1
                        (i32.and
                          (i32.add
                            (i32.load
                              (get_local $p2))
                            (i32.const 3))
                          (i32.const -4)))))
                  (i32.store
                    (get_local $p2)
                    (i32.add
                      (get_local $p1)
                      (i32.const 4)))
                  (i64.store
                    (get_local $p0)
                    (i64.extend_s/i32
                      (i32.shr_s
                        (i32.shl
                          (i32.and
                            (get_local $l0)
                            (i32.const 255))
                          (i32.const 24))
                        (i32.const 24))))
                  (br $B0))
                (set_local $l0
                  (i32.load
                    (tee_local $p1
                      (i32.and
                        (i32.add
                          (i32.load
                            (get_local $p2))
                          (i32.const 3))
                        (i32.const -4)))))
                (i32.store
                  (get_local $p2)
                  (i32.add
                    (get_local $p1)
                    (i32.const 4)))
                (i64.store
                  (get_local $p0)
                  (i64.extend_u/i32
                    (i32.and
                      (get_local $l0)
                      (i32.const 255))))
                (br $B0))
              (set_local $l2
                (f64.load
                  (tee_local $p1
                    (i32.and
                      (i32.add
                        (i32.load
                          (get_local $p2))
                        (i32.const 7))
                      (i32.const -8)))))
              (i32.store
                (get_local $p2)
                (i32.add
                  (get_local $p1)
                  (i32.const 8)))
              (f64.store
                (get_local $p0)
                (get_local $l2))
              (br $B0))
            (set_local $l2
              (f64.load
                (tee_local $p1
                  (i32.and
                    (i32.add
                      (i32.load
                        (get_local $p2))
                      (i32.const 7))
                    (i32.const -8)))))
            (i32.store
              (get_local $p2)
              (i32.add
                (get_local $p1)
                (i32.const 8)))
            (f64.store
              (get_local $p0)
              (get_local $l2)))))))
  (func $f33 (type $t1) (param $p0 i32) (result i32)
    (local $l0 i32) (local $l1 i32)
    (if $I0
      (call $f20
        (i32.load8_s
          (i32.load
            (get_local $p0))))
      (then
        (loop $L1
          (set_local $l0
            (i32.add
              (i32.add
                (i32.mul
                  (get_local $l0)
                  (i32.const 10))
                (i32.const -48))
              (i32.load8_s
                (tee_local $l1
                  (i32.load
                    (get_local $p0))))))
          (i32.store
            (get_local $p0)
            (tee_local $l1
              (i32.add
                (get_local $l1)
                (i32.const 1))))
          (br_if $L1
            (call $f20
              (i32.load8_s
                (get_local $l1)))))))
    (get_local $l0))
  (func $f34 (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32)
    (set_local $l1
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 48)))
    (set_local $l5
      (i32.add
        (get_local $l1)
        (i32.const 16)))
    (i32.store
      (tee_local $l0
        (i32.add
          (get_local $l1)
          (i32.const 32)))
      (tee_local $l4
        (i32.load
          (tee_local $l7
            (i32.add
              (get_local $p0)
              (i32.const 28))))))
    (i32.store offset=4
      (get_local $l0)
      (tee_local $l4
        (i32.sub
          (i32.load
            (tee_local $l8
              (i32.add
                (get_local $p0)
                (i32.const 20))))
          (get_local $l4))))
    (i32.store offset=8
      (get_local $l0)
      (get_local $p1))
    (i32.store offset=12
      (get_local $l0)
      (get_local $p2))
    (i32.store
      (tee_local $l2
        (get_local $l1))
      (i32.load
        (tee_local $l9
          (i32.add
            (get_local $p0)
            (i32.const 60)))))
    (i32.store offset=4
      (get_local $l2)
      (get_local $l0))
    (i32.store offset=8
      (get_local $l2)
      (i32.const 2))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.eq
            (tee_local $l1
              (i32.add
                (get_local $l4)
                (get_local $p2)))
            (tee_local $l3
              (call $f21
                (call $env.___syscall146
                  (i32.const 146)
                  (get_local $l2))))))
        (set_local $l4
          (i32.const 2))
        (set_local $p1
          (get_local $l0))
        (set_local $l0
          (get_local $l3))
        (loop $L2
          (if $I3
            (i32.ge_s
              (get_local $l0)
              (i32.const 0))
            (then
              (i32.store
                (tee_local $p1
                  (select
                    (i32.add
                      (get_local $p1)
                      (i32.const 8))
                    (get_local $p1)
                    (tee_local $l3
                      (i32.gt_u
                        (get_local $l0)
                        (tee_local $l6
                          (i32.load offset=4
                            (get_local $p1)))))))
                (i32.add
                  (i32.load
                    (get_local $p1))
                  (tee_local $l6
                    (i32.sub
                      (get_local $l0)
                      (select
                        (get_local $l6)
                        (i32.const 0)
                        (get_local $l3))))))
              (i32.store
                (tee_local $l10
                  (i32.add
                    (get_local $p1)
                    (i32.const 4)))
                (i32.sub
                  (i32.load
                    (get_local $l10))
                  (get_local $l6)))
              (i32.store
                (get_local $l5)
                (i32.load
                  (get_local $l9)))
              (i32.store offset=4
                (get_local $l5)
                (get_local $p1))
              (i32.store offset=8
                (get_local $l5)
                (tee_local $l4
                  (i32.add
                    (get_local $l4)
                    (i32.shr_s
                      (i32.shl
                        (get_local $l3)
                        (i32.const 31))
                      (i32.const 31)))))
              (br_if $B1
                (i32.eq
                  (tee_local $l1
                    (i32.sub
                      (get_local $l1)
                      (get_local $l0)))
                  (tee_local $l0
                    (call $f21
                      (call $env.___syscall146
                        (i32.const 146)
                        (get_local $l5))))))
              (br $L2))))
        (i32.store offset=16
          (get_local $p0)
          (i32.const 0))
        (i32.store
          (get_local $l7)
          (i32.const 0))
        (i32.store
          (get_local $l8)
          (i32.const 0))
        (i32.store
          (get_local $p0)
          (i32.or
            (i32.load
              (get_local $p0))
            (i32.const 32)))
        (set_local $p2
          (if $I4 (result i32)
            (i32.eq
              (get_local $l4)
              (i32.const 2))
            (then
              (i32.const 0))
            (else
              (i32.sub
                (get_local $p2)
                (i32.load offset=4
                  (get_local $p1))))))
        (br $B0))
      (i32.store offset=16
        (get_local $p0)
        (i32.add
          (tee_local $p1
            (i32.load offset=44
              (get_local $p0)))
          (i32.load offset=48
            (get_local $p0))))
      (i32.store
        (get_local $l7)
        (get_local $p1))
      (i32.store
        (get_local $l8)
        (get_local $p1)))
    (set_global $g4
      (get_local $l2))
    (get_local $p2))
  (func $f35 (type $t6) (param $p0 i32) (param $p1 i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    (block $B0
      (set_local $l5
        (i32.add
          (get_local $p0)
          (get_local $p1)))
      (block $B1
        (if $I2
          (i32.eqz
            (i32.and
              (tee_local $l0
                (i32.load offset=4
                  (get_local $p0)))
              (i32.const 1)))
          (then
            (set_local $l2
              (i32.load
                (get_local $p0)))
            (if $I3
              (i32.eqz
                (i32.and
                  (get_local $l0)
                  (i32.const 3)))
              (then
                (return)))
            (set_local $p1
              (i32.add
                (get_local $l2)
                (get_local $p1)))
            (if $I4
              (i32.eq
                (i32.load
                  (i32.const 3948))
                (tee_local $p0
                  (i32.sub
                    (get_local $p0)
                    (get_local $l2))))
              (then
                (br_if $B1
                  (i32.ne
                    (i32.and
                      (tee_local $l0
                        (i32.load
                          (tee_local $l2
                            (i32.add
                              (get_local $l5)
                              (i32.const 4)))))
                      (i32.const 3))
                    (i32.const 3)))
                (i32.store
                  (i32.const 3936)
                  (get_local $p1))
                (i32.store
                  (get_local $l2)
                  (i32.and
                    (get_local $l0)
                    (i32.const -2)))
                (i32.store offset=4
                  (get_local $p0)
                  (i32.or
                    (get_local $p1)
                    (i32.const 1)))
                (i32.store
                  (get_local $l5)
                  (get_local $p1))
                (return)))
            (set_local $l1
              (i32.shr_u
                (get_local $l2)
                (i32.const 3)))
            (if $I5
              (i32.lt_u
                (get_local $l2)
                (i32.const 256))
              (then
                (if $I6
                  (i32.eq
                    (tee_local $l2
                      (i32.load offset=12
                        (get_local $p0)))
                    (tee_local $l0
                      (i32.load offset=8
                        (get_local $p0))))
                  (then
                    (i32.store
                      (i32.const 3928)
                      (i32.and
                        (i32.load
                          (i32.const 3928))
                        (i32.xor
                          (i32.shl
                            (i32.const 1)
                            (get_local $l1))
                          (i32.const -1)))))
                  (else
                    (i32.store offset=12
                      (get_local $l0)
                      (get_local $l2))
                    (i32.store offset=8
                      (get_local $l2)
                      (get_local $l0))))
                (br $B1)))
            (set_local $l4
              (i32.load offset=24
                (get_local $p0)))
            (block $B7
              (if $I8
                (i32.eq
                  (tee_local $l2
                    (i32.load offset=12
                      (get_local $p0)))
                  (get_local $p0))
                (then
                  (if $I9
                    (tee_local $l2
                      (i32.load
                        (tee_local $l1
                          (i32.add
                            (tee_local $l0
                              (i32.add
                                (get_local $p0)
                                (i32.const 16)))
                            (i32.const 4)))))
                    (then
                      (set_local $l0
                        (get_local $l1)))
                    (else
                      (if $I10
                        (i32.eqz
                          (tee_local $l2
                            (i32.load
                              (get_local $l0))))
                        (then
                          (set_local $l2
                            (i32.const 0))
                          (br $B7)))))
                  (loop $L11
                    (if $I12
                      (tee_local $l3
                        (i32.load
                          (tee_local $l1
                            (i32.add
                              (get_local $l2)
                              (i32.const 20)))))
                      (then
                        (set_local $l2
                          (get_local $l3))
                        (set_local $l0
                          (get_local $l1))
                        (br $L11)))
                    (if $I13
                      (tee_local $l3
                        (i32.load
                          (tee_local $l1
                            (i32.add
                              (get_local $l2)
                              (i32.const 16)))))
                      (then
                        (set_local $l2
                          (get_local $l3))
                        (set_local $l0
                          (get_local $l1))
                        (br $L11))))
                  (i32.store
                    (get_local $l0)
                    (i32.const 0)))
                (else
                  (i32.store offset=12
                    (tee_local $l0
                      (i32.load offset=8
                        (get_local $p0)))
                    (get_local $l2))
                  (i32.store offset=8
                    (get_local $l2)
                    (get_local $l0)))))
            (if $I14
              (get_local $l4)
              (then
                (if $I15
                  (i32.eq
                    (i32.load
                      (tee_local $l1
                        (i32.add
                          (i32.shl
                            (tee_local $l0
                              (i32.load offset=28
                                (get_local $p0)))
                            (i32.const 2))
                          (i32.const 4232))))
                    (get_local $p0))
                  (then
                    (i32.store
                      (get_local $l1)
                      (get_local $l2))
                    (if $I16
                      (i32.eqz
                        (get_local $l2))
                      (then
                        (i32.store
                          (i32.const 3932)
                          (i32.and
                            (i32.load
                              (i32.const 3932))
                            (i32.xor
                              (i32.shl
                                (i32.const 1)
                                (get_local $l0))
                              (i32.const -1))))
                        (br $B1))))
                  (else
                    (i32.store
                      (i32.add
                        (tee_local $l0
                          (i32.add
                            (get_local $l4)
                            (i32.const 16)))
                        (i32.shl
                          (i32.ne
                            (i32.load
                              (get_local $l0))
                            (get_local $p0))
                          (i32.const 2)))
                      (get_local $l2))
                    (br_if $B1
                      (i32.eqz
                        (get_local $l2)))))
                (i32.store offset=24
                  (get_local $l2)
                  (get_local $l4))
                (if $I17
                  (tee_local $l0
                    (i32.load
                      (tee_local $l1
                        (i32.add
                          (get_local $p0)
                          (i32.const 16)))))
                  (then
                    (i32.store offset=16
                      (get_local $l2)
                      (get_local $l0))
                    (i32.store offset=24
                      (get_local $l0)
                      (get_local $l2))))
                (if $I18
                  (tee_local $l0
                    (i32.load offset=4
                      (get_local $l1)))
                  (then
                    (i32.store offset=20
                      (get_local $l2)
                      (get_local $l0))
                    (i32.store offset=24
                      (get_local $l0)
                      (get_local $l2)))))))))
      (if $I19
        (i32.and
          (tee_local $l2
            (i32.load
              (tee_local $l0
                (i32.add
                  (get_local $l5)
                  (i32.const 4)))))
          (i32.const 2))
        (then
          (i32.store
            (get_local $l0)
            (i32.and
              (get_local $l2)
              (i32.const -2)))
          (i32.store offset=4
            (get_local $p0)
            (i32.or
              (get_local $p1)
              (i32.const 1)))
          (i32.store
            (i32.add
              (get_local $p0)
              (get_local $p1))
            (get_local $p1)))
        (else
          (if $I20
            (i32.eq
              (i32.load
                (i32.const 3952))
              (get_local $l5))
            (then
              (i32.store
                (i32.const 3940)
                (tee_local $p1
                  (i32.add
                    (i32.load
                      (i32.const 3940))
                    (get_local $p1))))
              (i32.store
                (i32.const 3952)
                (get_local $p0))
              (i32.store offset=4
                (get_local $p0)
                (i32.or
                  (get_local $p1)
                  (i32.const 1)))
              (if $I21
                (i32.ne
                  (get_local $p0)
                  (i32.load
                    (i32.const 3948)))
                (then
                  (return)))
              (i32.store
                (i32.const 3948)
                (i32.const 0))
              (i32.store
                (i32.const 3936)
                (i32.const 0))
              (return)))
          (if $I22
            (i32.eq
              (i32.load
                (i32.const 3948))
              (get_local $l5))
            (then
              (i32.store
                (i32.const 3936)
                (tee_local $p1
                  (i32.add
                    (i32.load
                      (i32.const 3936))
                    (get_local $p1))))
              (i32.store
                (i32.const 3948)
                (get_local $p0))
              (i32.store offset=4
                (get_local $p0)
                (i32.or
                  (get_local $p1)
                  (i32.const 1)))
              (i32.store
                (i32.add
                  (get_local $p0)
                  (get_local $p1))
                (get_local $p1))
              (return)))
          (set_local $l3
            (i32.add
              (i32.and
                (get_local $l2)
                (i32.const -8))
              (get_local $p1)))
          (set_local $l0
            (i32.shr_u
              (get_local $l2)
              (i32.const 3)))
          (block $B23
            (if $I24
              (i32.lt_u
                (get_local $l2)
                (i32.const 256))
              (then
                (if $I25
                  (i32.eq
                    (tee_local $p1
                      (i32.load offset=12
                        (get_local $l5)))
                    (tee_local $l2
                      (i32.load offset=8
                        (get_local $l5))))
                  (then
                    (i32.store
                      (i32.const 3928)
                      (i32.and
                        (i32.load
                          (i32.const 3928))
                        (i32.xor
                          (i32.shl
                            (i32.const 1)
                            (get_local $l0))
                          (i32.const -1)))))
                  (else
                    (i32.store offset=12
                      (get_local $l2)
                      (get_local $p1))
                    (i32.store offset=8
                      (get_local $p1)
                      (get_local $l2)))))
              (else
                (set_local $l4
                  (i32.load offset=24
                    (get_local $l5)))
                (block $B26
                  (if $I27
                    (i32.eq
                      (tee_local $p1
                        (i32.load offset=12
                          (get_local $l5)))
                      (get_local $l5))
                    (then
                      (if $I28
                        (tee_local $p1
                          (i32.load
                            (tee_local $l0
                              (i32.add
                                (tee_local $l2
                                  (i32.add
                                    (get_local $l5)
                                    (i32.const 16)))
                                (i32.const 4)))))
                        (then
                          (set_local $l2
                            (get_local $l0)))
                        (else
                          (if $I29
                            (i32.eqz
                              (tee_local $p1
                                (i32.load
                                  (get_local $l2))))
                            (then
                              (set_local $p1
                                (i32.const 0))
                              (br $B26)))))
                      (loop $L30
                        (if $I31
                          (tee_local $l1
                            (i32.load
                              (tee_local $l0
                                (i32.add
                                  (get_local $p1)
                                  (i32.const 20)))))
                          (then
                            (set_local $p1
                              (get_local $l1))
                            (set_local $l2
                              (get_local $l0))
                            (br $L30)))
                        (if $I32
                          (tee_local $l1
                            (i32.load
                              (tee_local $l0
                                (i32.add
                                  (get_local $p1)
                                  (i32.const 16)))))
                          (then
                            (set_local $p1
                              (get_local $l1))
                            (set_local $l2
                              (get_local $l0))
                            (br $L30))))
                      (i32.store
                        (get_local $l2)
                        (i32.const 0)))
                    (else
                      (i32.store offset=12
                        (tee_local $l2
                          (i32.load offset=8
                            (get_local $l5)))
                        (get_local $p1))
                      (i32.store offset=8
                        (get_local $p1)
                        (get_local $l2)))))
                (if $I33
                  (get_local $l4)
                  (then
                    (if $I34
                      (i32.eq
                        (i32.load
                          (tee_local $l0
                            (i32.add
                              (i32.shl
                                (tee_local $l2
                                  (i32.load offset=28
                                    (get_local $l5)))
                                (i32.const 2))
                              (i32.const 4232))))
                        (get_local $l5))
                      (then
                        (i32.store
                          (get_local $l0)
                          (get_local $p1))
                        (if $I35
                          (i32.eqz
                            (get_local $p1))
                          (then
                            (i32.store
                              (i32.const 3932)
                              (i32.and
                                (i32.load
                                  (i32.const 3932))
                                (i32.xor
                                  (i32.shl
                                    (i32.const 1)
                                    (get_local $l2))
                                  (i32.const -1))))
                            (br $B23))))
                      (else
                        (i32.store
                          (i32.add
                            (tee_local $l0
                              (i32.add
                                (get_local $l4)
                                (i32.const 16)))
                            (i32.shl
                              (i32.ne
                                (i32.load
                                  (get_local $l0))
                                (get_local $l5))
                              (i32.const 2)))
                          (get_local $p1))
                        (br_if $B23
                          (i32.eqz
                            (get_local $p1)))))
                    (i32.store offset=24
                      (get_local $p1)
                      (get_local $l4))
                    (if $I36
                      (tee_local $l2
                        (i32.load
                          (tee_local $l0
                            (i32.add
                              (get_local $l5)
                              (i32.const 16)))))
                      (then
                        (i32.store offset=16
                          (get_local $p1)
                          (get_local $l2))
                        (i32.store offset=24
                          (get_local $l2)
                          (get_local $p1))))
                    (if $I37
                      (tee_local $l2
                        (i32.load offset=4
                          (get_local $l0)))
                      (then
                        (i32.store offset=20
                          (get_local $p1)
                          (get_local $l2))
                        (i32.store offset=24
                          (get_local $l2)
                          (get_local $p1)))))))))
          (i32.store offset=4
            (get_local $p0)
            (i32.or
              (get_local $l3)
              (i32.const 1)))
          (i32.store
            (i32.add
              (get_local $p0)
              (get_local $l3))
            (get_local $l3))
          (if $I38
            (i32.eq
              (get_local $p0)
              (i32.load
                (i32.const 3948)))
            (then
              (i32.store
                (i32.const 3936)
                (get_local $l3))
              (return))
            (else
              (set_local $p1
                (get_local $l3))))))
      (set_local $l2
        (i32.shr_u
          (get_local $p1)
          (i32.const 3)))
      (if $I39
        (i32.lt_u
          (get_local $p1)
          (i32.const 256))
        (then
          (set_local $p1
            (i32.add
              (i32.shl
                (get_local $l2)
                (i32.const 3))
              (i32.const 3968)))
          (set_local $l2
            (if $I40 (result i32)
              (i32.and
                (tee_local $l0
                  (i32.load
                    (i32.const 3928)))
                (tee_local $l2
                  (i32.shl
                    (i32.const 1)
                    (get_local $l2))))
              (then
                (i32.load
                  (tee_local $l0
                    (i32.add
                      (get_local $p1)
                      (i32.const 8)))))
              (else
                (i32.store
                  (i32.const 3928)
                  (i32.or
                    (get_local $l0)
                    (get_local $l2)))
                (set_local $l0
                  (i32.add
                    (get_local $p1)
                    (i32.const 8)))
                (get_local $p1))))
          (i32.store
            (get_local $l0)
            (get_local $p0))
          (i32.store offset=12
            (get_local $l2)
            (get_local $p0))
          (i32.store offset=8
            (get_local $p0)
            (get_local $l2))
          (i32.store offset=12
            (get_local $p0)
            (get_local $p1))
          (return)))
      (set_local $l1
        (i32.add
          (i32.shl
            (tee_local $l2
              (if $I41 (result i32)
                (tee_local $l2
                  (i32.shr_u
                    (get_local $p1)
                    (i32.const 8)))
                (then
                  (if $I42 (result i32)
                    (i32.gt_u
                      (get_local $p1)
                      (i32.const 16777215))
                    (then
                      (i32.const 31))
                    (else
                      (i32.or
                        (i32.and
                          (i32.shr_u
                            (get_local $p1)
                            (i32.add
                              (tee_local $l2
                                (i32.add
                                  (i32.sub
                                    (i32.const 14)
                                    (i32.or
                                      (i32.or
                                        (tee_local $l1
                                          (i32.and
                                            (i32.shr_u
                                              (i32.add
                                                (tee_local $l0
                                                  (i32.shl
                                                    (get_local $l2)
                                                    (tee_local $l2
                                                      (i32.and
                                                        (i32.shr_u
                                                          (i32.add
                                                            (get_local $l2)
                                                            (i32.const 1048320))
                                                          (i32.const 16))
                                                        (i32.const 8)))))
                                                (i32.const 520192))
                                              (i32.const 16))
                                            (i32.const 4)))
                                        (get_local $l2))
                                      (tee_local $l0
                                        (i32.and
                                          (i32.shr_u
                                            (i32.add
                                              (tee_local $l2
                                                (i32.shl
                                                  (get_local $l0)
                                                  (get_local $l1)))
                                              (i32.const 245760))
                                            (i32.const 16))
                                          (i32.const 2)))))
                                  (i32.shr_u
                                    (i32.shl
                                      (get_local $l2)
                                      (get_local $l0))
                                    (i32.const 15))))
                              (i32.const 7)))
                          (i32.const 1))
                        (i32.shl
                          (get_local $l2)
                          (i32.const 1))))))
                (else
                  (i32.const 0))))
            (i32.const 2))
          (i32.const 4232)))
      (i32.store offset=28
        (get_local $p0)
        (get_local $l2))
      (i32.store offset=20
        (get_local $p0)
        (i32.const 0))
      (i32.store offset=16
        (get_local $p0)
        (i32.const 0))
      (if $I43
        (i32.eqz
          (i32.and
            (tee_local $l0
              (i32.load
                (i32.const 3932)))
            (tee_local $l3
              (i32.shl
                (i32.const 1)
                (get_local $l2)))))
        (then
          (i32.store
            (i32.const 3932)
            (i32.or
              (get_local $l0)
              (get_local $l3)))
          (i32.store
            (get_local $l1)
            (get_local $p0))
          (i32.store offset=24
            (get_local $p0)
            (get_local $l1))
          (br $B0)))
      (set_local $l0
        (i32.shl
          (get_local $p1)
          (select
            (i32.const 0)
            (i32.sub
              (i32.const 25)
              (i32.shr_u
                (get_local $l2)
                (i32.const 1)))
            (i32.eq
              (get_local $l2)
              (i32.const 31)))))
      (set_local $l2
        (i32.load
          (get_local $l1)))
      (block $B44
        (loop $L45
          (br_if $B44
            (i32.eq
              (i32.and
                (i32.load offset=4
                  (get_local $l2))
                (i32.const -8))
              (get_local $p1)))
          (set_local $l1
            (i32.shl
              (get_local $l0)
              (i32.const 1)))
          (if $I46
            (tee_local $l3
              (i32.load
                (tee_local $l0
                  (i32.add
                    (i32.add
                      (get_local $l2)
                      (i32.const 16))
                    (i32.shl
                      (i32.shr_u
                        (get_local $l0)
                        (i32.const 31))
                      (i32.const 2))))))
            (then
              (set_local $l0
                (get_local $l1))
              (set_local $l2
                (get_local $l3))
              (br $L45))))
        (i32.store
          (get_local $l0)
          (get_local $p0))
        (i32.store offset=24
          (get_local $p0)
          (get_local $l2))
        (br $B0))
      (i32.store offset=12
        (tee_local $l0
          (i32.load
            (tee_local $p1
              (i32.add
                (get_local $l2)
                (i32.const 8)))))
        (get_local $p0))
      (i32.store
        (get_local $p1)
        (get_local $p0))
      (i32.store offset=8
        (get_local $p0)
        (get_local $l0))
      (i32.store offset=12
        (get_local $p0)
        (get_local $l2))
      (i32.store offset=24
        (get_local $p0)
        (i32.const 0))
      (return))
    (i32.store offset=12
      (get_local $p0)
      (get_local $p0))
    (i32.store offset=8
      (get_local $p0)
      (get_local $p0)))
  (func $f36 (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (select
      (select
        (i32.add
          (i32.xor
            (get_local $p0)
            (i32.const -1))
          (get_local $p1))
        (i32.const 0)
        (i32.lt_u
          (i32.add
            (get_local $p1)
            (i32.const 100))
          (get_local $p0)))
      (i32.sub
        (get_local $p1)
        (get_local $p0))
      (i32.lt_u
        (get_local $p1)
        (get_local $p0))))
  (func $_main (export "_main") (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l0 f32)
    (set_local $p0
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 16)))
    (set_local $p1
      (call $env._SAB_lib_get_counter_value))
    (loop $L0
      (br_if $L0
        (i32.lt_u
          (call $f36
            (get_local $p1)
            (call $env._SAB_lib_get_counter_value))
          (i32.const 134217728))))
    (set_local $l0
      (f32.const 0x1.94p+6 (;=101;)))
    (loop $L1
      (if $I2
        (f32.gt
          (get_local $l0)
          (f32.const 0x1.9p+6 (;=100;)))
        (then
          (set_local $l0
            (f32.demote/f64
              (call $env._SAB_get_resolution_ns
                (i32.const 1000))))
          (br $L1))))
    (f64.store
      (get_local $p0)
      (f64.promote/f32
        (get_local $l0)))
    (drop
      (call $f23
        (i32.const 1434)
        (get_local $p0)))
    (drop
      (call $f28
        (i32.const 1463)))
    (call $f27
      (i32.const 1))
    (drop
      (call $f28
        (i32.const 1477)))
    (call $f27
      (i32.const 0))
    (call $env._exit
      (i32.const 1))
    (i32.const 0))
  (func $f38 (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (call $env.abort
      (i32.const 1))
    (i32.const 0))
  (func $f39 (type $t1) (param $p0 i32) (result i32)
    (call $env.abort
      (i32.const 0))
    (i32.const 0))
  (func $f40 (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32)
    (if $I0
      (i32.ge_s
        (get_local $p2)
        (i32.const 8192))
      (then
        (return
          (call $env._emscripten_memcpy_big
            (get_local $p0)
            (get_local $p1)
            (get_local $p2)))))
    (set_local $l0
      (get_local $p0))
    (set_local $l1
      (i32.add
        (get_local $p0)
        (get_local $p2)))
    (if $I1
      (i32.eq
        (i32.and
          (get_local $p0)
          (i32.const 3))
        (i32.and
          (get_local $p1)
          (i32.const 3)))
      (then
        (loop $L2
          (if $I3
            (i32.and
              (get_local $p0)
              (i32.const 3))
            (then
              (if $I4
                (i32.eqz
                  (get_local $p2))
                (then
                  (return
                    (get_local $l0))))
              (i32.store8
                (get_local $p0)
                (i32.load8_s
                  (get_local $p1)))
              (set_local $p0
                (i32.add
                  (get_local $p0)
                  (i32.const 1)))
              (set_local $p1
                (i32.add
                  (get_local $p1)
                  (i32.const 1)))
              (set_local $p2
                (i32.sub
                  (get_local $p2)
                  (i32.const 1)))
              (br $L2))))
        (set_local $l2
          (i32.add
            (tee_local $p2
              (i32.and
                (get_local $l1)
                (i32.const -4)))
            (i32.const -64)))
        (loop $L5
          (if $I6
            (i32.le_s
              (get_local $p0)
              (get_local $l2))
            (then
              (i32.store
                (get_local $p0)
                (i32.load
                  (get_local $p1)))
              (i32.store offset=4
                (get_local $p0)
                (i32.load offset=4
                  (get_local $p1)))
              (i32.store offset=8
                (get_local $p0)
                (i32.load offset=8
                  (get_local $p1)))
              (i32.store offset=12
                (get_local $p0)
                (i32.load offset=12
                  (get_local $p1)))
              (i32.store offset=16
                (get_local $p0)
                (i32.load offset=16
                  (get_local $p1)))
              (i32.store offset=20
                (get_local $p0)
                (i32.load offset=20
                  (get_local $p1)))
              (i32.store offset=24
                (get_local $p0)
                (i32.load offset=24
                  (get_local $p1)))
              (i32.store offset=28
                (get_local $p0)
                (i32.load offset=28
                  (get_local $p1)))
              (i32.store offset=32
                (get_local $p0)
                (i32.load offset=32
                  (get_local $p1)))
              (i32.store offset=36
                (get_local $p0)
                (i32.load offset=36
                  (get_local $p1)))
              (i32.store offset=40
                (get_local $p0)
                (i32.load offset=40
                  (get_local $p1)))
              (i32.store offset=44
                (get_local $p0)
                (i32.load offset=44
                  (get_local $p1)))
              (i32.store offset=48
                (get_local $p0)
                (i32.load offset=48
                  (get_local $p1)))
              (i32.store offset=52
                (get_local $p0)
                (i32.load offset=52
                  (get_local $p1)))
              (i32.store offset=56
                (get_local $p0)
                (i32.load offset=56
                  (get_local $p1)))
              (i32.store offset=60
                (get_local $p0)
                (i32.load offset=60
                  (get_local $p1)))
              (set_local $p0
                (i32.sub
                  (get_local $p0)
                  (i32.const -64)))
              (set_local $p1
                (i32.sub
                  (get_local $p1)
                  (i32.const -64)))
              (br $L5))))
        (loop $L7
          (if $I8
            (i32.lt_s
              (get_local $p0)
              (get_local $p2))
            (then
              (i32.store
                (get_local $p0)
                (i32.load
                  (get_local $p1)))
              (set_local $p0
                (i32.add
                  (get_local $p0)
                  (i32.const 4)))
              (set_local $p1
                (i32.add
                  (get_local $p1)
                  (i32.const 4)))
              (br $L7)))))
      (else
        (set_local $p2
          (i32.sub
            (get_local $l1)
            (i32.const 4)))
        (loop $L9
          (if $I10
            (i32.lt_s
              (get_local $p0)
              (get_local $p2))
            (then
              (i32.store8
                (get_local $p0)
                (i32.load8_s
                  (get_local $p1)))
              (i32.store8 offset=1
                (get_local $p0)
                (i32.load8_s offset=1
                  (get_local $p1)))
              (i32.store8 offset=2
                (get_local $p0)
                (i32.load8_s offset=2
                  (get_local $p1)))
              (i32.store8 offset=3
                (get_local $p0)
                (i32.load8_s offset=3
                  (get_local $p1)))
              (set_local $p0
                (i32.add
                  (get_local $p0)
                  (i32.const 4)))
              (set_local $p1
                (i32.add
                  (get_local $p1)
                  (i32.const 4)))
              (br $L9))))))
    (loop $L11
      (if $I12
        (i32.lt_s
          (get_local $p0)
          (get_local $l1))
        (then
          (i32.store8
            (get_local $p0)
            (i32.load8_s
              (get_local $p1)))
          (set_local $p0
            (i32.add
              (get_local $p0)
              (i32.const 1)))
          (set_local $p1
            (i32.add
              (get_local $p1)
              (i32.const 1)))
          (br $L11))))
    (get_local $l0))
  (func $f41 (type $t1) (param $p0 i32) (result i32)
    (i32.or
      (i32.or
        (i32.or
          (i32.shl
            (i32.and
              (get_local $p0)
              (i32.const 255))
            (i32.const 24))
          (i32.shl
            (i32.and
              (i32.shr_s
                (get_local $p0)
                (i32.const 8))
              (i32.const 255))
            (i32.const 16)))
        (i32.shl
          (i32.and
            (i32.shr_s
              (get_local $p0)
              (i32.const 16))
            (i32.const 255))
          (i32.const 8)))
      (i32.shr_u
        (get_local $p0)
        (i32.const 24))))
  (func $f42 (type $t15) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (param $p5 i32) (result i32)
    (local $l0 i32)
    (set_local $l0
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 32)))
    (set_local $p0
      (block $B0 (result i32)
        (if $I1 (result i32)
          (i64.eq
            (i64.and
              (i64.extend_s/i32
                (get_local $p5))
              (i64.const -17592186040321))
            (i64.const 0))
          (then
            (if $I2
              (i32.gt_u
                (get_local $p1)
                (i32.const 2147483646))
              (then
                (i32.store
                  (i32.const 4488)
                  (i32.const 12))
                (br $B0
                  (i32.const -1))))
            (i32.store
              (get_local $l0)
              (get_local $p0))
            (i32.store offset=4
              (get_local $l0)
              (get_local $p1))
            (i32.store offset=8
              (get_local $l0)
              (get_local $p2))
            (i32.store offset=12
              (get_local $l0)
              (get_local $p3))
            (i32.store offset=16
              (get_local $l0)
              (get_local $p4))
            (i32.store offset=20
              (get_local $l0)
              (i32.shr_s
                (get_local $p5)
                (i32.const 12)))
            (call $f21
              (call $env.___syscall192
                (i32.const 192)
                (get_local $l0))))
          (else
            (i32.store
              (i32.const 4488)
              (i32.const 22))
            (i32.const -1)))))
    (set_global $g4
      (get_local $l0))
    (get_local $p0))
  (func $f43 (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32)
    (set_local $l0
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 16)))
    (i32.store8
      (get_local $l0)
      (tee_local $l4
        (i32.and
          (get_local $p1)
          (i32.const 255))))
    (block $B0
      (block $B1
        (br_if $B1
          (tee_local $l2
            (i32.load
              (tee_local $l1
                (i32.add
                  (get_local $p0)
                  (i32.const 16))))))
        (if $I2
          (call $f29
            (get_local $p0))
          (then
            (set_local $p1
              (i32.const -1)))
          (else
            (set_local $l2
              (i32.load
                (get_local $l1)))
            (br $B1)))
        (br $B0))
      (if $I3
        (i32.lt_u
          (tee_local $l3
            (i32.load
              (tee_local $l1
                (i32.add
                  (get_local $p0)
                  (i32.const 20)))))
          (get_local $l2))
        (then
          (if $I4
            (i32.ne
              (tee_local $p1
                (i32.and
                  (get_local $p1)
                  (i32.const 255)))
              (i32.load8_s offset=75
                (get_local $p0)))
            (then
              (i32.store
                (get_local $l1)
                (i32.add
                  (get_local $l3)
                  (i32.const 1)))
              (i32.store8
                (get_local $l3)
                (get_local $l4))
              (br $B0)))))
      (set_local $p1
        (if $I5 (result i32)
          (i32.eq
            (call_indirect (type $t0)
              (get_local $p0)
              (get_local $l0)
              (i32.const 1)
              (i32.add
                (i32.and
                  (i32.load offset=36
                    (get_local $p0))
                  (i32.const 3))
                (i32.const 2)))
            (i32.const 1))
          (then
            (i32.load8_u
              (get_local $l0)))
          (else
            (i32.const -1)))))
    (set_global $g4
      (get_local $l0))
    (get_local $p1))
  (func $f44 (type $t14) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    (local $l0 i32)
    (set_local $l0
      (i32.mul
        (get_local $p2)
        (get_local $p1)))
    (if $I0
      (i32.gt_s
        (i32.load offset=76
          (get_local $p3))
        (i32.const -1))
      (then
        (set_local $p0
          (call $f24
            (get_local $p0)
            (get_local $l0)
            (get_local $p3))))
      (else
        (set_local $p0
          (call $f24
            (get_local $p0)
            (get_local $l0)
            (get_local $p3)))))
    (set_local $p2
      (select
        (get_local $p2)
        (i32.const 0)
        (get_local $p1)))
    (if $I1
      (i32.ne
        (get_local $p0)
        (get_local $l0))
      (then
        (set_local $p2
          (i32.div_u
            (get_local $p0)
            (get_local $p1)))))
    (get_local $p2))
  (func $f45 (type $t1) (param $p0 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32)
    (block $B0
      (if $I1
        (i32.and
          (tee_local $l0
            (get_local $p0))
          (i32.const 3))
        (then
          (set_local $l1
            (get_local $l0))
          (loop $L2
            (br_if $B0
              (i32.eqz
                (i32.load8_s
                  (get_local $l1))))
            (br_if $L2
              (i32.and
                (tee_local $p0
                  (tee_local $l1
                    (i32.add
                      (get_local $l1)
                      (i32.const 1))))
                (i32.const 3)))
            (set_local $p0
              (get_local $l1)))))
      (loop $L3
        (set_local $l1
          (i32.add
            (get_local $p0)
            (i32.const 4)))
        (if $I4
          (i32.eqz
            (i32.and
              (i32.xor
                (i32.and
                  (tee_local $l2
                    (i32.load
                      (get_local $p0)))
                  (i32.const -2139062144))
                (i32.const -2139062144))
              (i32.add
                (get_local $l2)
                (i32.const -16843009))))
          (then
            (set_local $p0
              (get_local $l1))
            (br $L3))))
      (if $I5
        (i32.and
          (get_local $l2)
          (i32.const 255))
        (then
          (loop $L6
            (br_if $L6
              (i32.load8_s
                (tee_local $p0
                  (i32.add
                    (get_local $p0)
                    (i32.const 1)))))))))
    (i32.sub
      (get_local $p0)
      (get_local $l0)))
  (func $f46 (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32)
    (set_local $l0
      (call $f17
        (i32.load offset=8
          (get_local $p0))
        (tee_local $l8
          (i32.add
            (i32.load
              (get_local $p0))
            (i32.const 1794895138)))))
    (set_local $l9
      (call $f17
        (i32.load offset=12
          (get_local $p0))
        (get_local $l8)))
    (set_local $l1
      (call $f17
        (i32.load offset=16
          (get_local $p0))
        (get_local $l8)))
    (block $B0 (result i32)
      (if $I1 (result i32)
        (i32.lt_u
          (get_local $l0)
          (i32.shr_u
            (get_local $p1)
            (i32.const 2)))
        (then
          (if $I2 (result i32)
            (i32.and
              (i32.lt_u
                (get_local $l9)
                (tee_local $l7
                  (i32.sub
                    (get_local $p1)
                    (i32.shl
                      (get_local $l0)
                      (i32.const 2)))))
              (i32.lt_u
                (get_local $l1)
                (get_local $l7)))
            (then
              (if $I3 (result i32)
                (i32.and
                  (i32.or
                    (get_local $l1)
                    (get_local $l9))
                  (i32.const 3))
                (then
                  (i32.const 0))
                (else
                  (set_local $l5
                    (i32.shr_u
                      (get_local $l9)
                      (i32.const 2)))
                  (set_local $l4
                    (i32.shr_u
                      (get_local $l1)
                      (i32.const 2)))
                  (set_local $l9
                    (i32.const 0))
                  (loop $L4
                    (block $B5
                      (set_local $l6
                        (call $f17
                          (i32.load
                            (i32.add
                              (get_local $p0)
                              (i32.shl
                                (tee_local $l1
                                  (i32.add
                                    (tee_local $l2
                                      (i32.shl
                                        (tee_local $l3
                                          (i32.add
                                            (get_local $l9)
                                            (tee_local $l7
                                              (i32.shr_u
                                                (get_local $l0)
                                                (i32.const 1)))))
                                        (i32.const 1)))
                                    (get_local $l5)))
                                (i32.const 2))))
                          (get_local $l8)))
                      (drop
                        (br_if $B0
                          (i32.const 0)
                          (i32.eqz
                            (i32.and
                              (i32.lt_u
                                (tee_local $l1
                                  (call $f17
                                    (i32.load
                                      (i32.add
                                        (get_local $p0)
                                        (i32.shl
                                          (i32.add
                                            (get_local $l1)
                                            (i32.const 1))
                                          (i32.const 2))))
                                    (get_local $l8)))
                                (get_local $p1))
                              (i32.lt_u
                                (get_local $l6)
                                (i32.sub
                                  (get_local $p1)
                                  (get_local $l1)))))))
                      (drop
                        (br_if $B0
                          (i32.const 0)
                          (i32.load8_s
                            (i32.add
                              (get_local $p0)
                              (i32.add
                                (get_local $l1)
                                (get_local $l6))))))
                      (br_if $B5
                        (i32.eqz
                          (tee_local $l1
                            (call $f54
                              (get_local $p2)
                              (i32.add
                                (get_local $p0)
                                (get_local $l1))))))
                      (set_local $l1
                        (select
                          (get_local $l7)
                          (i32.sub
                            (get_local $l0)
                            (get_local $l7))
                          (tee_local $l7
                            (i32.lt_s
                              (get_local $l1)
                              (i32.const 0)))))
                      (set_local $l9
                        (select
                          (get_local $l9)
                          (get_local $l3)
                          (get_local $l7)))
                      (drop
                        (br_if $B0
                          (i32.const 0)
                          (i32.eq
                            (get_local $l0)
                            (i32.const 1))))
                      (set_local $l0
                        (get_local $l1))
                      (br $L4)))
                  (set_local $l0
                    (call $f17
                      (i32.load
                        (i32.add
                          (get_local $p0)
                          (i32.shl
                            (tee_local $p2
                              (i32.add
                                (get_local $l2)
                                (get_local $l4)))
                            (i32.const 2))))
                      (get_local $l8)))
                  (if $I6 (result i32)
                    (i32.and
                      (i32.lt_u
                        (tee_local $p2
                          (call $f17
                            (i32.load
                              (i32.add
                                (get_local $p0)
                                (i32.shl
                                  (i32.add
                                    (get_local $p2)
                                    (i32.const 1))
                                  (i32.const 2))))
                            (get_local $l8)))
                        (get_local $p1))
                      (i32.lt_u
                        (get_local $l0)
                        (i32.sub
                          (get_local $p1)
                          (get_local $p2))))
                    (then
                      (select
                        (i32.const 0)
                        (i32.add
                          (get_local $p0)
                          (get_local $p2))
                        (i32.load8_s
                          (i32.add
                            (get_local $p0)
                            (i32.add
                              (get_local $p2)
                              (get_local $l0))))))
                    (else
                      (i32.const 0))))))
            (else
              (i32.const 0))))
        (else
          (i32.const 0)))))
  (func $f47 (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l0 i32) (local $l1 i32)
    (block $B0
      (block $B1
        (block $B2
          (loop $L3
            (br_if $B2
              (i32.eq
                (i32.load8_u
                  (i32.add
                    (get_local $l0)
                    (i32.const 2025)))
                (get_local $p0)))
            (br_if $L3
              (i32.ne
                (tee_local $l0
                  (i32.add
                    (get_local $l0)
                    (i32.const 1)))
                (i32.const 87)))
            (set_local $p0
              (i32.const 2113))
            (set_local $l0
              (i32.const 87))
            (br $B1))
          (unreachable))
        (if $I4
          (get_local $l0)
          (then
            (set_local $p0
              (i32.const 2113))
            (br $B1))
          (else
            (set_local $p0
              (i32.const 2113))))
        (br $B0))
      (loop $L5
        (set_local $l1
          (get_local $p0))
        (loop $L6
          (set_local $p0
            (i32.add
              (get_local $l1)
              (i32.const 1)))
          (if $I7
            (i32.load8_s
              (get_local $l1))
            (then
              (set_local $l1
                (get_local $p0))
              (br $L6))))
        (br_if $L5
          (tee_local $l0
            (i32.add
              (get_local $l0)
              (i32.const -1))))))
    (select
      (tee_local $p1
        (if $I8 (result i32)
          (tee_local $p1
            (i32.load offset=20
              (get_local $p1)))
          (then
            (call $f46
              (i32.load
                (get_local $p1))
              (i32.load offset=4
                (get_local $p1))
              (get_local $p0)))
          (else
            (i32.const 0))))
      (get_local $p0)
      (get_local $p1)))
  (func $f48 (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (block $B0 (result i32)
      (if $I1 (result i32)
        (get_local $p0)
        (then
          (if $I2
            (i32.lt_u
              (get_local $p1)
              (i32.const 128))
            (then
              (i32.store8
                (get_local $p0)
                (get_local $p1))
              (br $B0
                (i32.const 1))))
          (if $I3
            (i32.eqz
              (i32.load
                (i32.load offset=188
                  (i32.const 1152))))
            (then
              (if $I4
                (i32.eq
                  (i32.and
                    (get_local $p1)
                    (i32.const -128))
                  (i32.const 57216))
                (then
                  (i32.store8
                    (get_local $p0)
                    (get_local $p1))
                  (br $B0
                    (i32.const 1)))
                (else
                  (i32.store
                    (i32.const 4488)
                    (i32.const 84))
                  (br $B0
                    (i32.const -1))))
              (unreachable)))
          (if $I5
            (i32.lt_u
              (get_local $p1)
              (i32.const 2048))
            (then
              (i32.store8
                (get_local $p0)
                (i32.or
                  (i32.shr_u
                    (get_local $p1)
                    (i32.const 6))
                  (i32.const 192)))
              (i32.store8 offset=1
                (get_local $p0)
                (i32.or
                  (i32.and
                    (get_local $p1)
                    (i32.const 63))
                  (i32.const 128)))
              (br $B0
                (i32.const 2))))
          (if $I6
            (i32.or
              (i32.lt_u
                (get_local $p1)
                (i32.const 55296))
              (i32.eq
                (i32.and
                  (get_local $p1)
                  (i32.const -8192))
                (i32.const 57344)))
            (then
              (i32.store8
                (get_local $p0)
                (i32.or
                  (i32.shr_u
                    (get_local $p1)
                    (i32.const 12))
                  (i32.const 224)))
              (i32.store8 offset=1
                (get_local $p0)
                (i32.or
                  (i32.and
                    (i32.shr_u
                      (get_local $p1)
                      (i32.const 6))
                    (i32.const 63))
                  (i32.const 128)))
              (i32.store8 offset=2
                (get_local $p0)
                (i32.or
                  (i32.and
                    (get_local $p1)
                    (i32.const 63))
                  (i32.const 128)))
              (br $B0
                (i32.const 3))))
          (if $I7 (result i32)
            (i32.lt_u
              (i32.add
                (get_local $p1)
                (i32.const -65536))
              (i32.const 1048576))
            (then
              (i32.store8
                (get_local $p0)
                (i32.or
                  (i32.shr_u
                    (get_local $p1)
                    (i32.const 18))
                  (i32.const 240)))
              (i32.store8 offset=1
                (get_local $p0)
                (i32.or
                  (i32.and
                    (i32.shr_u
                      (get_local $p1)
                      (i32.const 12))
                    (i32.const 63))
                  (i32.const 128)))
              (i32.store8 offset=2
                (get_local $p0)
                (i32.or
                  (i32.and
                    (i32.shr_u
                      (get_local $p1)
                      (i32.const 6))
                    (i32.const 63))
                  (i32.const 128)))
              (i32.store8 offset=3
                (get_local $p0)
                (i32.or
                  (i32.and
                    (get_local $p1)
                    (i32.const 63))
                  (i32.const 128)))
              (i32.const 4))
            (else
              (i32.store
                (i32.const 4488)
                (i32.const 84))
              (i32.const -1))))
        (else
          (i32.const 1)))))
  (func $f49 (type $t12) (param $p0 i32) (param $p1 f64) (param $p2 i32) (param $p3 i32) (param $p4 i32) (param $p5 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32) (local $l13 i32) (local $l14 i32) (local $l15 i32) (local $l16 i32) (local $l17 i32) (local $l18 i64) (local $l19 i64) (local $l20 f64)
    (set_local $l6
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 560)))
    (i32.store
      (get_local $l6)
      (i32.const 0))
    (set_local $l14
      (if $I0 (result i32)
        (i64.lt_s
          (i64.reinterpret/f64
            (tee_local $l20
              (get_local $p1)))
          (i64.const 0))
        (then
          (set_local $p1
            (f64.neg
              (get_local $p1)))
          (set_local $l13
            (i32.const 1972))
          (i32.const 1))
        (else
          (set_local $l13
            (select
              (i32.const 1975)
              (select
                (i32.const 1978)
                (i32.const 1973)
                (i32.and
                  (get_local $p4)
                  (i32.const 1)))
              (i32.and
                (get_local $p4)
                (i32.const 2048))))
          (i32.ne
            (i32.and
              (get_local $p4)
              (i32.const 2049))
            (i32.const 0)))))
    (set_local $l0
      (i32.add
        (get_local $l6)
        (i32.const 8)))
    (set_local $l11
      (tee_local $l8
        (i32.add
          (get_local $l6)
          (i32.const 524))))
    (set_local $l10
      (i32.add
        (tee_local $l2
          (i32.add
            (get_local $l6)
            (i32.const 512)))
        (i32.const 12)))
    (set_local $p0
      (block $B1 (result i32)
        (if $I2 (result i32)
          (i64.eq
            (i64.and
              (i64.reinterpret/f64
                (tee_local $l20
                  (get_local $p1)))
              (i64.const 9218868437227405312))
            (i64.const 9218868437227405312))
          (then
            (call $f15
              (get_local $p0)
              (i32.const 32)
              (get_local $p2)
              (tee_local $p3
                (i32.add
                  (get_local $l14)
                  (i32.const 3)))
              (i32.and
                (get_local $p4)
                (i32.const -65537)))
            (call $f14
              (get_local $p0)
              (get_local $l13)
              (get_local $l14))
            (call $f14
              (get_local $p0)
              (select
                (select
                  (i32.const 1999)
                  (i32.const 2003)
                  (tee_local $p5
                    (i32.ne
                      (i32.and
                        (get_local $p5)
                        (i32.const 32))
                      (i32.const 0))))
                (select
                  (i32.const 1991)
                  (i32.const 1995)
                  (get_local $p5))
                (f64.ne
                  (get_local $p1)
                  (get_local $p1)))
              (i32.const 3))
            (call $f15
              (get_local $p0)
              (i32.const 32)
              (get_local $p2)
              (get_local $p3)
              (i32.xor
                (get_local $p4)
                (i32.const 8192)))
            (get_local $p3))
          (else
            (if $I3
              (tee_local $l1
                (f64.ne
                  (tee_local $p1
                    (f64.mul
                      (call $f30
                        (get_local $p1)
                        (tee_local $l1
                          (get_local $l6)))
                      (f64.const 0x1p+1 (;=2;))))
                  (f64.const 0x0p+0 (;=0;))))
              (then
                (i32.store
                  (get_local $l6)
                  (i32.add
                    (i32.load
                      (get_local $l6))
                    (i32.const -1)))))
            (if $I4
              (i32.eq
                (tee_local $l9
                  (i32.or
                    (get_local $p5)
                    (i32.const 32)))
                (i32.const 97))
              (then
                (set_local $l4
                  (select
                    (i32.add
                      (get_local $l13)
                      (i32.const 9))
                    (get_local $l13)
                    (tee_local $l3
                      (i32.and
                        (get_local $p5)
                        (i32.const 32)))))
                (if $I5
                  (i32.eqz
                    (i32.or
                      (i32.gt_u
                        (get_local $p3)
                        (i32.const 11))
                      (i32.eqz
                        (tee_local $l0
                          (i32.sub
                            (i32.const 12)
                            (get_local $p3))))))
                  (then
                    (set_local $l20
                      (f64.const 0x1p+3 (;=8;)))
                    (loop $L6
                      (set_local $l20
                        (f64.mul
                          (get_local $l20)
                          (f64.const 0x1p+4 (;=16;))))
                      (br_if $L6
                        (tee_local $l0
                          (i32.add
                            (get_local $l0)
                            (i32.const -1)))))
                    (set_local $p1
                      (if $I7 (result f64)
                        (i32.eq
                          (i32.load8_s
                            (get_local $l4))
                          (i32.const 45))
                        (then
                          (f64.neg
                            (f64.add
                              (get_local $l20)
                              (f64.sub
                                (f64.neg
                                  (get_local $p1))
                                (get_local $l20)))))
                        (else
                          (f64.sub
                            (f64.add
                              (get_local $p1)
                              (get_local $l20))
                            (get_local $l20)))))))
                (if $I8
                  (i32.eq
                    (tee_local $l0
                      (call $f18
                        (i64.extend_s/i32
                          (select
                            (i32.sub
                              (i32.const 0)
                              (tee_local $l1
                                (i32.load
                                  (get_local $l6))))
                            (get_local $l1)
                            (i32.lt_s
                              (get_local $l1)
                              (i32.const 0))))
                        (get_local $l10)))
                    (get_local $l10))
                  (then
                    (i32.store8
                      (tee_local $l0
                        (i32.add
                          (get_local $l2)
                          (i32.const 11)))
                      (i32.const 48))))
                (set_local $l2
                  (i32.or
                    (get_local $l14)
                    (i32.const 2)))
                (i32.store8
                  (i32.add
                    (get_local $l0)
                    (i32.const -1))
                  (i32.add
                    (i32.and
                      (i32.shr_s
                        (get_local $l1)
                        (i32.const 31))
                      (i32.const 2))
                    (i32.const 43)))
                (i32.store8
                  (tee_local $l1
                    (i32.add
                      (get_local $l0)
                      (i32.const -2)))
                  (i32.add
                    (get_local $p5)
                    (i32.const 15)))
                (set_local $l5
                  (i32.lt_s
                    (get_local $p3)
                    (i32.const 1)))
                (set_local $l7
                  (i32.eqz
                    (i32.and
                      (get_local $p4)
                      (i32.const 8))))
                (set_local $p5
                  (get_local $l8))
                (loop $L9
                  (i32.store8
                    (get_local $p5)
                    (i32.or
                      (get_local $l3)
                      (i32.load8_u
                        (i32.add
                          (tee_local $l0
                            (i32.trunc_s/f64
                              (get_local $p1)))
                          (i32.const 2007)))))
                  (set_local $p1
                    (f64.mul
                      (f64.sub
                        (get_local $p1)
                        (f64.convert_s/i32
                          (get_local $l0)))
                      (f64.const 0x1p+4 (;=16;))))
                  (set_local $p5
                    (if $I10 (result i32)
                      (i32.eq
                        (i32.sub
                          (tee_local $l0
                            (i32.add
                              (get_local $p5)
                              (i32.const 1)))
                          (get_local $l11))
                        (i32.const 1))
                      (then
                        (if $I11 (result i32)
                          (i32.and
                            (get_local $l7)
                            (i32.and
                              (get_local $l5)
                              (f64.eq
                                (get_local $p1)
                                (f64.const 0x0p+0 (;=0;)))))
                          (then
                            (get_local $l0))
                          (else
                            (i32.store8
                              (get_local $l0)
                              (i32.const 46))
                            (i32.add
                              (get_local $p5)
                              (i32.const 2)))))
                      (else
                        (get_local $l0))))
                  (br_if $L9
                    (f64.ne
                      (get_local $p1)
                      (f64.const 0x0p+0 (;=0;)))))
                (set_local $l0
                  (block $B12 (result i32)
                    (if $I13
                      (i32.eqz
                        (i32.or
                          (i32.eqz
                            (get_local $p3))
                          (i32.ge_s
                            (i32.add
                              (i32.sub
                                (i32.const -2)
                                (get_local $l11))
                              (get_local $p5))
                            (get_local $p3))))
                      (then
                        (set_local $p3
                          (i32.add
                            (get_local $p3)
                            (i32.const 2)))
                        (br $B12
                          (i32.sub
                            (get_local $p5)
                            (get_local $l11)))))
                    (tee_local $p3
                      (i32.sub
                        (get_local $p5)
                        (get_local $l11)))))
                (call $f15
                  (get_local $p0)
                  (i32.const 32)
                  (get_local $p2)
                  (tee_local $p5
                    (i32.add
                      (i32.add
                        (tee_local $l3
                          (i32.sub
                            (get_local $l10)
                            (get_local $l1)))
                        (get_local $l2))
                      (get_local $p3)))
                  (get_local $p4))
                (call $f14
                  (get_local $p0)
                  (get_local $l4)
                  (get_local $l2))
                (call $f15
                  (get_local $p0)
                  (i32.const 48)
                  (get_local $p2)
                  (get_local $p5)
                  (i32.xor
                    (get_local $p4)
                    (i32.const 65536)))
                (call $f14
                  (get_local $p0)
                  (get_local $l8)
                  (get_local $l0))
                (call $f15
                  (get_local $p0)
                  (i32.const 48)
                  (i32.sub
                    (get_local $p3)
                    (get_local $l0))
                  (i32.const 0)
                  (i32.const 0))
                (call $f14
                  (get_local $p0)
                  (get_local $l1)
                  (get_local $l3))
                (call $f15
                  (get_local $p0)
                  (i32.const 32)
                  (get_local $p2)
                  (get_local $p5)
                  (i32.xor
                    (get_local $p4)
                    (i32.const 8192)))
                (br $B1
                  (get_local $p5))))
            (if $I14
              (get_local $l1)
              (then
                (i32.store
                  (get_local $l6)
                  (tee_local $l2
                    (i32.add
                      (i32.load
                        (get_local $l6))
                      (i32.const -28))))
                (set_local $p1
                  (f64.mul
                    (get_local $p1)
                    (f64.const 0x1p+28 (;=2.68435e+08;)))))
              (else
                (set_local $l2
                  (i32.load
                    (get_local $l6)))))
            (set_local $l1
              (tee_local $l4
                (select
                  (get_local $l0)
                  (i32.add
                    (get_local $l0)
                    (i32.const 288))
                  (i32.lt_s
                    (get_local $l2)
                    (i32.const 0)))))
            (loop $L15
              (i32.store
                (get_local $l1)
                (tee_local $l0
                  (i32.trunc_u/f64
                    (get_local $p1))))
              (set_local $l1
                (i32.add
                  (get_local $l1)
                  (i32.const 4)))
              (br_if $L15
                (f64.ne
                  (tee_local $p1
                    (f64.mul
                      (f64.sub
                        (get_local $p1)
                        (f64.convert_u/i32
                          (get_local $l0)))
                      (f64.const 0x1.dcd65p+29 (;=1e+09;))))
                  (f64.const 0x0p+0 (;=0;)))))
            (if $I16
              (i32.gt_s
                (get_local $l2)
                (i32.const 0))
              (then
                (set_local $l0
                  (get_local $l4))
                (loop $L17
                  (set_local $l5
                    (select
                      (get_local $l2)
                      (i32.const 29)
                      (i32.lt_s
                        (get_local $l2)
                        (i32.const 29))))
                  (if $I18
                    (i32.ge_u
                      (tee_local $l2
                        (i32.add
                          (get_local $l1)
                          (i32.const -4)))
                      (get_local $l0))
                    (then
                      (set_local $l18
                        (i64.extend_u/i32
                          (get_local $l5)))
                      (set_local $l3
                        (i32.const 0))
                      (loop $L19
                        (i64.store32
                          (get_local $l2)
                          (i64.rem_u
                            (tee_local $l19
                              (i64.add
                                (i64.shl
                                  (i64.extend_u/i32
                                    (i32.load
                                      (get_local $l2)))
                                  (get_local $l18))
                                (i64.extend_u/i32
                                  (get_local $l3))))
                            (i64.const 1000000000)))
                        (set_local $l3
                          (i32.wrap/i64
                            (i64.div_u
                              (get_local $l19)
                              (i64.const 1000000000))))
                        (br_if $L19
                          (i32.ge_u
                            (tee_local $l2
                              (i32.add
                                (get_local $l2)
                                (i32.const -4)))
                            (get_local $l0))))
                      (if $I20
                        (get_local $l3)
                        (then
                          (i32.store
                            (tee_local $l0
                              (i32.add
                                (get_local $l0)
                                (i32.const -4)))
                            (get_local $l3))))))
                  (loop $L21
                    (if $I22
                      (i32.gt_u
                        (get_local $l1)
                        (get_local $l0))
                      (then
                        (if $I23
                          (i32.eqz
                            (i32.load
                              (tee_local $l2
                                (i32.add
                                  (get_local $l1)
                                  (i32.const -4)))))
                          (then
                            (set_local $l1
                              (get_local $l2))
                            (br $L21))))))
                  (i32.store
                    (get_local $l6)
                    (tee_local $l2
                      (i32.sub
                        (i32.load
                          (get_local $l6))
                        (get_local $l5))))
                  (br_if $L17
                    (i32.gt_s
                      (get_local $l2)
                      (i32.const 0)))))
              (else
                (set_local $l0
                  (get_local $l4))))
            (set_local $l5
              (select
                (i32.const 6)
                (get_local $p3)
                (i32.lt_s
                  (get_local $p3)
                  (i32.const 0))))
            (if $I24
              (i32.lt_s
                (get_local $l2)
                (i32.const 0))
              (then
                (set_local $l7
                  (i32.add
                    (i32.div_s
                      (i32.add
                        (get_local $l5)
                        (i32.const 25))
                      (i32.const 9))
                    (i32.const 1)))
                (set_local $l15
                  (i32.eq
                    (get_local $l9)
                    (i32.const 102)))
                (set_local $p3
                  (get_local $l1))
                (loop $L25
                  (set_local $l3
                    (select
                      (tee_local $l1
                        (i32.sub
                          (i32.const 0)
                          (get_local $l2)))
                      (i32.const 9)
                      (i32.lt_s
                        (get_local $l1)
                        (i32.const 9))))
                  (if $I26
                    (i32.lt_u
                      (get_local $l0)
                      (get_local $p3))
                    (then
                      (set_local $l16
                        (i32.add
                          (i32.shl
                            (i32.const 1)
                            (get_local $l3))
                          (i32.const -1)))
                      (set_local $l12
                        (i32.shr_u
                          (i32.const 1000000000)
                          (get_local $l3)))
                      (set_local $l2
                        (i32.const 0))
                      (set_local $l1
                        (get_local $l0))
                      (loop $L27
                        (i32.store
                          (get_local $l1)
                          (i32.add
                            (i32.shr_u
                              (tee_local $l17
                                (i32.load
                                  (get_local $l1)))
                              (get_local $l3))
                            (get_local $l2)))
                        (set_local $l2
                          (i32.mul
                            (i32.and
                              (get_local $l17)
                              (get_local $l16))
                            (get_local $l12)))
                        (br_if $L27
                          (i32.lt_u
                            (tee_local $l1
                              (i32.add
                                (get_local $l1)
                                (i32.const 4)))
                            (get_local $p3))))
                      (set_local $l0
                        (select
                          (get_local $l0)
                          (i32.add
                            (get_local $l0)
                            (i32.const 4))
                          (i32.load
                            (get_local $l0))))
                      (if $I28
                        (get_local $l2)
                        (then
                          (i32.store
                            (get_local $p3)
                            (get_local $l2))
                          (set_local $p3
                            (i32.add
                              (get_local $p3)
                              (i32.const 4))))))
                    (else
                      (set_local $l0
                        (select
                          (get_local $l0)
                          (i32.add
                            (get_local $l0)
                            (i32.const 4))
                          (i32.load
                            (get_local $l0))))))
                  (set_local $l2
                    (select
                      (i32.add
                        (tee_local $l1
                          (select
                            (get_local $l4)
                            (get_local $l0)
                            (get_local $l15)))
                        (i32.shl
                          (get_local $l7)
                          (i32.const 2)))
                      (get_local $p3)
                      (i32.gt_s
                        (i32.shr_s
                          (i32.sub
                            (get_local $p3)
                            (get_local $l1))
                          (i32.const 2))
                        (get_local $l7))))
                  (i32.store
                    (get_local $l6)
                    (tee_local $l1
                      (i32.add
                        (i32.load
                          (get_local $l6))
                        (get_local $l3))))
                  (if $I29
                    (i32.lt_s
                      (get_local $l1)
                      (i32.const 0))
                    (then
                      (set_local $p3
                        (get_local $l2))
                      (set_local $l2
                        (get_local $l1))
                      (br $L25))
                    (else
                      (set_local $p3
                        (get_local $l0))))))
              (else
                (set_local $p3
                  (get_local $l0))
                (set_local $l2
                  (get_local $l1))))
            (set_local $l7
              (get_local $l4))
            (if $I30
              (i32.lt_u
                (get_local $p3)
                (get_local $l2))
              (then
                (set_local $l0
                  (i32.mul
                    (i32.shr_s
                      (i32.sub
                        (get_local $l7)
                        (get_local $p3))
                      (i32.const 2))
                    (i32.const 9)))
                (if $I31
                  (i32.ge_u
                    (tee_local $l4
                      (i32.load
                        (get_local $p3)))
                    (i32.const 10))
                  (then
                    (set_local $l1
                      (i32.const 10))
                    (loop $L32
                      (set_local $l0
                        (i32.add
                          (get_local $l0)
                          (i32.const 1)))
                      (br_if $L32
                        (i32.ge_u
                          (get_local $l4)
                          (tee_local $l1
                            (i32.mul
                              (get_local $l1)
                              (i32.const 10)))))))))
              (else
                (set_local $l0
                  (i32.const 0))))
            (set_local $l0
              (if $I33 (result i32)
                (i32.lt_s
                  (tee_local $l1
                    (i32.add
                      (i32.sub
                        (get_local $l5)
                        (select
                          (get_local $l0)
                          (i32.const 0)
                          (i32.ne
                            (get_local $l9)
                            (i32.const 102))))
                      (i32.shr_s
                        (i32.shl
                          (i32.and
                            (tee_local $l15
                              (i32.ne
                                (get_local $l5)
                                (i32.const 0)))
                            (tee_local $l16
                              (i32.eq
                                (get_local $l9)
                                (i32.const 103))))
                          (i32.const 31))
                        (i32.const 31))))
                  (i32.add
                    (i32.mul
                      (i32.shr_s
                        (i32.sub
                          (get_local $l2)
                          (get_local $l7))
                        (i32.const 2))
                      (i32.const 9))
                    (i32.const -9)))
                (then
                  (set_local $l9
                    (i32.div_s
                      (tee_local $l1
                        (i32.add
                          (get_local $l1)
                          (i32.const 9216)))
                      (i32.const 9)))
                  (if $I34
                    (i32.lt_s
                      (tee_local $l1
                        (i32.rem_s
                          (get_local $l1)
                          (i32.const 9)))
                      (i32.const 8))
                    (then
                      (set_local $l4
                        (i32.const 10))
                      (loop $L35
                        (set_local $l3
                          (i32.add
                            (get_local $l1)
                            (i32.const 1)))
                        (set_local $l4
                          (i32.mul
                            (get_local $l4)
                            (i32.const 10)))
                        (if $I36
                          (i32.lt_s
                            (get_local $l1)
                            (i32.const 7))
                          (then
                            (set_local $l1
                              (get_local $l3))
                            (br $L35)))))
                    (else
                      (set_local $l4
                        (i32.const 10))))
                  (set_local $l3
                    (i32.rem_u
                      (tee_local $l9
                        (i32.load
                          (tee_local $l1
                            (i32.add
                              (i32.add
                                (get_local $l7)
                                (i32.shl
                                  (get_local $l9)
                                  (i32.const 2)))
                              (i32.const -4092)))))
                      (get_local $l4)))
                  (if $I37
                    (i32.eqz
                      (i32.and
                        (tee_local $l12
                          (i32.eq
                            (i32.add
                              (get_local $l1)
                              (i32.const 4))
                            (get_local $l2)))
                        (i32.eqz
                          (get_local $l3))))
                    (then
                      (set_local $p1
                        (select
                          (f64.const 0x1.0000000000001p+53 (;=9.0072e+15;))
                          (f64.const 0x1p+53 (;=9.0072e+15;))
                          (i32.and
                            (i32.div_u
                              (get_local $l9)
                              (get_local $l4))
                            (i32.const 1))))
                      (set_local $l20
                        (select
                          (f64.const 0x1p-1 (;=0.5;))
                          (select
                            (f64.const 0x1p+0 (;=1;))
                            (f64.const 0x1.8p+0 (;=1.5;))
                            (i32.and
                              (get_local $l12)
                              (i32.eq
                                (get_local $l3)
                                (tee_local $l12
                                  (i32.div_s
                                    (get_local $l4)
                                    (i32.const 2))))))
                          (i32.lt_u
                            (get_local $l3)
                            (get_local $l12))))
                      (if $I38
                        (get_local $l14)
                        (then
                          (set_local $l20
                            (select
                              (f64.neg
                                (get_local $l20))
                              (get_local $l20)
                              (tee_local $l12
                                (i32.eq
                                  (i32.load8_s
                                    (get_local $l13))
                                  (i32.const 45)))))
                          (set_local $p1
                            (select
                              (f64.neg
                                (get_local $p1))
                              (get_local $p1)
                              (get_local $l12)))))
                      (i32.store
                        (get_local $l1)
                        (tee_local $l3
                          (i32.sub
                            (get_local $l9)
                            (get_local $l3))))
                      (if $I39
                        (f64.ne
                          (f64.add
                            (get_local $p1)
                            (get_local $l20))
                          (get_local $p1))
                        (then
                          (i32.store
                            (get_local $l1)
                            (tee_local $l0
                              (i32.add
                                (get_local $l3)
                                (get_local $l4))))
                          (if $I40
                            (i32.gt_u
                              (get_local $l0)
                              (i32.const 999999999))
                            (then
                              (loop $L41
                                (i32.store
                                  (get_local $l1)
                                  (i32.const 0))
                                (if $I42
                                  (i32.lt_u
                                    (tee_local $l1
                                      (i32.add
                                        (get_local $l1)
                                        (i32.const -4)))
                                    (get_local $p3))
                                  (then
                                    (i32.store
                                      (tee_local $p3
                                        (i32.add
                                          (get_local $p3)
                                          (i32.const -4)))
                                      (i32.const 0))))
                                (i32.store
                                  (get_local $l1)
                                  (tee_local $l0
                                    (i32.add
                                      (i32.load
                                        (get_local $l1))
                                      (i32.const 1))))
                                (br_if $L41
                                  (i32.gt_u
                                    (get_local $l0)
                                    (i32.const 999999999))))))
                          (set_local $l0
                            (i32.mul
                              (i32.shr_s
                                (i32.sub
                                  (get_local $l7)
                                  (get_local $p3))
                                (i32.const 2))
                              (i32.const 9)))
                          (if $I43
                            (i32.ge_u
                              (tee_local $l3
                                (i32.load
                                  (get_local $p3)))
                              (i32.const 10))
                            (then
                              (set_local $l4
                                (i32.const 10))
                              (loop $L44
                                (set_local $l0
                                  (i32.add
                                    (get_local $l0)
                                    (i32.const 1)))
                                (br_if $L44
                                  (i32.ge_u
                                    (get_local $l3)
                                    (tee_local $l4
                                      (i32.mul
                                        (get_local $l4)
                                        (i32.const 10))))))))))))
                  (set_local $l3
                    (get_local $l0))
                  (set_local $l1
                    (select
                      (tee_local $l0
                        (i32.add
                          (get_local $l1)
                          (i32.const 4)))
                      (get_local $l2)
                      (i32.gt_u
                        (get_local $l2)
                        (get_local $l0))))
                  (get_local $p3))
                (else
                  (set_local $l3
                    (get_local $l0))
                  (set_local $l1
                    (get_local $l2))
                  (get_local $p3))))
            (loop $L45
              (block $B46
                (if $I47
                  (i32.le_u
                    (get_local $l1)
                    (get_local $l0))
                  (then
                    (set_local $l9
                      (i32.const 0))
                    (br $B46)))
                (if $I48
                  (i32.load
                    (tee_local $p3
                      (i32.add
                        (get_local $l1)
                        (i32.const -4))))
                  (then
                    (set_local $l9
                      (i32.const 1)))
                  (else
                    (set_local $l1
                      (get_local $p3))
                    (br $L45)))))
            (set_local $l12
              (i32.sub
                (i32.const 0)
                (get_local $l3)))
            (set_local $l2
              (if $I49 (result i32)
                (get_local $l16)
                (then
                  (set_local $p5
                    (if $I50 (result i32)
                      (i32.and
                        (i32.gt_s
                          (tee_local $p3
                            (i32.add
                              (get_local $l5)
                              (i32.xor
                                (get_local $l15)
                                (i32.const 1))))
                          (get_local $l3))
                        (i32.gt_s
                          (get_local $l3)
                          (i32.const -5)))
                      (then
                        (set_local $l2
                          (i32.sub
                            (i32.add
                              (get_local $p3)
                              (i32.const -1))
                            (get_local $l3)))
                        (i32.add
                          (get_local $p5)
                          (i32.const -1)))
                      (else
                        (set_local $l2
                          (i32.add
                            (get_local $p3)
                            (i32.const -1)))
                        (i32.add
                          (get_local $p5)
                          (i32.const -2)))))
                  (if $I51 (result i32)
                    (tee_local $l4
                      (i32.and
                        (get_local $p4)
                        (i32.const 8)))
                    (then
                      (set_local $p3
                        (get_local $l2))
                      (get_local $l4))
                    (else
                      (if $I52
                        (get_local $l9)
                        (then
                          (if $I53
                            (tee_local $l5
                              (i32.load
                                (i32.add
                                  (get_local $l1)
                                  (i32.const -4))))
                            (then
                              (if $I54
                                (i32.rem_u
                                  (get_local $l5)
                                  (i32.const 10))
                                (then
                                  (set_local $p3
                                    (i32.const 0)))
                                (else
                                  (set_local $p3
                                    (i32.const 0))
                                  (set_local $l4
                                    (i32.const 10))
                                  (loop $L55
                                    (set_local $p3
                                      (i32.add
                                        (get_local $p3)
                                        (i32.const 1)))
                                    (br_if $L55
                                      (i32.eqz
                                        (i32.rem_u
                                          (get_local $l5)
                                          (tee_local $l4
                                            (i32.mul
                                              (get_local $l4)
                                              (i32.const 10))))))))))
                            (else
                              (set_local $p3
                                (i32.const 9)))))
                        (else
                          (set_local $p3
                            (i32.const 9))))
                      (set_local $l4
                        (i32.add
                          (i32.mul
                            (i32.shr_s
                              (i32.sub
                                (get_local $l1)
                                (get_local $l7))
                              (i32.const 2))
                            (i32.const 9))
                          (i32.const -9)))
                      (set_local $p3
                        (if $I56 (result i32)
                          (i32.eq
                            (i32.or
                              (get_local $p5)
                              (i32.const 32))
                            (i32.const 102))
                          (then
                            (select
                              (get_local $l2)
                              (tee_local $p3
                                (select
                                  (tee_local $p3
                                    (i32.sub
                                      (get_local $l4)
                                      (get_local $p3)))
                                  (i32.const 0)
                                  (i32.gt_s
                                    (get_local $p3)
                                    (i32.const 0))))
                              (i32.lt_s
                                (get_local $l2)
                                (get_local $p3))))
                          (else
                            (select
                              (get_local $l2)
                              (tee_local $p3
                                (select
                                  (tee_local $p3
                                    (i32.sub
                                      (i32.add
                                        (get_local $l4)
                                        (get_local $l3))
                                      (get_local $p3)))
                                  (i32.const 0)
                                  (i32.gt_s
                                    (get_local $p3)
                                    (i32.const 0))))
                              (i32.lt_s
                                (get_local $l2)
                                (get_local $p3))))))
                      (i32.const 0))))
                (else
                  (set_local $p3
                    (get_local $l5))
                  (i32.and
                    (get_local $p4)
                    (i32.const 8)))))
            (call $f15
              (get_local $p0)
              (i32.const 32)
              (get_local $p2)
              (tee_local $l3
                (i32.add
                  (i32.add
                    (i32.add
                      (i32.add
                        (get_local $l14)
                        (i32.const 1))
                      (get_local $p3))
                    (i32.ne
                      (tee_local $l16
                        (i32.or
                          (get_local $p3)
                          (get_local $l2)))
                      (i32.const 0)))
                  (if $I57 (result i32)
                    (tee_local $l15
                      (i32.eq
                        (i32.or
                          (get_local $p5)
                          (i32.const 32))
                        (i32.const 102)))
                    (then
                      (set_local $l5
                        (i32.const 0))
                      (select
                        (get_local $l3)
                        (i32.const 0)
                        (i32.gt_s
                          (get_local $l3)
                          (i32.const 0))))
                    (else
                      (if $I58
                        (i32.lt_s
                          (i32.sub
                            (get_local $l10)
                            (tee_local $l4
                              (call $f18
                                (i64.extend_s/i32
                                  (select
                                    (get_local $l12)
                                    (get_local $l3)
                                    (i32.lt_s
                                      (get_local $l3)
                                      (i32.const 0))))
                                (get_local $l10))))
                          (i32.const 2))
                        (then
                          (loop $L59
                            (i32.store8
                              (tee_local $l4
                                (i32.add
                                  (get_local $l4)
                                  (i32.const -1)))
                              (i32.const 48))
                            (br_if $L59
                              (i32.lt_s
                                (i32.sub
                                  (get_local $l10)
                                  (get_local $l4))
                                (i32.const 2))))))
                      (i32.store8
                        (i32.add
                          (get_local $l4)
                          (i32.const -1))
                        (i32.add
                          (i32.and
                            (i32.shr_s
                              (get_local $l3)
                              (i32.const 31))
                            (i32.const 2))
                          (i32.const 43)))
                      (i32.store8
                        (tee_local $l5
                          (i32.add
                            (get_local $l4)
                            (i32.const -2)))
                        (get_local $p5))
                      (i32.sub
                        (get_local $l10)
                        (get_local $l5))))))
              (get_local $p4))
            (call $f14
              (get_local $p0)
              (get_local $l13)
              (get_local $l14))
            (call $f15
              (get_local $p0)
              (i32.const 48)
              (get_local $p2)
              (get_local $l3)
              (i32.xor
                (get_local $p4)
                (i32.const 65536)))
            (if $I60
              (get_local $l15)
              (then
                (set_local $l10
                  (tee_local $l2
                    (i32.add
                      (get_local $l8)
                      (i32.const 9))))
                (set_local $l4
                  (i32.add
                    (get_local $l8)
                    (i32.const 8)))
                (set_local $l0
                  (tee_local $l5
                    (select
                      (get_local $l7)
                      (get_local $l0)
                      (i32.gt_u
                        (get_local $l0)
                        (get_local $l7)))))
                (loop $L61
                  (set_local $p5
                    (call $f18
                      (i64.extend_u/i32
                        (i32.load
                          (get_local $l0)))
                      (get_local $l2)))
                  (if $I62
                    (i32.eq
                      (get_local $l0)
                      (get_local $l5))
                    (then
                      (if $I63
                        (i32.eq
                          (get_local $p5)
                          (get_local $l2))
                        (then
                          (i32.store8
                            (get_local $l4)
                            (i32.const 48))
                          (set_local $p5
                            (get_local $l4)))))
                    (else
                      (if $I64
                        (i32.gt_u
                          (get_local $p5)
                          (get_local $l8))
                        (then
                          (drop
                            (call $_memset
                              (get_local $l8)
                              (i32.const 48)
                              (i32.sub
                                (get_local $p5)
                                (get_local $l11))))
                          (loop $L65
                            (br_if $L65
                              (i32.gt_u
                                (tee_local $p5
                                  (i32.add
                                    (get_local $p5)
                                    (i32.const -1)))
                                (get_local $l8))))))))
                  (call $f14
                    (get_local $p0)
                    (get_local $p5)
                    (i32.sub
                      (get_local $l10)
                      (get_local $p5)))
                  (if $I66
                    (i32.le_u
                      (tee_local $p5
                        (i32.add
                          (get_local $l0)
                          (i32.const 4)))
                      (get_local $l7))
                    (then
                      (set_local $l0
                        (get_local $p5))
                      (br $L61))))
                (if $I67
                  (get_local $l16)
                  (then
                    (call $f14
                      (get_local $p0)
                      (i32.const 2023)
                      (i32.const 1))))
                (if $I68
                  (i32.and
                    (i32.lt_u
                      (get_local $p5)
                      (get_local $l1))
                    (i32.gt_s
                      (get_local $p3)
                      (i32.const 0)))
                  (then
                    (loop $L69
                      (if $I70
                        (i32.gt_u
                          (tee_local $l0
                            (call $f18
                              (i64.extend_u/i32
                                (i32.load
                                  (get_local $p5)))
                              (get_local $l2)))
                          (get_local $l8))
                        (then
                          (drop
                            (call $_memset
                              (get_local $l8)
                              (i32.const 48)
                              (i32.sub
                                (get_local $l0)
                                (get_local $l11))))
                          (loop $L71
                            (br_if $L71
                              (i32.gt_u
                                (tee_local $l0
                                  (i32.add
                                    (get_local $l0)
                                    (i32.const -1)))
                                (get_local $l8))))))
                      (call $f14
                        (get_local $p0)
                        (get_local $l0)
                        (select
                          (get_local $p3)
                          (i32.const 9)
                          (i32.lt_s
                            (get_local $p3)
                            (i32.const 9))))
                      (set_local $l0
                        (i32.add
                          (get_local $p3)
                          (i32.const -9)))
                      (if $I72
                        (i32.and
                          (i32.lt_u
                            (tee_local $p5
                              (i32.add
                                (get_local $p5)
                                (i32.const 4)))
                            (get_local $l1))
                          (i32.gt_s
                            (get_local $p3)
                            (i32.const 9)))
                        (then
                          (set_local $p3
                            (get_local $l0))
                          (br $L69))
                        (else
                          (set_local $p3
                            (get_local $l0)))))))
                (call $f15
                  (get_local $p0)
                  (i32.const 48)
                  (i32.add
                    (get_local $p3)
                    (i32.const 9))
                  (i32.const 9)
                  (i32.const 0)))
              (else
                (set_local $l14
                  (select
                    (get_local $l1)
                    (i32.add
                      (get_local $l0)
                      (i32.const 4))
                    (get_local $l9)))
                (if $I73
                  (i32.gt_s
                    (get_local $p3)
                    (i32.const -1))
                  (then
                    (set_local $l13
                      (i32.eqz
                        (get_local $l2)))
                    (set_local $l9
                      (tee_local $l7
                        (i32.add
                          (get_local $l8)
                          (i32.const 9))))
                    (set_local $l11
                      (i32.sub
                        (i32.const 0)
                        (get_local $l11)))
                    (set_local $l2
                      (i32.add
                        (get_local $l8)
                        (i32.const 8)))
                    (set_local $p5
                      (get_local $p3))
                    (set_local $l1
                      (get_local $l0))
                    (loop $L74
                      (if $I75
                        (i32.eq
                          (tee_local $p3
                            (call $f18
                              (i64.extend_u/i32
                                (i32.load
                                  (get_local $l1)))
                              (get_local $l7)))
                          (get_local $l7))
                        (then
                          (i32.store8
                            (get_local $l2)
                            (i32.const 48))
                          (set_local $p3
                            (get_local $l2))))
                      (block $B76
                        (if $I77
                          (i32.eq
                            (get_local $l1)
                            (get_local $l0))
                          (then
                            (set_local $l4
                              (i32.add
                                (get_local $p3)
                                (i32.const 1)))
                            (call $f14
                              (get_local $p0)
                              (get_local $p3)
                              (i32.const 1))
                            (if $I78
                              (i32.and
                                (get_local $l13)
                                (i32.lt_s
                                  (get_local $p5)
                                  (i32.const 1)))
                              (then
                                (set_local $p3
                                  (get_local $l4))
                                (br $B76)))
                            (call $f14
                              (get_local $p0)
                              (i32.const 2023)
                              (i32.const 1))
                            (set_local $p3
                              (get_local $l4)))
                          (else
                            (br_if $B76
                              (i32.le_u
                                (get_local $p3)
                                (get_local $l8)))
                            (drop
                              (call $_memset
                                (get_local $l8)
                                (i32.const 48)
                                (i32.add
                                  (get_local $p3)
                                  (get_local $l11))))
                            (loop $L79
                              (br_if $L79
                                (i32.gt_u
                                  (tee_local $p3
                                    (i32.add
                                      (get_local $p3)
                                      (i32.const -1)))
                                  (get_local $l8)))))))
                      (call $f14
                        (get_local $p0)
                        (get_local $p3)
                        (select
                          (tee_local $p3
                            (i32.sub
                              (get_local $l9)
                              (get_local $p3)))
                          (get_local $p5)
                          (i32.gt_s
                            (get_local $p5)
                            (get_local $p3))))
                      (br_if $L74
                        (i32.and
                          (i32.lt_u
                            (tee_local $l1
                              (i32.add
                                (get_local $l1)
                                (i32.const 4)))
                            (get_local $l14))
                          (i32.gt_s
                            (tee_local $p5
                              (i32.sub
                                (get_local $p5)
                                (get_local $p3)))
                            (i32.const -1))))
                      (set_local $p3
                        (get_local $p5)))))
                (call $f15
                  (get_local $p0)
                  (i32.const 48)
                  (i32.add
                    (get_local $p3)
                    (i32.const 18))
                  (i32.const 18)
                  (i32.const 0))
                (call $f14
                  (get_local $p0)
                  (get_local $l5)
                  (i32.sub
                    (get_local $l10)
                    (get_local $l5)))))
            (call $f15
              (get_local $p0)
              (i32.const 32)
              (get_local $p2)
              (get_local $l3)
              (i32.xor
                (get_local $p4)
                (i32.const 8192)))
            (get_local $l3)))))
    (set_global $g4
      (get_local $l6))
    (select
      (get_local $p2)
      (get_local $p0)
      (i32.lt_s
        (get_local $p0)
        (get_local $p2))))
  (func $f50 (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32)
    (set_local $l1
      (i32.and
        (get_local $p1)
        (i32.const 255)))
    (block $B0
      (block $B1
        (if $I2
          (i32.and
            (tee_local $l0
              (i32.ne
                (get_local $p2)
                (i32.const 0)))
            (i32.ne
              (i32.and
                (get_local $p0)
                (i32.const 3))
              (i32.const 0)))
          (then
            (set_local $l2
              (i32.and
                (get_local $p1)
                (i32.const 255)))
            (loop $L3
              (br_if $B1
                (i32.eq
                  (i32.load8_u
                    (get_local $p0))
                  (get_local $l2)))
              (br_if $L3
                (i32.and
                  (tee_local $l0
                    (i32.ne
                      (tee_local $p2
                        (i32.add
                          (get_local $p2)
                          (i32.const -1)))
                      (i32.const 0)))
                  (i32.ne
                    (i32.and
                      (tee_local $p0
                        (i32.add
                          (get_local $p0)
                          (i32.const 1)))
                      (i32.const 3))
                    (i32.const 0)))))))
        (br_if $B1
          (get_local $l0))
        (set_local $p1
          (i32.const 0))
        (br $B0))
      (if $I4
        (i32.eq
          (i32.load8_u
            (get_local $p0))
          (tee_local $l0
            (i32.and
              (get_local $p1)
              (i32.const 255))))
        (then
          (set_local $p1
            (get_local $p2)))
        (else
          (set_local $l1
            (i32.mul
              (get_local $l1)
              (i32.const 16843009)))
          (block $B5
            (block $B6
              (if $I7
                (i32.gt_u
                  (get_local $p2)
                  (i32.const 3))
                (then
                  (set_local $p1
                    (get_local $p2))
                  (loop $L8
                    (if $I9
                      (i32.eqz
                        (i32.and
                          (i32.xor
                            (i32.and
                              (tee_local $p2
                                (i32.xor
                                  (i32.load
                                    (get_local $p0))
                                  (get_local $l1)))
                              (i32.const -2139062144))
                            (i32.const -2139062144))
                          (i32.add
                            (get_local $p2)
                            (i32.const -16843009))))
                      (then
                        (set_local $p0
                          (i32.add
                            (get_local $p0)
                            (i32.const 4)))
                        (br_if $L8
                          (i32.gt_u
                            (tee_local $p1
                              (i32.add
                                (get_local $p1)
                                (i32.const -4)))
                            (i32.const 3)))
                        (br $B6)))))
                (else
                  (set_local $p1
                    (get_local $p2))
                  (br $B6)))
              (br $B5))
            (if $I10
              (i32.eqz
                (get_local $p1))
              (then
                (set_local $p1
                  (i32.const 0))
                (br $B0))))
          (loop $L11
            (br_if $B0
              (i32.eq
                (i32.load8_u
                  (get_local $p0))
                (get_local $l0)))
            (set_local $p0
              (i32.add
                (get_local $p0)
                (i32.const 1)))
            (br_if $L11
              (tee_local $p1
                (i32.add
                  (get_local $p1)
                  (i32.const -1))))
            (set_local $p1
              (i32.const 0))))))
    (select
      (get_local $p0)
      (i32.const 0)
      (get_local $p1)))
  (func $f51 (type $t10) (param $p0 i64) (param $p1 i32) (result i32)
    (if $I0
      (i64.ne
        (get_local $p0)
        (i64.const 0))
      (then
        (loop $L1
          (i32.store8
            (tee_local $p1
              (i32.add
                (get_local $p1)
                (i32.const -1)))
            (i32.or
              (i32.and
                (i32.wrap/i64
                  (get_local $p0))
                (i32.const 7))
              (i32.const 48)))
          (br_if $L1
            (i64.ne
              (tee_local $p0
                (i64.shr_u
                  (get_local $p0)
                  (i64.const 3)))
              (i64.const 0))))))
    (get_local $p1))
  (func $f52 (type $t9) (param $p0 i64) (param $p1 i32) (param $p2 i32) (result i32)
    (if $I0
      (i64.ne
        (get_local $p0)
        (i64.const 0))
      (then
        (loop $L1
          (i32.store8
            (tee_local $p1
              (i32.add
                (get_local $p1)
                (i32.const -1)))
            (i32.or
              (i32.load8_u
                (i32.add
                  (i32.and
                    (i32.wrap/i64
                      (get_local $p0))
                    (i32.const 15))
                  (i32.const 2007)))
              (get_local $p2)))
          (br_if $L1
            (i64.ne
              (tee_local $p0
                (i64.shr_u
                  (get_local $p0)
                  (i64.const 4)))
              (i64.const 0))))))
    (get_local $p1))
  (func $f53 (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32)
    (set_local $l1
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 224)))
    (set_local $l2
      (i32.add
        (get_local $l1)
        (i32.const 136)))
    (i64.store align=4
      (tee_local $l0
        (i32.add
          (get_local $l1)
          (i32.const 80)))
      (i64.const 0))
    (i64.store offset=8 align=4
      (get_local $l0)
      (i64.const 0))
    (i64.store offset=16 align=4
      (get_local $l0)
      (i64.const 0))
    (i64.store offset=24 align=4
      (get_local $l0)
      (i64.const 0))
    (i64.store offset=32 align=4
      (get_local $l0)
      (i64.const 0))
    (i32.store
      (tee_local $l3
        (i32.add
          (get_local $l1)
          (i32.const 120)))
      (i32.load
        (get_local $p2)))
    (set_local $p0
      (if $I0 (result i32)
        (i32.lt_s
          (call $f25
            (i32.const 0)
            (get_local $p1)
            (get_local $l3)
            (get_local $l1)
            (get_local $l0))
          (i32.const 0))
        (then
          (i32.const -1))
        (else
          (set_local $p2
            (if $I1 (result i32)
              (i32.gt_s
                (i32.load offset=76
                  (get_local $p0))
                (i32.const -1))
              (then
                (i32.const 0))
              (else
                (i32.const 0))))
          (set_local $l4
            (i32.load
              (get_local $p0)))
          (if $I2
            (i32.lt_s
              (i32.load8_s offset=74
                (get_local $p0))
              (i32.const 1))
            (then
              (i32.store
                (get_local $p0)
                (i32.and
                  (get_local $l4)
                  (i32.const -33)))))
          (if $I3
            (i32.load
              (tee_local $l5
                (i32.add
                  (get_local $p0)
                  (i32.const 48))))
            (then
              (set_local $p1
                (call $f25
                  (get_local $p0)
                  (get_local $p1)
                  (get_local $l3)
                  (get_local $l1)
                  (get_local $l0))))
            (else
              (set_local $l7
                (i32.load
                  (tee_local $l6
                    (i32.add
                      (get_local $p0)
                      (i32.const 44)))))
              (i32.store
                (get_local $l6)
                (get_local $l2))
              (i32.store
                (tee_local $l9
                  (i32.add
                    (get_local $p0)
                    (i32.const 28)))
                (get_local $l2))
              (i32.store
                (tee_local $l8
                  (i32.add
                    (get_local $p0)
                    (i32.const 20)))
                (get_local $l2))
              (i32.store
                (get_local $l5)
                (i32.const 80))
              (i32.store
                (tee_local $l10
                  (i32.add
                    (get_local $p0)
                    (i32.const 16)))
                (i32.add
                  (get_local $l2)
                  (i32.const 80)))
              (set_local $p1
                (call $f25
                  (get_local $p0)
                  (get_local $p1)
                  (get_local $l3)
                  (get_local $l1)
                  (get_local $l0)))
              (if $I4
                (get_local $l7)
                (then
                  (drop
                    (call_indirect (type $t0)
                      (get_local $p0)
                      (i32.const 0)
                      (i32.const 0)
                      (i32.add
                        (i32.and
                          (i32.load offset=36
                            (get_local $p0))
                          (i32.const 3))
                        (i32.const 2))))
                  (set_local $p1
                    (select
                      (get_local $p1)
                      (i32.const -1)
                      (i32.load
                        (get_local $l8))))
                  (i32.store
                    (get_local $l6)
                    (get_local $l7))
                  (i32.store
                    (get_local $l5)
                    (i32.const 0))
                  (i32.store
                    (get_local $l10)
                    (i32.const 0))
                  (i32.store
                    (get_local $l9)
                    (i32.const 0))
                  (i32.store
                    (get_local $l8)
                    (i32.const 0))))))
          (i32.store
            (get_local $p0)
            (i32.or
              (tee_local $l0
                (i32.load
                  (get_local $p0)))
              (i32.and
                (get_local $l4)
                (i32.const 32))))
          (select
            (i32.const -1)
            (get_local $p1)
            (i32.and
              (get_local $l0)
              (i32.const 32))))))
    (set_global $g4
      (get_local $l1))
    (get_local $p0))
  (func $f54 (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l0 i32) (local $l1 i32)
    (if $I0
      (i32.or
        (i32.eqz
          (tee_local $l0
            (i32.load8_s
              (get_local $p0))))
        (i32.ne
          (get_local $l0)
          (tee_local $l1
            (i32.load8_s
              (get_local $p1)))))
      (then
        (set_local $p0
          (get_local $l1))
        (set_local $p1
          (get_local $l0)))
      (else
        (loop $L1
          (if $I2
            (i32.or
              (i32.eqz
                (tee_local $l0
                  (i32.load8_s
                    (tee_local $p0
                      (i32.add
                        (get_local $p0)
                        (i32.const 1))))))
              (i32.ne
                (get_local $l0)
                (tee_local $l1
                  (i32.load8_s
                    (tee_local $p1
                      (i32.add
                        (get_local $p1)
                        (i32.const 1)))))))
            (then
              (set_local $p0
                (get_local $l1))
              (set_local $p1
                (get_local $l0)))
            (else
              (br $L1))))))
    (i32.sub
      (i32.and
        (get_local $p1)
        (i32.const 255))
      (i32.and
        (get_local $p0)
        (i32.const 255))))
  (func $f55 (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l0 i32) (local $l1 i32)
    (set_local $l0
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 32)))
    (set_local $l1
      (i32.add
        (get_local $l0)
        (i32.const 16)))
    (i32.store offset=36
      (get_local $p0)
      (i32.const 3))
    (if $I0
      (i32.eqz
        (i32.and
          (i32.load
            (get_local $p0))
          (i32.const 64)))
      (then
        (i32.store
          (get_local $l0)
          (i32.load offset=60
            (get_local $p0)))
        (i32.store offset=4
          (get_local $l0)
          (i32.const 21523))
        (i32.store offset=8
          (get_local $l0)
          (get_local $l1))
        (if $I1
          (call $env.___syscall54
            (i32.const 54)
            (get_local $l0))
          (then
            (i32.store8 offset=75
              (get_local $p0)
              (i32.const -1))))))
    (set_local $p0
      (call $f34
        (get_local $p0)
        (get_local $p1)
        (get_local $p2)))
    (set_global $g4
      (get_local $l0))
    (get_local $p0))
  (func $___errno_location (export "___errno_location") (type $t3) (result i32)
    (i32.const 4488))
  (func $f57 (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l0 i32)
    (set_local $l0
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 32)))
    (i32.store
      (get_local $l0)
      (i32.load offset=60
        (get_local $p0)))
    (i32.store offset=4
      (get_local $l0)
      (i32.const 0))
    (i32.store offset=8
      (get_local $l0)
      (get_local $p1))
    (i32.store offset=12
      (get_local $l0)
      (tee_local $p0
        (i32.add
          (get_local $l0)
          (i32.const 20))))
    (i32.store offset=16
      (get_local $l0)
      (get_local $p2))
    (set_local $p0
      (if $I0 (result i32)
        (i32.lt_s
          (call $f21
            (call $env.___syscall140
              (i32.const 140)
              (get_local $l0)))
          (i32.const 0))
        (then
          (i32.store
            (get_local $p0)
            (i32.const -1))
          (i32.const -1))
        (else
          (i32.load
            (get_local $p0)))))
    (set_global $g4
      (get_local $l0))
    (get_local $p0))
  (func $f58 (type $t1) (param $p0 i32) (result i32)
    (local $l0 i32)
    (set_local $l0
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (i32.const 16)))
    (i32.store
      (get_local $l0)
      (tee_local $p0
        (i32.load offset=60
          (get_local $p0))))
    (set_local $p0
      (call $f21
        (call $env.___syscall6
          (i32.const 6)
          (get_local $l0))))
    (set_global $g4
      (get_local $l0))
    (get_local $p0))
  (func $f59 (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32)
    (if $I0
      (i32.and
        (i32.add
          (tee_local $l0
            (select
              (get_local $p0)
              (i32.const 16)
              (i32.gt_u
                (get_local $p0)
                (i32.const 16))))
          (i32.const -1))
        (get_local $l0))
      (then
        (set_local $p0
          (i32.const 16))
        (loop $L1
          (set_local $l1
            (i32.shl
              (get_local $p0)
              (i32.const 1)))
          (if $I2
            (i32.lt_u
              (get_local $p0)
              (get_local $l0))
            (then
              (set_local $p0
                (get_local $l1))
              (br $L1)))))
      (else
        (set_local $p0
          (get_local $l0))))
    (if $I3
      (i32.le_u
        (i32.sub
          (i32.const -64)
          (get_local $p0))
        (get_local $p1))
      (then
        (i32.store
          (i32.const 4488)
          (i32.const 12))
        (return
          (i32.const 0))))
    (if $I4
      (i32.eqz
        (tee_local $l0
          (call $_malloc
            (i32.add
              (i32.add
                (tee_local $l1
                  (select
                    (i32.const 16)
                    (i32.and
                      (i32.add
                        (get_local $p1)
                        (i32.const 11))
                      (i32.const -8))
                    (i32.lt_u
                      (get_local $p1)
                      (i32.const 11))))
                (i32.const 12))
              (get_local $p0)))))
      (then
        (return
          (i32.const 0))))
    (set_local $p1
      (i32.add
        (get_local $l0)
        (i32.const -8)))
    (set_local $p1
      (if $I5 (result i32)
        (i32.and
          (i32.add
            (get_local $p0)
            (i32.const -1))
          (get_local $l0))
        (then
          (set_local $l2
            (i32.sub
              (i32.and
                (tee_local $l3
                  (i32.load
                    (tee_local $l4
                      (i32.add
                        (get_local $l0)
                        (i32.const -4)))))
                (i32.const -8))
              (tee_local $l0
                (i32.sub
                  (tee_local $p0
                    (select
                      (tee_local $l0
                        (i32.add
                          (i32.and
                            (i32.add
                              (i32.add
                                (get_local $l0)
                                (get_local $p0))
                              (i32.const -1))
                            (i32.sub
                              (i32.const 0)
                              (get_local $p0)))
                          (i32.const -8)))
                      (i32.add
                        (get_local $l0)
                        (get_local $p0))
                      (i32.gt_u
                        (i32.sub
                          (get_local $l0)
                          (get_local $p1))
                        (i32.const 15))))
                  (get_local $p1)))))
          (if $I6
            (i32.and
              (get_local $l3)
              (i32.const 3))
            (then
              (i32.store
                (tee_local $l3
                  (i32.add
                    (get_local $p0)
                    (i32.const 4)))
                (i32.or
                  (i32.or
                    (get_local $l2)
                    (i32.and
                      (i32.load
                        (get_local $l3))
                      (i32.const 1)))
                  (i32.const 2)))
              (i32.store
                (tee_local $l2
                  (i32.add
                    (i32.add
                      (get_local $p0)
                      (get_local $l2))
                    (i32.const 4)))
                (i32.or
                  (i32.load
                    (get_local $l2))
                  (i32.const 1)))
              (i32.store
                (get_local $l4)
                (i32.or
                  (i32.or
                    (get_local $l0)
                    (i32.and
                      (i32.load
                        (get_local $l4))
                      (i32.const 1)))
                  (i32.const 2)))
              (i32.store
                (get_local $l3)
                (i32.or
                  (i32.load
                    (get_local $l3))
                  (i32.const 1)))
              (call $f35
                (get_local $p1)
                (get_local $l0)))
            (else
              (i32.store
                (get_local $p0)
                (i32.add
                  (i32.load
                    (get_local $p1))
                  (get_local $l0)))
              (i32.store offset=4
                (get_local $p0)
                (get_local $l2))))
          (get_local $p0))
        (else
          (tee_local $p0
            (get_local $p1)))))
    (if $I7
      (i32.and
        (tee_local $p0
          (i32.load
            (tee_local $l2
              (i32.add
                (get_local $p0)
                (i32.const 4)))))
        (i32.const 3))
      (then
        (if $I8
          (i32.gt_u
            (tee_local $l0
              (i32.and
                (get_local $p0)
                (i32.const -8)))
            (i32.add
              (get_local $l1)
              (i32.const 16)))
          (then
            (i32.store
              (get_local $l2)
              (i32.or
                (i32.or
                  (get_local $l1)
                  (i32.and
                    (get_local $p0)
                    (i32.const 1)))
                (i32.const 2)))
            (i32.store offset=4
              (tee_local $p0
                (i32.add
                  (get_local $p1)
                  (get_local $l1)))
              (i32.or
                (tee_local $l1
                  (i32.sub
                    (get_local $l0)
                    (get_local $l1)))
                (i32.const 3)))
            (i32.store
              (tee_local $l0
                (i32.add
                  (i32.add
                    (get_local $p1)
                    (get_local $l0))
                  (i32.const 4)))
              (i32.or
                (i32.load
                  (get_local $l0))
                (i32.const 1)))
            (call $f35
              (get_local $p0)
              (get_local $l1))))))
    (i32.add
      (get_local $p1)
      (i32.const 8)))
  (func $_memalign (export "_memalign") (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (if $I0 (result i32)
      (i32.lt_u
        (get_local $p0)
        (i32.const 9))
      (then
        (call $_malloc
          (get_local $p1)))
      (else
        (call $f59
          (get_local $p0)
          (get_local $p1)))))
  (func $stackAlloc (export "stackAlloc") (type $t1) (param $p0 i32) (result i32)
    (local $l0 i32)
    (set_local $l0
      (get_global $g4))
    (set_global $g4
      (i32.add
        (get_global $g4)
        (get_local $p0)))
    (set_global $g4
      (i32.and
        (i32.add
          (get_global $g4)
          (i32.const 15))
        (i32.const -16)))
    (get_local $l0))
  (global $g3 (mut i32) (get_global $env.DYNAMICTOP_PTR))
  (global $g4 (mut i32) (get_global $env.STACKTOP))
  (elem (get_global $env.tableBase) $f39 $f58 $f38 $f55 $f57 $f34)
  (data (i32.const 1024) "\04\04\00\00\05")
  (data (i32.const 1040) "\01")
  (data (i32.const 1064) "\01\00\00\00\02\00\00\00\94\11\00\00\00\04")
  (data (i32.const 1088) "\01")
  (data (i32.const 1103) "\0a\ff\ff\ff\ff")
  (data (i32.const 1340) "p\11")
  (data (i32.const 1396) "index: %p \0a\00%u, %u, flush L3, %u, %u\0a\00resolution SAB-timer: %f ns\0a\00random access\00linear access\00\11\00\0a\00\11\11\11\00\00\00\00\05\00\00\00\00\00\00\09\00\00\00\00\0b")
  (data (i32.const 1523) "\11\00\0f\0a\11\11\11\03\0a\07\00\01\13\09\0b\0b\00\00\09\06\0b\00\00\0b\00\06\11\00\00\00\11\11\11")
  (data (i32.const 1572) "\0b")
  (data (i32.const 1581) "\11\00\0a\0a\11\11\11\00\0a\00\00\02\00\09\0b\00\00\00\09\00\0b\00\00\0b")
  (data (i32.const 1630) "\0c")
  (data (i32.const 1642) "\0c\00\00\00\00\0c\00\00\00\00\09\0c\00\00\00\00\00\0c\00\00\0c")
  (data (i32.const 1688) "\0e")
  (data (i32.const 1700) "\0d\00\00\00\04\0d\00\00\00\00\09\0e\00\00\00\00\00\0e\00\00\0e")
  (data (i32.const 1746) "\10")
  (data (i32.const 1758) "\0f\00\00\00\00\0f\00\00\00\00\09\10\00\00\00\00\00\10\00\00\10\00\00\12\00\00\00\12\12\12")
  (data (i32.const 1813) "\12\00\00\00\12\12\12\00\00\00\00\00\00\09")
  (data (i32.const 1862) "\0b")
  (data (i32.const 1874) "\0a\00\00\00\00\0a\00\00\00\00\09\0b\00\00\00\00\00\0b\00\00\0b")
  (data (i32.const 1920) "\0c")
  (data (i32.const 1932) "\0c\00\00\00\00\0c\00\00\00\00\09\0c\00\00\00\00\00\0c\00\00\0c\00\00-+   0X0x\00(null)\00-0X+0X 0X-0x+0x 0x\00inf\00INF\00nan\00NAN\000123456789ABCDEF.\00T!\22\19\0d\01\02\03\11K\1c\0c\10\04\0b\1d\12\1e'hnopqb \05\06\0f\13\14\15\1a\08\16\07($\17\18\09\0a\0e\1b\1f%#\83\82}&*+<=>?CGJMXYZ[\5c]^_`acdefgijklrstyz{|\00Illegal byte sequence\00Domain error\00Result not representable\00Not a tty\00Permission denied\00Operation not permitted\00No such file or directory\00No such process\00File exists\00Value too large for data type\00No space left on device\00Out of memory\00Resource busy\00Interrupted system call\00Resource temporarily unavailable\00Invalid seek\00Cross-device link\00Read-only file system\00Directory not empty\00Connection reset by peer\00Operation timed out\00Connection refused\00Host is down\00Host is unreachable\00Address in use\00Broken pipe\00I/O error\00No such device or address\00Block device required\00No such device\00Not a directory\00Is a directory\00Text file busy\00Exec format error\00Invalid argument\00Argument list too long\00Symbolic link loop\00Filename too long\00Too many open files in system\00No file descriptors available\00Bad file descriptor\00No child process\00Bad address\00File too large\00Too many links\00No locks available\00Resource deadlock would occur\00State not recoverable\00Previous owner died\00Operation canceled\00Function not implemented\00No message of desired type\00Identifier removed\00Device not a stream\00No data available\00Device timeout\00Out of streams resources\00Link has been severed\00Protocol error\00Bad message\00File descriptor in bad state\00Not a socket\00Destination address required\00Message too large\00Protocol wrong type for socket\00Protocol not available\00Protocol not supported\00Socket type not supported\00Not supported\00Protocol family not supported\00Address family not supported by protocol\00Address not available\00Network is down\00Network unreachable\00Connection reset by network\00Connection aborted\00No buffer space available\00Socket is connected\00Socket not connected\00Cannot send after socket shutdown\00Operation already in progress\00Operation in progress\00Stale file handle\00Remote I/O error\00Quota exceeded\00No medium found\00Wrong medium type\00No error information"))
