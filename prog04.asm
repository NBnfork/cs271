TITLE Composite Numbers   (prog04.asm)

; Author:Noah Buchen
; Course / Project ID: CS271 program04  Date: 18 Feb. 2018
; Description: This program will prompt a user to choose a the 
;			   number of composite numbers they would like to display

INCLUDE Irvine32.inc

UPPERLIMIT = -100 ;for validating

.data

mess1       BYTE    "Composite Numbers by Noah Buchen", 13, 10, 0
prompt1     BYTE    "Please choose how many composite numbers you would like to see. [1, 400].", 13, 10, 0
errorMess1  BYTE    "Oops, that number is out of range. Enter [-100, -1]", 13, 10, 0
termsTotal  DWORD   ?
spaces3		BYTE    "   ", 0
termColumn  DWORD   0
prevTerm    DWORD   1
newTerm     DWORD   1
mess3       BYTE    "Just 1:( How about something a little more difficult next time!", 13, 10, 0
mess4       BYTE    ", this program is complete.", 13, 10, 0     
exitMess    BYTE    "Goodbye!", 13, 10, 0

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

;**getUserData**
;this proc will ask the user for input
getUserData PROC
	mov     edx, OFFSET prompt2
	call    WriteString
	call    ReadInt
	mov     termsTotal, eax
	call    CrLF
	call	validate
	ret
getUserData END

;**validate**
;this proc will validate the user input
validate PROC
;termsTotal is >= limit
	mov     ebx, UPPERLIMIT
	mov		eax, termsTotal
	cmp     eax, ebx
	jle     upperOK
	jmp     badInput

badInput:
;output error message and call getUserData again
	mov     edx, OFFSET errorMess1
	call    WriteString
	call	getUserData

upperOK: 
	
	ret
validate ENDP

END main