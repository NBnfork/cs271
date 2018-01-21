TITLE Assembly Basics    (Project01.asm)

; Author: Noah Buchen
; Course / Project ID: 271 Project #1    Date: 20 January 2018
; Description: A very basic assembly program that will demostrate
;              I/O, defining variables, and integer arithmitic;

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

userIn1		DWORD	?	; integer will be entered
userIn2		DWORD	?

intro1		BYTE	"Welcome to Assembly Basics by Noah Buchen", 0
prompt1		BYTE	"Please enter 2 integers to begin:", 0 
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

; input data from user
	
; calculate and output sum
	mov		eax, userIn1
	call	WriteInt
;calculate and output difference
;calculate and output integer quotient and remainder

; output terminating message
	mov		edx, OFFSET exitMess
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP



END main
