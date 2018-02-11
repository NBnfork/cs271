TITLE Assembly Basics    (Project01.asm)

; Author: Noah Buchen
; Course / Project ID: 271 Project #1    Date: 20 January 2018
; Description: A very basic assembly program that will demostrate
;              I/O, defining variables, and integer arithmitic;

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

userIn1		WORD	?	; integer will be entered
userIn2		WORD	?
intro1		BYTE	"Welcome to Assembly Basics by Noah Buchen", 0
EC1			BYTE	"**EC1: Program will loop" , 0
EC2			BYTE	"**EC2: Compare and validate input" , 0
prompt1		BYTE	"Please enter 2 integers to begin.", 0
prompt2		BYTE	"First int:" , 0
prompt3		BYTE	"Second int:" , 0
greaterThan	BYTE	"The second integer is larger than the first." , 0
divString	BYTE	" remainder " , 0
sum			WORD	?
difference	WORD	?
product		DWORD	?
quotient	WORD	?
remainder	WORD	?
repeatMess	BYTE	"Enter [1] to repeat" , 0
exitChoice	BYTE	?
exitMess	BYTE	"That's all folks!", 0

.code
main PROC
 
; output my name, program title, and EC info
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET EC1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET EC2
	call	WriteString
	call	CrLf
	call	CrLf
; output user instructions
L1:
	mov		edx, OFFSET prompt1
	call	WriteString
	call	CrLf

; input data from user
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadDec 
	mov		userIn1, ax
	mov 	edx, OFFSET prompt3
	call 	WriteString
	call	ReadDec 
	mov		userIn2, ax
	call	CrLf
; validate input
	mov 	bx, userIn1
	cmp 	ax, bx		;int2 is already in ax
	ja 		L2

; calculate and store sum
	mov 	ax, userIn1
	mov 	bx, userIn2
	add 	ax, bx
	mov 	sum, ax

;ouput sum
	mov		ax, userIn1
	call	WriteDec
	mov		al, '+'
	call	WriteChar
	mov		ax, userIn2
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		ax, sum
	call	WriteDec
	call	CrLf

;calculate and store difference
	mov		ax, userIn1
	sub		ax, userIn2
	mov		difference, ax

;output difference
	mov		ax, userIn1
	call	WriteDec
	mov		al, '-'
	call	WriteChar
	mov		ax, userIn2
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		ax, difference
	call	WriteDec
	call	CrLf

;calculate and store product
	mov		ax, userIn1
	mov		bx, userIn2
	mul		bx
	mov		product, eax

;output product
	mov		ax, userIn1
	call	WriteDec
	mov		al, 'x'
	call	WriteChar
	mov		ax, userIn2
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		eax, product
	call	WriteDec
	call	CrLf

;calculate quotient and remainder
	mov		dx, 0 
 	mov		ax, userIn1
	mov		bx, userIn2
	div		bx
	mov		quotient, ax ;it is always in a-something
	mov		remainder, dx ;it is always in d-something

;output quotient and remainder
	mov		ax, userIn1
	call	WriteDec
	mov		al, '/'
	call	WriteChar
	mov		ax, userIn2
	call	WriteDec
	mov		al, '='
	call	WriteChar
	mov		ax, quotient
	call	WriteDec
	mov		edx, OFFSET divString
	call	WriteString
	mov		ax, remainder
	call	WriteDec
	call	CrLf
	call	CrLf
	JMP		L3

; bad input message;
L2:
	mov		edx, OFFSET greaterThan
	call	WriteString
	call	CrLf
	call	CrLf

; output exit menu
L3:
	mov		edx, OFFSET repeatMess
	call	WriteString
	call	ReadDec 
	mov		userIn1, ax
	call	CrLf
	cmp		ax, 1
	je		L1

; output terminating message
	mov		edx, OFFSET exitMess
	call	WriteString
	call	CrLf
	call	CrLf

	exit	; exit to operating system
main ENDP



END main
