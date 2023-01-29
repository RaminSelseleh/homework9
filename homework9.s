/*
 * Ramin Selseleh
 * Homework9
 * theia
 */

 .global main
main:

   @ Prompt to enter a name of up to 40 char
	MOV R0, #1
	LDR R2, =input
	LDR R1, =prompt
	SUB R2, R2, R1
	MOV R7, #4
	SWI 0

 @ Read character input
	MOV R0, #0
	LDR R1, =input
	MOV R2, #41
	MOV R7, #3
	SWI 0

    @ Display what was entered
	MOV R0, #1
	MOV R2, #41
	MOV R7, #4
	LDR R1, =input
	SWI 0


/*
    * Register usage
    * R7 = byte pointer/counter for loop1
    * R2 = Address of input
    * R6 = Address of output1 data area
    */

    MOV r7, #0
	LDR R2, =input		@ Get 1st character location
	LDR R3, =first_name

    @ start of loop
loop:
    @ load r0 with input and buffer
    LDRB R0, [R2, R7] 

    @ if it hits enter write and move on to next program
    CMP R0, #10
    BEQ write

    @  if [char] <= 'z' in ascii go to check if its lower case
    CMP R0, #'z'
    BLE lowCheck

    @ if [char] <= 127 ascii store then get next character
    CMP r0, #127
    BLE skip

    @ check to see whether it needs to be lower or upper case
lowCheck:
    @ if [char] < 'a' go to next check 
    CMP r0, #'a'
    BLT check

    @ if not less then 'a', check, if [char] <='z'
    CMP r0, #'z'
    BLE skip


    @ if [char] <= 'Z', then could be upper case
check:
    CMP R0, #'Z'
    BLE upperCheck

    @ if <= 'a', then it is non alphabetic char so save and get next
    CMP R0, #'a'
    BLT skip

upperCheck:
    @ if < 'A' save and get next
    CMP R0, #'A'
    BLT skip

    @ if [char] <= #'Z', then change to lower case
    CMP R0, #'Z'
    BLE toLower

    @ change upper to lower then store
toLower:
    ADD R0, R0, #32
    STRB R0, [R3, R7]
    B next

    @ gets next char
next:
    ADD R7, R7, #1
    B loop


    @ stores and gets next char
skip:
    STRB R0, [R3, R7]
    ADD R7, R7, #1
    B loop


write: @ write the 4 characters
    @ display the new output
	MOV R0, #1
	LDR R1, =first_name
	MOV R2, #4
	MOV R7, #4
    SWI 0

        @ new line 
space:
    @ space at the end
	MOV R0, #1
	MOV R2, #1
	MOV R7, #4
	LDR R1, =spac
    SWI 0




/*  *register usage 

    * r1 = stack
    * r2 = pointer
    * r3 = where names is stored
    * r5 = value to be saved in
*/
    
    ldr r1, =stack  
    mov r2, #0  @pointer
    ldr r3, =names

loop2:      @ pushing onto stack
    @ getting a word at a time
    ldr r5, [r3, r2, LSL #2]
    
    @compare to see if end of string
    cmp r5, #0
    @ if it is then end loop
    beq endloop2

    @ else store and get next char
    str r5, [r1, r2, LSL #2]
    add r2, r2, #1
    bal loop2

    @ end of loop display the pointer number
endloop2:
    @ number that is in register
    mov r0, r2


 @ Long divide as described in the book
	MOV R6, R0
	MOV R7, #10
	MOV R8, R7
	CMP R8, R6, LSR #1

Div1:	MOVLS R8, R8, LSL #1
	CMP R8, R6, LSR #1
	BLS Div1
	MOV R9, #0

Div2:	CMP R6, R8
	SUBCS R6, R6, R8
	ADC R9, R9, R9
	MOV R8, R8, LSR #1
	CMP R8, R7
	BHS Div2
	MOV R10, R9
 @ End Long divide as described in the book
/* R3 = Quotient, R1 = Remainder */

 @ Get tens value
	ADD R8, R9, #48		@ Convert to Ascii
	LDR R7, =output2
	STRB R8, [R7]

 @ Get ones value
	ADD R8, R6, #48
	STRB R8, [R7, #1]

 @ Display index
	MOV R0, #1
	LDR R1, =output2
	MOV R2, #3
	MOV R7, #4
	SWI 0



/* register usage 

    * r3 = where first_name is stored 
    * r2 = the pointer from when we pushed to stack
    * r4 where stack is stored

*/
    ldr r3, =first_name
    ldr r3, [r3]
    ldr r4, =stack
    mov r7, #29

while: @while on stack
    ldr r5, [r4, r7, LSL #2]

    @ check to see if end of string
    cmp r7, #0
    blt notFound

    @ compare to see if we hit a match
    cmp r5, r3
    beq endwhile

    @ if not get next 4 to see if we get a match
    sub r7, r7, #1
    bal while


@ if not found display message
notFound:
	MOV R0, #1
	MOV R2, #32
	MOV R7, #4
	LDR R1, =error
	SWI 0
    bal exit
    

endwhile:  @ display the index pointer
    @ Long divide as described in the book
	MOV R1, r7
	MOV R2, #10
	MOV R4, R2
	CMP R4, R1, LSR #1
Div11:	MOVLS R4, R4, LSL #1
	CMP R4, R1, LSR #1
	BLS Div11
	MOV R3, #0

Div22:	CMP R1, R4
	SUBCS R1, R1, R4
	ADC R3, R3, R3
	MOV R4, R4, LSR #1
	CMP R4, R2
	BHS Div22
	MOV R0, R3
 @ End Long divide as described in the book
/* R3 = Quotient, R1 = Remainder */
 @ Get tens value
	ADD R4, R3, #48		@ Convert to Ascii
	LDR R2, =output3
	STRB R4, [R2]
 @ Get ones value
	ADD R4, R1, #48
	STRB R4, [R2, #1]
 @ Display index
	MOV R0, #1
	LDR R1, =output3
	MOV R2, #3
	MOV R7, #4
	SWI 0





exit: @ exit syscall
    MOV R7, #1
    SWI 0

.data
prompt:
	.asciz "Enter your first name: "
input:
.space 41

@ padding for first_name
first_name:
.asciz "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"

spac:
.asciz "\n"

output2:
.asciz "  \n"

output3:
.asciz "  \n"

stack:
.space 160

error:
.asciz "Did not find first name in list\n"

names:
.ascii "danimehrangeolekambesamzprabchrievananghedgaethatramjasomajddavijaehscotnajisereandralenmartirynericramiruzazankkainryan"

theend:
.space 4 @ A word of zero to denote the end of names

