TITLE forTesting   (forTesting.asm)

; Author:Noah Buchen
; Course / Project ID: 

INCLUDE Irvine32.inc


.data


x			SDWORD  102
exitMess1   BYTE    "This program is complete.", 13, 10, 0     
exitMess2   BYTE    "Goodbye!", 13, 10, 0

.code
main PROC

;save registers
PUSHAD
; x < 100 keep going 
mov		eax, x
cmp		eax, 100
;else
jg		printH

;if x is >= 50
cmp		eax, 50
jle		printL 
;else print m

mov		eax, 'M'
call	WriteChar
call	CrLF
jmp		cleanup

printH:
mov		eax, 'H'
call	WriteChar
call	CrLf
jmp		cleanup

printL:
mov		eax, 'L'
call	WriteChar
call	CrLf

cleanup:
POPAD
	exit	; exit to operating system
main ENDP



END main