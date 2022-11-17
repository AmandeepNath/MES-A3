.data

lab_ticks: .word 0
lab_ticks_blinks: .word 0

.text


@ Define magic numbers as constants
.equ    I2C_Address, 0x32
.equ    X_HI, 0x29
.equ    Y_HI, 0x2B
.equ    READ_DELAY, 0xFFFFF





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

    .global lab7_tick                 @ Make the symbol name for the function visible to the linker

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type lab7_tick, %function     @ Declares that the symbol is a function (not strictly required)


lab7_tick:


    ldr     r1, =lab_ticks                  @ get the address of lab ticks
    str     r0, [r1]                        @ store contents of r0 to address of lab ticks


    bx      lr                             @ Return (Branch eXchange) to the address in the link register (lr)










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

    .global _an_lab_setup                 @ Make the symbol name for the function visible to the linker

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type _an_lab_setup, %function     @ Declares that the symbol is a function (not strictly required)


_an_lab_setup:


    ldr     r1, =lab_ticks                  @ get the address of lab ticks
    str     r0, [r1]                        @ store contents of r0 to address of lab ticks



    bx      lr                             @ Return (Branch eXchange) to the address in the link register (lr)















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

    .global _an_lab_tick                 @ Make the symbol name for the function visible to the linker

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type _an_lab_tick, %function     @ Declares that the symbol is a function (not strictly required)


@ Function Declaration : int _an_lab_tick(int lab7_input)
@
@ Input: r0 (i.e. r0 holds a value)
@ Returns: r0
@

@ Here is the actual function

_an_lab_tick:

    push    {r4-r7, lr}                     @ Put aside registers we want to restore later
    

    ldr     r1, =lab_ticks                  @ get the address of lab ticks
    ldr     r0, [r1]                        @ load current ticks value 

    subs    r0, r0, #1                      @ subtract 1 from the ticks
    ble     out                             @ go to out if it is 0


    str     r0, [r1]                        @ store value back into r1

    ldr     r1, =lab_ticks_blinks           @ get address of lab ticks blinks
    ldr     r0, [r1]                        @ load current ticks value

    subs    r0, r0, #1                      @ subtract 1 from ticks
    str     r0, [r1]                        @ store the current decremented count

    bgt     out                             @ go to out if the tick isn't 0

    
    mov     r0, #I2C_Address                @ copy I2C address into r0
    mov     r1, #X_HI                       @ use r1 to hold high bit value of accelerometer
    bl      COMPASSACCELERO_IO_Read         @ call COMPASSACCELERO_IO_Read to read input of accelerometer
    sxtb    r0, r0                          @ extend the signed 8 bit value in r0 to be a signed 32 bit value

    mov     r0, #1                          @ copy LED index 1 to r0
    bl      BSP_LED_Toggle                  @ call BSP_LED_Toggle to turn LED on/off


    ldr     r1, =lab_ticks_blinks           @ get address of lab ticks blinks
    mov     r0, #250                        @ reset the tick value
    str     r0, [r1]                        @ store current value back into r1


    @mov     r0, #0                          @ copy 0 to r0 to turn on LED 0
    @bl      BSP_LED_Toggle                  @ call bsp led toggle to turn on LED
    @ldr     r1, =lab_ticks_blinks           @ get address of lab ticks blinks
    @mov     r0, #500                        @ reset the tick value
    @str     r0, [r1]                        @ store current value back into r1




   


out:


    pop     {r4-r7, lr}                    @ Bring all the register values back

    bx      lr                             @ Return (Branch eXchange) to the address in the link register (lr)















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

    .global lab6                 @ Make the symbol name for the function visible to the linker

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type lab6, %function     @ Declares that the symbol is a function (not strictly required)


@ Function Declaration : int a3_Game(int delay, char *pattern, int target)
@
@ Input: r0, r1, r2 (i.e. r0 holds the delay, r1 holds the led pattern, r2 holds the target led)
@ Returns: r0
@

@ Here is the actual a3_Game function

lab6:

    push    {r4-r7, lr}                     @ Put aside registers we want to restore later

    

    @ldr     r0, =READ_DELAY                 @ load delay into r0 for busy_delay
    @bl      busy_delay                      @ call busy_delay


    mov     r0, #I2C_Address                @ copy I2C address into r0
    mov     r1, #X_HI                       @ use r1 to hold high bit value of accelerometer
    bl      COMPASSACCELERO_IO_Read         @ call compass accelero to read input of accelerometer

    sxtb    r0, r0                           @ extend the signed 8 bit value in r0 to be a signed 32 bit value



exit_program:

    pop     {r4-r7, lr}                     @ Bring all the register values back

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


      
.size lab6, .-lab6  @@ - symbol size (not strictly required, but makes the debugger happy)

.end                                    @ Assembly file ended by single .end directive on its own line