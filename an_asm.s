@ Initialize the variables we want to use

.data

a5_timeout: .word 0
a5_delay: .word 0

LEDaddress: .word 0x48001014

.text


@ Define magic numbers as constants




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

    .global _an_watchdog_start          @ Make the symbol name for the function visible to the linker

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type _an_watchdog_start, %function     @ Declares that the symbol is a function (not strictly required)



@ Function Declaration : int _an_watchdog_start(int timeout, int delay)
@
@ Input: r0, r1 (i.e.r0 holds timeout, r1 holds the delay)
@ Returns: r0
@

@ Here is the actual function

_an_watchdog_start:


    ldr     r3, =a5_timeout                 @ load address into r3 so parameters don't get overwritten
    str     r0, [r3]                        @ store timeout into a5_timeout


    ldr     r3, =a5_delay                   @ load address into r3 so parameters don't get overwritten
    str     r1, [r3]                        @ store delay into a5_delay









@ldr     r3, =a4_accel_ticks             @ load address into r3 so parameters don't get overwritten
@mov     r0, #accel_delay                @ copy value of accel_delay into r0
@str     r0, [r3]                        @ store target into a4_accel_ticks
@
@
@ldr     r1, =a4_ticks                   @ get the address of a4_ticks
@mov     r3, #game_time_constant         @ copy 1000 to r3 to use for tick timer
@mul     r2, r3                          @ multiply game_time by 1000 to convert into seconds
@str     r2, [r1]                        @ store game time into a4_ticks
@
@
@bx      lr                              @ Return (Branch eXchange) to the address in the link register (lr)








@@@@@@@@@@@@@@@@@@@@@@@@@ Code to turn on all LED's, use later @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @ This code turns on only one light – can you make it turn them all on at once?
    @ldr     r1, =LEDaddress	@ Load the GPIO address we need
    @ldr     r1, [r1]		@ Dereference r1 to get the value we want
    @ldrh    r0, [r1]		@ Get the current state of that GPIO (half word only)

    @orr     r0, r0, #0xFF00		@ Use bitwise OR (ORR) to set the bit at 0x0100
    @strh    r0, [r1]		@ Write the half word back to the memory address for the GPIO

    @bx      lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


@@@@@@@@@@@@@@@@@@@@@@@@@ Use code for later @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @bl      mes_IWDGRefresh
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@









@_an_a4_tick:
@
@    push    {r4-r6, lr}                     @ Put aside registers we want to restore later
@
@
@    ldr     r1, =a4_ticks                   @ load address of a4_ticks into r1
@    ldr     r0, [r1]                        @ load current ticks value 
@    subs    r0, r0, #1                      @ subtract 1 from the ticks
@    ble     exit_tick                       @ go to exit_tick if it is 0
@    str     r0, [r1]                        @ store value back into r1
@
@
@    cmp     r0, #1                          @ compare a4 ticks to something greater than 0
@    beq     lose_led                        @ if the values are equal go to lose_led
@    
@
@    ldr     r1, =a4_accel_ticks             @ load address of a4_accel_ticks into r1
@    ldr     r0, [r1]                        @ load current a4_accel_ticks ticks value
@    subs    r0, r0, #1                      @ subtract 1 from a4_accel_ticks
@    str     r0, [r1]                        @ store the current decremented count
@    bgt     exit_tick                       @ go to exit_tick if the tick isn't 0
@
@    
@    bl      accelero_check                  @ go to accelero_check to see which led to turn on
@
@    mov     r6, r0                          @ copy LED index into r6 incase we need to use later
@
@    ldr     r1, =a4_target                  @ load address of a4_target into r1
@    ldr     r4, [r1]                        @ load the traget into r4 to use later
@
@    cmp     r6, r4                          @ compare LED index to target
@    bne     exit_target_check               @ if they are not equal, go to exit_target_check
@
@
@    ldr     r1, =a4_delay                   @ load address of a4_delay
@    ldr     r0, [r1]                        @ load current delay ticks value
@    subs    r0, r0, #1                      @ subtract 1 from ticks
@    str     r0, [r1]                        @ store the current decremented count
@    bgt     exit_tick                       @ branch to exit_tick if value is greater than 0
@
@
@    ldr     r1, =a4_ticks                   @ load address of a4_ticks
@    mov     r0, #0                          @ copy 0 to r0 since we have won the game
@    str     r0, [r1]                        @ store value back into a4_ticks
@
@    bl      win                             @ branch to win to flash LED's
@
@    bl      exit_tick                       @ branch to exit_tick since we are done
@
@
@
@exit_target_check:
@
@    ldr     r1, =a4_reset_delay             @ load address of a4_reset_delay into r1
@    ldr     r0, [r1]                        @ load the reset delay into r0 to use later
@    ldr     r1, =a4_delay                   @ load address of a4_delay
@    str     r0, [r1]                        @ store the reset value into a4_delay
@
@
@
@    ldr     r1, =a4_accel_ticks             @ load address of a4_accel_ticks
@    mov     r0, #accel_delay                @ reset the accel tick value
@    str     r0, [r1]                        @ store the value into a4_accel_ticks
@
@    bl      exit_tick                       @ branch to exit tick
@
@
@lose_led:
@
@
@    bl      lose                            @ call lose function
@
@
@exit_tick:
@
@
@    pop     {r4-r6, lr}                    @ Bring all the register values back
@
@    bx      lr                             @ Return (Branch eXchange) to the address in the link register (lr)










@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    LAB 8    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@






























    




.size _an_watchdog_start, .-_an_watchdog_start  @@ - symbol size (not strictly required, but makes the debugger happy)

.end                                    @ Assembly file ended by single .end directive on its own line