@ Initialize the variables we want to use

.data

a4_delay: .word 0
a4_reset_delay: .word 0
a4_target: .word 0
a4_ticks: .word 0
a4_accel_ticks: .word 0

.text


@ Define magic numbers as constants
.equ    I2C_Address, 0x32
.equ    X_HI, 0x29
.equ    Y_HI, 0x2B
.equ    accel_delay, 0xFA
.equ    game_time_constant, 0x3E8
.equ    negative_constant, -0x1E
.equ    positive_constant, 0x1E
.equ    win_delay, 0x666666




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



@ Function Declaration : int _an_a4_tick_setup(int delay, int target, int game_time)
@
@ Input: r0, r1, r2 (i.e.r0 holds the delay, r1 holds the target, r2 holds the game time)
@ Returns: r0
@

@ Here is the actual function

_an_a4_tick_setup:



    ldr     r3, =a4_delay                   @ load address into r3 so parameters don't get overwritten
    str     r0, [r3]                        @ store delay into a4_delay


    ldr     r3, =a4_reset_delay             @ load address into r3 so parameters don't get overwritten
    str     r0, [r3]                        @ store delay into a4_reset_delay


    ldr     r3, =a4_target                  @ load address into r3 so parameters don't get overwritten
    str     r1, [r3]                        @ store target into a4_target


    ldr     r3, =a4_accel_ticks             @ load address into r3 so parameters don't get overwritten
    mov     r0, #accel_delay                @ copy value of accel_delay into r0
    str     r0, [r3]                        @ store target into a4_accel_ticks


    ldr     r1, =a4_ticks                   @ get the address of a4_ticks
    mov     r3, #game_time_constant         @ copy 1000 to r3 to use for tick timer
    mul     r2, r3                          @ multiply game_time by 1000 to convert into seconds
    str     r2, [r1]                        @ store game time into a4_ticks


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
@ Input: none
@ Returns: r0
@

@ Here is the actual function

_an_a4_tick:

    push    {r4-r6, lr}                     @ Put aside registers we want to restore later


    ldr     r1, =a4_ticks                   @ load address of a4_ticks into r1
    ldr     r0, [r1]                        @ load current ticks value 
    subs    r0, r0, #1                      @ subtract 1 from the ticks
    ble     exit_tick                       @ go to exit_tick if it is 0
    str     r0, [r1]                        @ store value back into r1


    cmp     r0, #1                          @ compare a4 ticks to something greater than 0
    beq     lose_led                        @ if the values are equal go to lose_led
    

    ldr     r1, =a4_accel_ticks             @ load address of a4_accel_ticks into r1
    ldr     r0, [r1]                        @ load current a4_accel_ticks ticks value
    subs    r0, r0, #1                      @ subtract 1 from a4_accel_ticks
    str     r0, [r1]                        @ store the current decremented count
    bgt     exit_tick                       @ go to exit_tick if the tick isn't 0

    
    bl      accelero_check                  @ go to accelero_check to see which led to turn on

    mov     r6, r0                          @ copy LED index into r6 incase we need to use later

    ldr     r1, =a4_target                  @ load address of a4_target into r1
    ldr     r4, [r1]                        @ load the traget into r4 to use later

    cmp     r6, r4                          @ compare LED index to target
    bne     exit_target_check               @ if they are not equal, go to exit_target_check


    ldr     r1, =a4_delay                   @ load address of a4_delay
    ldr     r0, [r1]                        @ load current delay ticks value
    subs    r0, r0, #1                      @ subtract 1 from ticks
    str     r0, [r1]                        @ store the current decremented count
    bgt     exit_tick                       @ branch to exit_tick if value is greater than 0


    ldr     r1, =a4_ticks                   @ load address of a4_ticks
    mov     r0, #0                          @ copy 0 to r0 since we have won the game
    str     r0, [r1]                        @ store value back into a4_ticks

    bl      win                             @ branch to win to flash LED's

    bl      exit_tick                       @ branch to exit_tick since we are done



