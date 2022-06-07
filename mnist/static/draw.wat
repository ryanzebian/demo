
(memory (export "mem") 2)
;; Memory map:
;;
;; [0x0000 .. 0x00001]  x, y mouse position
;; [0x0002 .. 0x00002]  mouse buttons
;; [0x0003 .. 0x00004]  x, y mouse click position

(func $clear-screen (param $color i32)
  (local $i i32)
  (loop $loop
    ;; mem[0x1100 + i] = 0
    (i32.store offset=0x10000 (local.get $i) (local.get $color))
    (br_if $loop
        (i32.lt_s
            (local.tee $i (i32.add (local.get $i) (i32.const  4)))
            (i32.const 3136)
        )
    )
  )
)
(func $put-pixel (param $x i32) (param $y i32) (param $color i32)
    ;; mem[0x10000+(y*28+x)*4] = $color
    (i32.store offset=0x10000 
      (i32.mul 
        (i32.add
          (i32.mul (local.get $y) (i32.const 28))
          (local.get $x)
        )
        (i32.const 4)) 
      (local.get $color))
)
(func (export "run")
  (call $put-pixel
  (i32.load8_u (i32.const 0)) ;; x
  (i32.load8_u (i32.const 1)) ;; y
  (select
    (i32.const 0xff_00_00_00) ;;black 
    (i32.const 0x00_ff_ff_ff) ;;white
    (i32.load8_u (i32.const 2)) ;; Buttons
  )
  )


  ;; clear if button number is 9
  (if 
    (i32.eq 
      (i32.load8_u (i32.const 2)) 
      (i32.const 9)) ;; clear signal
    (then
     (call $clear-screen (i32.const 0x00_ff_ff_ff)))
  )
  (if 
    (i32.eq 
      (i32.load8_u (i32.const 2)) 
      (i32.const 10)) ;; tint signal
    (then
     (call $clear-screen (i32.const 0xff_00_00_00)))
  )
)
    
