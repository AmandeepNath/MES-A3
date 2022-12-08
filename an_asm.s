@ Initialize the variables we want to use

.data

a5_timeout: .word 0
a5_on_delay: .word 0
a5_off_delay: .word 0
a5_reset_delay: .word 0
a5_GP_flag: .word 0

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


    ldr     r3, =a5_GP_flag                 @ load address into r3 so parameters don't get overwritten
    mov     r0, #1                          @ copy constant 1 into r0
    str     r0, [r3]                        @ store constant 1 into a5_GP_flag


    ldr     r3, =a5_on_delay                @ load address into r3 so parameters don't get overwritten
    str     r1, [r3]                        @ store delay into a5_on_delay

    ldr     r3, =a5_off_delay               @ load address into r3 so parameters don't get overwritten
    str     r1, [r3]                        @ store delay into a5_off_delay

    ldr     r3, =a5_reset_delay             @ load address into r3 so parameters don't get overwritten
    str     r1, [r3]                        @ store delay into a5_reset_delay


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

    .global _an_a5_tick_handler          @ Make the symbol name for the function visible to the linker

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type _an_a5_tick_handler, %function     @ Declares that the symbol is a function (not strictly required)




_an_a5_tick_handler:

    push    {lr}                            @ Put aside registers we want to restore later



    ldr     r1, =a5_GP_flag                 @ load address of a5_GP_flag into r1
    ldr     r0, [r1]                        @ load 1 flag into r0 
    cmp     r0, #0                          @ compare r0 to 0
    beq     exit_tick                       @ go to exit_tick if it is equal to 0


    ldr     r1, =a5_GP_flag                 @ load address of a5_GP_flag into r1
    ldr     r0, [r1]                        @ load flag into r0
    cmp     r0, #2                          @ compare r0 with watchdog flag
    beq     watchdog_skip                   @ branch to watchdog_skip if they are equal, refresh watchdog if they are not

    bl      mes_IWDGRefresh                 @ call watchdog refresh


watchdog_skip:

    ldr     r1, =a5_on_delay                @ load address of a5_on_delay into r1
    ldr     r0, [r1]                        @ load current ticks value 
    subs    r0, r0, #1                      @ subtract 1 from the ticks
    str     r0, [r1]                        @ store value back into r1
    bgt     exit_tick                       @ go to exit_tick if it is greater than 0



    ldr     r1, =LEDaddress	                @ Load the GPIO address we need
    ldr     r1, [r1]		                @ Dereference r1 to get the value we want
    ldrh    r0, [r1]		                @ Get the current state of that GPIO (half word only)

    orr     r0, r0, #0xFF00		            @ Use bitwise OR (ORR) to set the bit at 0xFF00
    strh    r0, [r1]		                @ Write the half word back to the memory address for the GPIO



    ldr     r1, =a5_off_delay               @ load address of a4_off_delay into r1
    ldr     r0, [r1]                        @ load current ticks value 
    subs    r0, r0, #1                      @ subtract 1 from the ticks
    str     r0, [r1]                        @ store value back into r1
    bgt     exit_tick                       @ go to exit_tick if it is greater than 0



    ldr     r1, =LEDaddress	                @ Load the GPIO address we need
    ldr     r1, [r1]		                @ Dereference r1 to get the value we want
    ldrh    r0, [r1]		                @ Get the current state of that GPIO (half word only)

    and     r0, r0, #0x00FF		            @ Use bitwise AND to set the bit at 0x00FF
    strh    r0, [r1]		                @ Write the half word back to the memory address for the GPIO



    ldr     r2, =a5_reset_delay             @ load address of a5_reset_delay into r2
    ldr     r0, [r2]                        @ load value into r0

    ldr     r1, =a5_on_delay                @ load address of a5_on_delay into r1
    str     r0, [r1]                        @ store value of reset into r1

    ldr     r1, =a5_off_delay               @ load address of a5_off_delay into r1
    str     r0, [r1]                        @ store value reset into r1





exit_tick:


    pop     {lr}                            @ Bring all the register values back

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

    .global _an_a5_button_handler          @ Make the symbol name for the function visible to the linker

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type _an_a5_button_handler, %function     @ Declares that the symbol is a function (not strictly required)

_an_a5_button_handler:

    push    {lr}                            @ Put aside registers we want to restore later
    
    ldr     r1, =a5_GP_flag	                @ load address of a5_GP_flag into r1
    mov     r0, #2                          @ copy 2 into a5_GP_flag for watchdog flag
    str     r0, [r1]		                @ store value into a5_GP_flag to use as flag

    pop     {lr}                            @ Bring all the register values back

    bx      lr                              @ Return (Branch eXchange) to the address in the link register (lr)





.size _an_watchdog_start, .-_an_watchdog_start  @@ - symbol size (not strictly required, but makes the debugger happy)

.end                                    @ Assembly file ended by single .end directive on its own line