exit_target_check:

    ldr     r1, =a4_reset_delay             @ load address of a4_reset_delay into r1
    ldr     r0, [r1]                        @ load the reset delay into r0 to use later
    ldr     r1, =a4_delay                   @ load address of a4_delay
    str     r0, [r1]                        @ store the reset value into a4_delay



    ldr     r1, =a4_accel_ticks             @ load address of a4_accel_ticks
    mov     r0, #accel_delay                @ reset the accel tick value
    str     r0, [r1]                        @ store the value into a4_accel_ticks

    bl      exit_tick                       @ branch to exit tick


lose_led:


    bl      lose                            @ call lose function


exit_tick:


    pop     {r4-r6, lr}                    @ Bring all the register values back

    bx      lr                             @ Return (Branch eXchange) to the address in the link register (lr)





@ Function Declaration : int accelero_check
@
@ Input: NONE
@ Returns: r0 (LED index)
@
@ Here is the actual function
accelero_check:

    push    {r4-r6, lr}                     @ Put aside registers we want to restore later

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



    
    cmp     r4, #negative_constant          @ compare X accelerometer reading to the negative constant
    ble     very_negative_x                 @ if accelerometer reading is less than the negative constant, branch to very_negative_x


    cmp     r4, #positive_constant          @ compare X accelerometer reading to the positive_constant
    bgt     very_positive_x                 @ if accelerometer reading is greater than the positive_constant, branch to very_positive_x


    cmp     r4, #negative_constant          @ compare X accelerometer reading to the negative constant
    bgt     close_to_0                      @ if accelerometer reading is greater than the negative constant, branch to close_to_0

 
    bl      exit                            @ branch to exit if previous comparisons don't happen


very_negative_x:


    cmp     r5, #negative_constant          @ compare Y accelerometer reading to the negative constant
    ble     led_1                           @ if reading is less than the negative constant, branch to led_1

    cmp     r5, #positive_constant          @ compare Y accelerometer reading to the positive_constant
    bgt     led_5                           @ if reading is greater than the positive_constant, branch to led_5

    cmp     r5, #negative_constant          @ compare Y accelerometer reading to the negative constant
    bgt     led_3                           @ if reading is greater than the negative constant, branch to led_3

    bl      exit                            @ branch to exit if previous comparisons don't happen


very_positive_x:


    cmp     r5, #negative_constant          @ compare Y accelerometer reading to the negative constant
    ble     led_2                           @ if reading is less than the negative constant, branch to led_2

    cmp     r5, #positive_constant          @ compare Y accelerometer reading to the positive_constant
    bgt     led_6                           @ if reading is greater than the positive_constant, branch to led_6

    cmp     r5, #negative_constant          @ compare Y accelerometer reading to the negative constant
    bgt     led_4                           @ if reading is greater than the negative constant, branch to led_4

    bl      exit                            @ branch to exit if previous comparisons don't happen


close_to_0:


    cmp     r5, #negative_constant          @ compare Y accelerometer reading to the negative constant
    ble     led_0                           @ if reading is less than the negative constant, branch to led_0

    cmp     r5, #positive_constant          @ compare Y accelerometer reading to the positive_constant
    bgt     led_7                           @ if reading is greater than the positive_constant, branch to led_7

    cmp     r5, #negative_constant          @ compare Y accelerometer reading to the negative constant
    bgt     led_3                           @ if reading is greater than the negative constant, branch to led_3

    bl      exit                            @ branch to exit if previous comparisons don't happen


led_0:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #0                          @ copy LED index 0 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    mov     r6, #0                          @ copy LED index 0 to r6

    bl      exit                            @ go to exit to leave function


led_1:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #1                          @ copy LED index 1 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    mov     r6, #1                          @ copy LED index 1 to r6

    bl      exit                            @ go to exit to leave function


led_2:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #2                          @ copy LED index 2 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    mov     r6, #2                          @ copy LED index 2 to r6

    bl      exit                            @ go to exit to leave function


led_3:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #3                          @ copy LED index 3 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    mov     r6, #3                          @ copy LED index 3 to r6

    bl      exit                            @ go to exit to leave function


led_4:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #4                          @ copy LED index 4 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    mov     r6, #4                          @ copy LED index 4 to r6

    bl      exit                            @ go to exit to leave function


led_5:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #5                          @ copy LED index 5 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    mov     r6, #5                          @ copy LED index 5 to r6

    bl      exit                            @ go to exit to leave function


