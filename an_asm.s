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

    .global a3_Game                 @ Make the symbol name for the function visible to the linker

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type a3_Game, %function     @ Declares that the symbol is a function (not strictly required)


@ Function Declaration : int a3_Game(int delay, char *pattern, int target)
@
@ Input: r0, r1, r2 (i.e. r0 holds the delay, r1 holds the led pattern, r2 holds the target led)
@ Returns: r0
@

@ Here is the actual a3_Game function

a3_Game:

    push    {r4-r7, lr}                 @ Put aside registers we want to restore later

    mov     r4, r0                      @ Set aside r4 to use for delay



    mov     r6, r2                      @ Set aside r6 to use for target



pattern_loop: 

    ldrb     r5, [r1]                   @ Dereference the character r1 points to
    
    add     r1, #1                      @ the check is happening to the previous value, works but should be before addition
    


    cmp     r5, #0                      @ compare r5 to 0 to see if end of string is reached 
    bgt     pattern_loop                @ branch back to pattern_loop if r5 is greater than 0




out:

    pop     {r4-r7, lr}                 @ Bring all the register values back

    bx      lr                          @ Return (Branch eXchange) to the address in the link register (lr)





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


      
.size a3_Game, .-a3_Game  @@ - symbol size (not strictly required, but makes the debugger happy)

.end                                    @ Assembly file ended by single .end directive on its own line