TITLE Program03     (program03.asm)

; Author: Noah Buchen	
; Course / Project ID: 271 Project3            Date: 10 February 2018
; Description:This program will add negative integers and then provide a rounded average
;			  of the numbers entered. 


INCLUDE Irvine32.inc

LOWERLIMIT = -100 ;for validating

.data

mess1       BYTE    "Integer Accumulator by Noah Buchen", 13, 10, 0
prompt1     BYTE    "Please enter your name ", 0
userName    BYTE    100 DUP(0)
mess2       BYTE    "Hello, " , 0
prompt2     BYTE    "Enter your numbers in the range from [-100, -1].", 13, 10, 0
mess3		BYTE	"Enter a non-negative number when you are finished.", 13, 10, 0
errorMess1  BYTE    "Oops, that number is out of range. Enter [-100, -1]", 13, 10, 0
termsTotal  DWORD   ?
spaces5     BYTE    "     ", 0
termColumn  DWORD   0
prevTerm    DWORD   1
newTerm     DWORD   1
mess3       BYTE    "Just 1:( How about something a little more difficult next time!", 13, 10, 0
mess4       BYTE    ", this program is complete.", 13, 10, 0     
exitMess    BYTE    "Goodbye!", 13, 10, 0

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
	;Prompt user to enter numbers
L1:
;Prompt and save user input of n-terms
mov     edx, OFFSET prompt2
call    WriteString
call    ReadInt
mov     termsTotal, eax
call    CrLF

;Validate input
;termsTotal is >= limit
mov     ebx, LOWERLIMIT
cmp     eax, ebx
jle     lowerOK
jmp     badInput

badInput:
;output error message and loop back
mov     edx, OFFSET errorMess1
call    WriteString
jmp     L1

lowerOK: 
	;check for non-negative and jump to next section
	;add numbers
;Display 1 term 
mov     al, '1'
call    WriteChar
inc     termColumn
;set counter
mov     ecx, termsTotal
;Check for short list
cmp     ecx, 1
je      L3
;decrease counter
dec     ecx
; print space and second term 
mov     edx, OFFSET spaces5
call    WriteString
mov     al, '1'
call    WriteChar
inc     termColumn
dec     ecx
; check if finished
cmp     ecx, 0
je      Ending

;Calculate and output next term
L2:
mov     eax, newTerm
mov     ebx, prevTerm
add     ebx, eax
mov     newTerm, ebx
mov     prevTerm, eax ;save for next
;output spaces and term
mov     edx, OFFSET spaces5
call    WriteString
mov     eax, newTerm
call    WriteDec
;manage term output
inc     termColumn
mov     ebx, termColumn
cmp     ebx, 5
je      lineFeed
L4:
loop    L2

;output control
lineFeed:
call    CrLf
;check if loop is complete
cmp     ecx, 1
je      Ending
cmp     ecx, 0
je      Ending

;reset column counter
mov     eax, 1
mov     termColumn, eax
;print next term without spaces
mov     eax, newTerm
mov     ebx, prevTerm
add     ebx, eax
mov     newTerm, ebx
mov     prevTerm, eax ;save for next
;output term
mov     eax, newTerm
call    WriteDec
dec     ecx ;since this is an interation of the loop
;check if loop is complete
cmp     ecx, 2
je      Ending
jmp     L4

L3:
;Display just 1 term message
call    CrLf
mov     edx, OFFSET mess3
Call    WriteString
Call    CrLf

Ending:
;Display parting message with users name
call    CrLf
mov     edx, OFFSET userName
call    WriteString
mov     edx, OFFSET mess4
call    WriteString
mov     edx, OFFSET exitMess
call    WriteString
call    CrLf

    exit	; exit to operating system
main ENDP



END main