led_6:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #6                          @ copy LED index 6 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    mov     r6, #6                          @ copy LED index 6 to r6

    bl      exit                            @ go to exit to leave function


led_7:


    bl      all_off                         @ call all_off to turn off all LED's

    mov     r0, #7                          @ copy LED index 7 to r0
    bl      BSP_LED_On                      @ turn specified LED on

    mov     r6, #7                          @ copy LED index 7 to r6

    bl      exit                            @ go to exit to leave function


exit:

    mov     r0, r6                          @ copy LED index from r6 to r0 for use in the tick function

    pop     {r4-r6, lr}                     @ Bring all the register values back

    bx      lr                              @ Return (Branch eXchange) to the address in the link register (lr)





@ Function Declaration : int all_off
@
@ Input: NONE
@ Returns: r0
@
@ Here is the actual function
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







@ Function Declaration : int win
@
@ Input: NONE
@ Returns: r0
@
@ Here is the actual function
win:

    push    {r4-r5, lr}                     @ Put aside registers we want to restore later

    mov     r4, #0                          @ copy 0 to r4 for LED counter
    mov     r5, #2                          @ copy 2 to r5 for twice blink counter


    win_led_loop_on:


        mov     r0, r4                      @ r0 holds our argument for the LED on function, so pass I pass the index (r4)
        bl      BSP_LED_On                  @ call the BSP_LED_on function to turn it on


        add     r4, r4, #1                  @ add 1 to the led counter


        cmp     r4, #8                      @ compare r4 to 8 to check if the led counter is on the last led
        blt     win_led_loop_on             @ if the led counter is less than 8, branch back to win_led_loop


        ldr     r0, =win_delay              @ load our delay to r0 so the busy delay can use the delay value
        bl      busy_delay                  @ call the busy_delay function to add a delay between the next toggle


        mov     r4, #0                      @ copy 0 to r10 to reset our counter for the led
    

    win_led_loop_off:

        mov     r0, r4                      @ r0 holds our argument for the LED off function, so pass I pass the index (r4)
        bl      BSP_LED_Off                 @ call the BSP_LED_Off function to turn it off


        add     r4, r4, #1                  @ add 1 to the led counter


        cmp     r4, #8                      @ compare r4 to 8 to check if the led counter is on the last led
        blt     win_led_loop_off            @ if the led counter is less than 8, branch back to win_led_loop


        ldr     r0, =win_delay              @ load our delay to r0 so the busy delay can use the delay value
        bl      busy_delay                  @ call the busy_delay function to add a delay between the next toggle


        mov     r4, #0                      @ copy 0 to r4 to reset our counter for the led


        subs     r5, r5, #1                 @ subtract one from the twice blink counter
        bgt     win_led_loop_on             @ branch back to win loop if the value if greater than 0


    pop     {r4-r5, lr}                     @ Bring all the register values back

    bx      lr                              @ Return (Branch eXchange) to the address in the link register (lr)





@ Function Declaration : int lose
@
@ Input: NONE
@ Returns: r0
@
@ Here is the actual function
lose: 

    push    {lr}                            @ Put aside registers we want to restore later  


    bl      all_off                         @ call the all_off function to turn off all LED's

    ldr     r1, =a4_target                  @ load the address of a4_target
    ldr     r0, [r1]                        @ load target into r0
    bl      BSP_LED_On                      @ call BSP_LED_On to turn on specified LED


    pop     {lr}                            @ Bring all the register values back

    bx      lr                              @ Return (Branch eXchange) to the address in the link register (lr)



@ Function Declaration : int busy_delay(int cycles)
@
@ Input: r0 (i.e. r0 holds number of cycles to delay)
@ Returns: r0
@
@ Here is the actual function. DO NOT MODIFY THIS FUNCTION.
busy_delay:

    push {r5}

    mov r5, r0

delay_1oop:
    subs r5, r5, #1

    bge delay_1oop

    mov r0, #0                          @ Return zero (success)

    pop {r5}

    bx lr                               @ Return (Branch eXchange) to the address in the link register (lr)


.size _an_a4_tick_setup, .-_an_a4_tick_setup  @@ - symbol size (not strictly required, but makes the debugger happy)

.end                                    @ Assembly file ended by single .end directive on its own line