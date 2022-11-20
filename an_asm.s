.data

a4_delay: .word 0
a4_ticks: .word 0
a4_accel_ticks: .word 0

.text


@ Define magic numbers as constants
.equ    I2C_Address, 0x32
.equ    X_HI, 0x29
.equ    Y_HI, 0x2B
.equ    accel_delay, 0xFA
.equ    game_time_constant, 0x3E8




@ Test code for my own new function called from C
@ This is a comment. Anything after an @ symbol is ignored.
@@ This is also a comment. Some people use double @@ symbols.
    .code 16                            @ This directive selects the instruction set being generated.
                                        @ The value 16 selects Thumb, with the value 32 selecting ARM.

    .text                               @ Tell the assembler that the upcoming section is to be considered
                                        @ assembly language instructions - Code section (text -> ROM)



@@ Function Header Block
    .align 2                            @ Code alignment - 2^n alignment (n=2)
                                        @ This causes the assembler to use 4 byte alignment

    .syntax unified                     @ Sets the instruction set to the new unified ARM + THUMB
                                        @ instructions. The default is divided (separate instruction sets)

    .global _an_a4_tick_setup                 @ Make the symbol name for the function visible to the linker

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type _an_a4_tick_setup, %function     @ Declares that the symbol is a function (not strictly required)



@ Function Declaration : int _an_a4_tick_setup(int game_time)
@
@ Input: r2 (i.e. r2 holds the game time)
@ Returns: r0
@

@ Here is the actual function

_an_a4_tick_setup:

    ldr     r1, =a4_ticks                   @ get the address of a4_ticks

    mov     r3, #game_time_constant         @ copy 1000 to r3 to use for tick timer
    mul     r2, r3                          @ multiply game_time by 1000 to convert into seconds

    str     r2, [r1]                        @ store contents of r0 to address of lab ticks



    bx      lr                              @ Return (Branch eXchange) to the address in the link register (lr)







@ Test code for my own new function called from C
@ This is a comment. Anything after an @ symbol is ignored.
@@ This is also a comment. Some people use double @@ symbols.
    .code 16                            @ This directive selects the instruction set being generated.
                                        @ The value 16 selects Thumb, with the value 32 selecting ARM.

    .text                               @ Tell the assembler that the upcoming section is to be considered
                                        @ assembly language instructions - Code section (text -> ROM)



@@ Function Header Block
    .align 2                            @ Code alignment - 2^n alignment (n=2)
                                        @ This causes the assembler to use 4 byte alignment

    .syntax unified                     @ Sets the instruction set to the new unified ARM + THUMB
                                        @ instructions. The default is divided (separate instruction sets)

    .global _an_a4_tick                 @ Make the symbol name for the function visible to the linker

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type _an_a4_tick, %function     @ Declares that the symbol is a function (not strictly required)


@ Function Declaration : int _an_a4_tick()
@
@ Input: r0, r1, r2 (i.e. r0 holds the delay, r1 holds the target, r2 holds the game time)
@ Returns: r0
@

@ Here is the actual function

_an_a4_tick:

    push    {r4-r5, lr}                     @ Put aside registers we want to restore later
    
    mov     r4, r1                          @ copy target into r4

    ldr     r1, =a4_ticks                   @ get the address of lab ticks
    ldr     r0, [r1]                        @ load current ticks value 

    subs    r0, r0, #1                      @ subtract 1 from the ticks
    ble     exit_tick                       @ go to exit_tick if it is 0


    str     r0, [r1]                        @ store value back into r1

    ldr     r1, =a4_accel_ticks             @ get address of lab ticks blinks
    ldr     r0, [r1]                        @ load current ticks value

    subs    r0, r0, #1                      @ subtract 1 from ticks
    str     r0, [r1]                        @ store the current decremented count

    bgt     exit_tick                       @ go to exit_tick if the tick isn't 0

    

    bl      accelero_check                  @ go to accelero_check to see which led to turn on



    ldr     r1, =a4_accel_ticks             @ get address of lab ticks blinks
    mov     r0, #accel_delay                @ reset the tick value
    str     r0, [r1]                        @ store current value back into r1




    @mov     r0, #0                          @ copy 0 to r0 to turn on LED 0
    @bl      BSP_LED_Toggle                  @ call bsp led toggle to turn on LED
    @ldr     r1, =lab_ticks_blinks           @ get address of lab ticks blinks
    @mov     r0, #500                        @ reset the tick value
    @str     r0, [r1]                        @ store current value back into r1


exit_tick:

    pop     {r4-r5, lr}                    @ Bring all the register values back

    bx      lr                             @ Return (Branch eXchange) to the address in the link register (lr)






