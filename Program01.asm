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
prompt1		BYTE	"Please enter 2 integers to begin.", 0
prompt2		BYTE	"First int:" , 0
prompt3		BYTE	"Second int:" , 0
divString	BYTE	" remainder " , 0
sum			WORD	?
difference	WORD	?
product		DWORD	?
quotient	WORD	?
remainder	WORD	?
exitMess	BYTE	"That's all folks!", 0

.code
main PROC
 
; output my name and program title
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf

; output user instructions
	mov		edx, OFFSET prompt1
	call	WriteString
	call	CrLf

; input data from user
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadDec 
	mov		userIn1, ax
	mov edx, OFFSET prompt3
	call WriteString
	call	ReadDec 
	mov		userIn2, ax
	call	CrLf

; calculate and store sum
	mov bx, userIn1
	add ax, bx
	mov sum, ax

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
	mov		dx, 0 ; must be cleared since dividend will be stored in DX:AX for 16 bit
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

; output terminating message
	mov		edx, OFFSET exitMess
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP



END main
