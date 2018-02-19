TITLE Composite Numbers   (prog04.asm)

; Author:Noah Buchen
; Course / Project ID: CS271 program04  Date: 18 Feb. 2018
; Description: This program will prompt a user to choose a the 
;			   number of composite numbers they would like to display

INCLUDE Irvine32.inc

UPPERLIMIT = 400 
LOWERLIMIT = 1

.data

mess1       BYTE    "Composite Numbers by Noah Buchen", 13, 10, 0
prompt1     BYTE    "Please choose how many composite numbers you would like to see. [1, 400] ", 0
errorMess1  BYTE    "Oops, that number is out of range. Enter [1, 400]", 13, 10, 0
termsTotal  DWORD   ?
counter1	DWORD	?
compstNum	DWORD	4
divisor		DWORD	5
spaces3		BYTE    "   ", 0
termColumn  DWORD   0
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
;farewell
	call farewell

	exit	; exit to operating system
main ENDP

;Procedure to print title of program.
;receives: 
;returns: 
;preconditions:
;registers changed: edx
introduction PROC
	mov     edx, OFFSET mess1
	call    Writestring
	call    CrLf
	ret
introduction ENDP

;Procedure to getUser Data.
;receives: user input
;returns: global termsTotal
;preconditions:
;registers changed: edx, eax

getUserData	PROC
	mov     edx, OFFSET prompt1
	call    WriteString
	call    ReadInt
	mov     termsTotal, eax
	call    CrLF
	call	validate
	ret
getUserData	ENDP

;Procedure to validate input range
;receives: termsTotal
;returns: data is ok or recursivelly calls getUserData
;preconditions: termsTotal != ?
;registers changed: 
validate PROC
;termsTotal is <= upperlimit
	pushad
	mov		eax, termsTotal
	mov     ebx, UPPERLIMIT
	cmp     eax, ebx
	jle     checkLower
	jmp     badInput

checkLower:
;termsTotal is >= lowerlimit
	mov		ebx, LOWERLIMIT
	cmp		eax, ebx
	jge		validated
	jmp		badInput



badInput:
	;output error message and call again
	mov     edx, OFFSET errorMess1
	call    WriteString
	call	getUserData

validated: 
	popad
	ret
validate ENDP

;Procedure to print give number of composite numbers in rows of 10
;receives: global, termsTotal
;returns: eax 1(true), eax 0(false) 
;preconditions: termsTotal !=0
;registers changed: 
showComposites PROC
	pushad
;loop through termTotal times
	mov		ecx, termsTotal
L1: 
	call	isComposite
	;isComposite will set eax to 1 if true
	cmp		eax, 1
	je		print
	inc		compstNum 
	jmp		L1

print:
	;output term and spaces
	mov     eax, compstNum
	call    WriteDec
	mov		edx, OFFSET spaces3
	call	WriteString

	;manage term output
	inc     termColumn
	call	needFeed
	inc		compstNum
	loop    L1

	popad
	ret

showComposites ENDP

;Procedure to deterimine if an integer is a composite number
;receives: global, divisor compstNum
;returns: eax 1(true), eax 0(false) 
;preconditions: 
;registers changed: eax
isComposite PROC
	push	ebx
	push	edx
	mov		eax, compstNUM

	;div by 2 and check remainder
	mov		ebx, 2
	mov		edx, 0
	div		ebx
	cmp		edx, 0
	je		isTrue

	;div by 3 and check remainder
	mov		eax, compstNum
	mov		ebx, 3
	mov		edx, 0
	div		ebx
	cmp		edx, 0
	je		isTrue
	
	;check all other possibilities counter aka divisor
;set loop counter
	mov		divisor, 5
compForLoop:
;check loop control i*i <=n
	mov		eax, divisor
	mov		ebx, divisor
	mul		ebx
	cmp		eax, compstNum
	jae		isFalse

	;check n%i == 0 true
	mov		eax, compstNUM ;n
	mov		edx, 0
	div		divisor ;i	
	cmp		edx, 0
	je		isTrue
	
	;check n%(i+2) == O
	mov		eax, compstNum
	mov		ebx, divisor
	mov		edx, 0
	add		ebx, 2 ;i+2
	div		ebx
	cmp		edx, 0
	je		isTrue
	
	;increment i+6
	mov		ebx, divisor
	add		ebx, 6
	mov		divisor, ebx
	jmp		compForLoop

isTrue:
	mov eax, 1
	pop	ebx
	pop	edx
	ret

isFalse:
	mov eax, 0
	pop	ebx
	pop	edx
	ret
isComposite ENDP

;Procedure to deterimine when a linefeed will happen during output
;receives: global, termColumn
;returns: 
;preconditions: termColumn != 0
;registers changed: 
needFeed	PROC
	push	ebx	;save reg
	mov     ebx, termColumn
	cmp     ebx, 10
	je      lineFeed
	pop		ebx
	ret

lineFeed:
	push	eax	;save reg
	call	CrLF
	mov     eax, 0
	mov     termColumn, eax ;reset columns
	pop		eax
	pop		ebx
	ret
needFeed ENDP	

;Procedure to output farewell message
;receives: global,exitMess1 and exitMess2
;returns:  
;preconditions: 
;registers changed: edx
farewell	PROC
	call	CrLf
	mov     edx, OFFSET exitMess1
	call    WriteString
	mov     edx, OFFSET exitMess2
	call    WriteString
	call    CrLf
	ret
farewell	ENDP

END main