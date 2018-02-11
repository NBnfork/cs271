TITLE Program03     (prog03.asm)

; Author: Noah Buchen	
; Course / Project ID: 271 Project3            Date: 10 February 2018
; Description:This program will add negative integers and then provide a rounded average
;			  of the numbers entered. 


INCLUDE Irvine32.inc

LOWERLIMIT = -100 ;for validating

.data

mess1			BYTE    "Integer Accumulator by Noah Buchen", 13, 10, 0
prompt1			BYTE    "Please enter your name: ", 0
userName		BYTE    100 DUP(0)
mess2			BYTE    "Hello, " , 0
mess3			BYTE    "Enter your numbers in the range from [-100, -1].", 13, 10, 0
mess4			BYTE	"Enter a non-negative number when you are finished.", 13, 10, 0
prompt2			BYTE	"Enter a number:" , 0
errorMess1		BYTE    "Oops, that number is out of range. Enter [-100, -1]", 13, 10, 0
termIn			SDWORD	?
runningTotal	SDWORD	0
rtMess			BYTE	"The sum of your valid inputs is: ", 0
termsTotal		DWORD   0
ttMess1			BYTE	"You input ", 0
ttMess2			BYTE	" valid numbers.", 13, 10, 0
zdMess			BYTE	"You don't want this program to divide by zero!", 13, 10, 0
average			SDWORD   ?
averageMess		BYTE	"The rounded average of the numbers is: ", 0
mess5			BYTE    ", this program is complete.", 13, 10, 0     
exitMess		BYTE    "Goodbye!", 13, 10, 0

.code
main PROC

;Display title and user name
mov     edx, OFFSET mess1
call    Writestring
call    CrLf

;Get user's name
mov     edx, OFFSET prompt1
call    WriteString
mov     edx, OFFSET userName
mov     ecx, SIZEOF userName
call    ReadString

;Greet user
mov     edx, OFFSET mess2
call    WriteString
mov     edx, OFFSET userName
call    WriteString
call    CrLf

;explain process with mess3
mov     edx, OFFSET mess3
call    Writestring
mov     edx, OFFSET mess4
call    Writestring

L1:
;prompt user to enter number
mov     edx, OFFSET prompt2
call    Writestring
;save number
call	ReadInt
mov		termIn, eax

;check if number is negative, or jump to average:
cmp		eax, 0
jge		CalcAverage

;check lower limit is correct or jmp to bad input;
cmp		eax, LOWERLIMIT
jl		BadInput

;add number to runningTotal and save
mov		ebx, runningTotal
add		ebx, eax
mov		runningTotal, ebx

;inc termsTotal
inc		termsTotal

;loop to L1:
jmp		L1

BadInput:
;output error message and jump back to top of loop
mov     edx, OFFSET errorMess1
call    WriteString
jmp     L1

CalcAverage:
;check for zero division
mov		ebx, termsTotal
cmp		ebx, 0
je		NoZeroDiv
mov		eax, runningTotal
cdq		;sign extention 
idiv	ebx
mov		average, eax ;after DIV quoient in eax
jmp		Outputs

NoZeroDiv:
mov     edx, OFFSET zdMess
call    WriteString
jmp		Ending

Outputs:
;output totalTerms
mov     edx, OFFSET ttMess1
call    WriteString
mov		eax, termsTotal
call	WriteDec
mov		edx, OFFSET ttMess2
call	WriteString

;output sum
mov		edx, OFFSET rtMess
call	WriteString
mov		eax, runningTotal
call	WriteInt
call	CrLF

;output average
mov     edx, OFFSET averageMess
call    WriteString
mov		eax, average
call	WriteInt
;display exitMess

Ending:
;Display parting message with users name
call    CrLf
mov     edx, OFFSET userName
call    WriteString
mov     edx, OFFSET mess5
call    WriteString
mov     edx, OFFSET exitMess
call    WriteString
call    CrLf

    exit	; exit to operating system
main ENDP



END main


