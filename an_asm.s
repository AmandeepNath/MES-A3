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

    push    {r4-r11, lr}                    @ Put aside registers we want to restore later

    mov     r4, #13421                      @ Set aside r4 to use for delay

    mul     r4, r0                          @ multiply our delay value to scale it

    mov     r9, r1                          @ copy the pattern into r9

    mov     r6, r2                          @ Set aside r6 to use for target

    mov     r8, #0                          @ copy 0 into r8 to use for the offset counter

    mov     r10, #0                         @ copy 0 into r10 to use for winning led counter loop

    mov     r11, #2                         @ copy 2 into r11 for blink twice counter

turn_all_off:

    mov     r0, r10                         @ copy the led counter index into r10
    bl      BSP_LED_Off                     @ call the BSP_LED_Off function

    add     r10, r10, #1                    @ add 1 to the led counter

    cmp     r10, #8                         @ compare to see if the final led is reached
    blt     turn_all_off                    @ branch back to turn_all_off is the led counter is less than 8

    mov     r10, #0                         @ copy 0 into r10 to reset the counter for later use


    pattern_loop: 

        ldrb    r5, [r9, r8]                @ Dereference the character r9 points to
    

        cmp     r5, #0                      @ compare the ascii value of the current offset to 0 to see if it is null
        beq     pattern_checkpoint          @ if the value is null go to pattern_checkpoint, continue if not


        mov     r7, r5                      @ Copy the ascii value of r5 to r7
        sub     r7, r7, #48                 @ subtract 48 from r7 to obtain the led index


        mov     r0, r7                      @ r0 holds our argument for the LED toggle function, so pass I pass the index (r7)
        bl      BSP_LED_Toggle              @ call the led toggle function to turn it on/off


        mov     r0, r4                      @ copy our delay to r0 so the busy delay can use the delay value
        bl      busy_delay                  @ call the busy_delay function to add a delay between the next toggle


        bl      BSP_PB_GetState             @ call BSP_PB_GetState
        cmp     r0, #1                      @ check to see if the button is pressed
        beq     button_check                @ if the button is pressed go to button_check


        mov     r0, r7                      @ r0 holds our argument for the LED toggle function, so pass I pass the index (r7)
        bl      BSP_LED_Toggle              @ call the led toggle function to turn it on/off


        mov     r0, r4                      @ copy our delay to r0 so the busy delay can use the delay value
        bl      busy_delay                  @ call the busy_delay function to add a delay between the next toggle


        add     r8, r8, #1                  @ add 1 to the offset of the string array


    pattern_checkpoint:

        cmp     r5, #0                      @ compare r5 to 0 to see if end of string is reached 
        bgt     pattern_loop                @ branch back to pattern_loop if r5 is greater than 0


        mov     r8, #0                      @ reset the offset value to 0 to create infinite loop
        bl      pattern_loop                @ branch back to pattern_loop



button_check:

    mov     r0, r7                          @ copy current led index to r7
    bl      BSP_LED_Toggle                  @ toggle the specified light on


    cmp     r6, r7                          @ compare to see if target led is the same as current led
    beq     win_led_loop_on                 @ if equal, go to win condition (win_led_loop_on)


    cmp     r6, r7                          @ compare to see if target led is the same as current led
    bne     lose_led_on                     @ if not equal, go to lose condition (lose_led_on)



    win_led_loop_on:


        mov     r0, r10                     @ r0 holds our argument for the LED toggle function, so pass I pass the index (r10)
        bl      BSP_LED_Toggle              @ call the led toggle function to turn it on/off


        add     r10, r10, #1                @ add 1 to the led counter


        cmp     r10, #8                     @ compare r10 to 8 to check if the led counter is on the last led
        blt     win_led_loop_on             @ if the led counter is less than 8, branch back to win_led_loop


        ldr     r0, =0x666666               @ copy our delay to r0 so the busy delay can use the delay value
        bl      busy_delay                  @ call the busy_delay function to add a delay between the next toggle


        mov     r10, #0                     @ copy 0 to r10 to reset our counter for the led
    

    win_led_loop_off:

        mov     r0, r10                     @ r0 holds our argument for the LED toggle function, so pass I pass the index (r10)
        bl      BSP_LED_Toggle              @ call the led toggle function to turn it on/off


        add     r10, r10, #1                @ add 1 to the led counter


        cmp     r10, #8                     @ compare r10 to 8 to check if the led counter is on the last led
        blt     win_led_loop_off            @ if the led counter is less than 8, branch back to win_led_loop


        ldr     r0, =0x666666               @ copy our delay to r0 so the busy delay can use the delay value
        bl      busy_delay                  @ call the busy_delay function to add a delay between the next toggle


        mov     r10, #0                     @ copy 0 to r10 to reset our counter for the led


        subs     r11, r11, #1               @ subtract one from the twice blink counter
        bgt     win_led_loop_on             @ branch back to win loop if the value if greater than 0

        b       exit_program                @ branch to exit_program


    lose_led_on:

        mov     r0, r6                      @ r0 holds our argument for the LED toggle function, so pass I pass the index (r6)
        bl      BSP_LED_Toggle              @ call the led toggle function to turn it on/off


exit_program:

    pop     {r4-r11, lr}                    @ Bring all the register values back

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


      
.size a3_Game, .-a3_Game  @@ - symbol size (not strictly required, but makes the debugger happy)

.end                                    @ Assembly file ended by single .end directive on its own line