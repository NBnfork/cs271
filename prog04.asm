TITLE Composite Numbers   (prog04.asm)

; Author:Noah Buchen
; Course / Project ID: CS271 program04  Date: 18 Feb. 2018
; Description: This program will prompt a user to choose a the 
;			   number of composite numbers they would like to display

INCLUDE Irvine32.inc

UPPERLIMIT = 400 

.data

mess1       BYTE    "Composite Numbers by Noah Buchen", 13, 10, 0
prompt1     BYTE    "Please choose how many composite numbers you would like to see. [1, 400] ", 0
errorMess1  BYTE    "Oops, that number is out of range. Enter [1, 400]", 13, 10, 0
termsTotal  DWORD   ?
spaces3		BYTE    "   ", 0
termColumn  DWORD   0
prevTerm    DWORD   1
newTerm     DWORD   1
exitMess1   BYTE    "This program is complete.", 13, 10, 0     
exitMess2   BYTE    "Goodbye!", 13, 10, 0

.code
main PROC

;introduction
	call introduction
;getUserData
	call getUserData
;showComposites
	call showComposites
	;isComposite
;farewell
	call farewell

	exit	; exit to operating system
main ENDP

;**introduction**
;this proc will output the title of this program
introduction PROC
	mov     edx, OFFSET mess1
	call    Writestring
	call    CrLf
	ret
introduction ENDP

getUserData	PROC
	mov     edx, OFFSET prompt1
	call    WriteString
	call    ReadInt
	mov     termsTotal, eax
	call    CrLF
	call	validate
	ret
getUserData	ENDP

validate PROC
;termsTotal is <= limit
	pushad
	mov		eax, termsTotal
	mov     ebx, UPPERLIMIT
	cmp     eax, ebx
	jle     upperOK
	jmp     badInput

badInput:
	;output error message and call again
	mov     edx, OFFSET errorMess1
	call    WriteString
	call	getUserData

upperOK: 
	popad
	ret
validate ENDP

showComposites PROC
	
	ret
showComposites ENDP

isComposite PROC

	ret
isComposite ENDP

farewell	PROC
mov     edx, OFFSET exitMess1
call    WriteString
mov     edx, OFFSET exitMess2
call    WriteString
call    CrLf
	ret
farewell	ENDP

END main