accelero_check:

    push    {r4-r7, lr}                     @ Put aside registers we want to restore later

    mov     r0, #I2C_Address                @ copy I2C address into r0
    mov     r1, #X_HI                       @ use r1 to hold high bit value of accelerometer
    bl      COMPASSACCELERO_IO_Read         @ call COMPASSACCELERO_IO_Read to read input of accelerometer
    sxtb    r0, r0                          @ extend the signed 8 bit value in r0 to be a signed 32 bit value                         
    mov     r4, r0                          @ copy the current X accelerometer value to r4


    mov     r0, #I2C_Address                @ copy I2C address into r0
    mov     r1, #Y_HI                       @ use r1 to hold high bit value of accelerometer
    bl      COMPASSACCELERO_IO_Read         @ call COMPASSACCELERO_IO_Read to read input of accelerometer
    sxtb    r0, r0                          @ extend the signed 8 bit value in r0 to be a signed 32 bit value                   
    mov     r5, r0                          @ copy the current Y accelerometer value to r5



    
    cmp     r4, #-33                        @ compare X accelerometer reading to -33
    ble     very_negative_x                 @ if accelerometer reading is less than -33, branch to very_negative_x


    cmp     r4, #33                         @ compare X accelerometer reading to 33
    bgt     very_positive_x                 @ if accelerometer reading is greater than 33, branch to very_positive_x


    cmp     r4, #-32                        @ compare X accelerometer reading to -33
    bgt     close_to_0                      @ if accelerometer reading is greater than -33, branch to close_to_0

 
    bl      exit                            @ branch to exit if previous comparisons don't happen


very_negative_x:


    cmp     r5, #-33                        @ compare Y accelerometer reading to -33
    ble     led_1                           @ if reading is less than -33, branch to led_1

    cmp     r5, #33                         @ compare Y accelerometer reading to 33
    bgt     led_5                           @ if reading is greater than 33, branch to led_5

    cmp     r5, #-32                        @ compare Y accelerometer reading to -33
    bgt     led_3                           @ if reading is greater than -33, branch to led_3

    bl      exit                            @ branch to exit if previous comparisons don't happen


very_positive_x:


    cmp     r5, #-33                        @ compare Y accelerometer reading to -33
    ble     led_2                           @ if reading is less than -33, branch to led_2

    cmp     r5, #33                         @ compare Y accelerometer reading to 33
    bgt     led_6                           @ if reading is greater than 33, branch to led_6

    cmp     r5, #-32                        @ compare Y accelerometer reading to -33
    bgt     led_4                           @ if reading is greater than -33, branch to led_4

    bl      exit                            @ branch to exit if previous comparisons don't happen


close_to_0:


    cmp     r5, #-33                        @ compare Y accelerometer reading to -33
    ble     led_0                           @ if reading is less than -33, branch to led_0

    cmp     r5, #33                         @ compare Y accelerometer reading to 33
    bgt     led_7                           @ if reading is greater than 33, branch to led_7

    cmp     r5, #-32                        @ compare Y accelerometer reading to -33
    bgt     led_3                           @ if reading is greater than -33, branch to led_3

    bl      exit                            @ branch to exit if previous comparisons don't happen


led_0:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #0                          @ copy LED index 0 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    bl      exit                            @ go to exit to leave function


led_1:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #1                          @ copy LED index 1 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    bl      exit                            @ go to exit to leave function


led_2:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #2                          @ copy LED index 2 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    bl      exit                            @ go to exit to leave function


led_3:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #3                          @ copy LED index 3 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    bl      exit                            @ go to exit to leave function


led_4:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #4                          @ copy LED index 4 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    bl      exit                            @ go to exit to leave function


led_5:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #5                          @ copy LED index 5 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    bl      exit                            @ go to exit to leave function


led_6:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #6                          @ copy LED index 6 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    bl      exit                            @ go to exit to leave function


led_7:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #7                          @ copy LED index 7 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    bl      exit                            @ go to exit to leave function


exit:

    pop     {r4-r7, lr}                     @ Bring all the register values back

    bx      lr                              @ Return (Branch eXchange) to the address in the link register (lr)







all_off:

    push    {r4, lr}                        @ Put aside registers we want to restore later

    mov     r4, #0                          @ copy 0 to r4 to use for LED counter

    all_off_loop:

        mov     r0, r4                      @ copy LED counter into r0
        bl      BSP_LED_Off                 @ turn off specified LED

        add     r4, r4, #1                  @ add 1 to LED counter

        cmp     r4, #8                      @ compare r4 to 8
        ble     all_off_loop                @ if r4 is less than 8, go back to all_off_loop, otherwise continue 


exit_all_off:

    pop     {r4, lr}                        @ Bring all the register values back

    bx      lr                              @ Return (Branch eXchange) to the address in the link register (lr)





.size _an_a4_tick_setup, .-_an_a4_tick_setup  @@ - symbol size (not strictly required, but makes the debugger happy)

.end                                    @ Assembly file ended by single .end directive on its own line