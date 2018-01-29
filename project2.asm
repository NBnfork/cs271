TITLE Program Template     (template.asm)

; Author: Noah Buchen	
; Course / Project ID: 271 Project2            Date: 28 January 2018
; Description: 

INCLUDE Irvine32.inc

UPPERLIMIT = 46 ;for validating

.data

mess1       BYTE    "Fibonacci Numbers by Noah Buchen", 13, 10, 0
prompt1     BYTE    "Please enter your name ", 0
userName    BYTE    100 DUP(0)
mess2       BYTE    "Hello, " , 0
prompt2     BYTE    "Enter number of Fibonacci terms to display [1-46]", 0
errorMess1  BYTE    "Oops, that number is out of range. Enter [1-46]", 13, 10, 0
termsTotal  DWORD   ?
spaces5     BYTE    "     ", 0
termColumn  DWORD   0
prevTerm    DWORD   1
newTerm     DWORD   1
term1       DWORD   1
term2       DWORD   1
term3       DWORD   ?
term4       DWORD   ?
term5       DWORD   ?
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

L1:
;Prompt and save user input of n-terms
mov     edx, OFFSET prompt2
call    WriteString
call    ReadInt
mov     termsTotal, eax
call    CrLF

;Validate input
;termsTotal is >= limit
mov     ebx, UPPERLIMIT
cmp     eax, ebx
jle     upperOK
jmp     badInput

upperOK:
;termsTotal is < than 1
mov     ebx, 1
cmp     eax, ebx
jge     lowerOk
jmp     badInput


badInput:
;output error message and loop back
mov     edx, OFFSET errorMess1
call    WriteString
jmp     L1

lowerOK: 

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
;check if program is complete
cmp     ecx, 1
je      Ending
cmp     ecx, 0
je      Ending
dec     ecx
;reset column counter
mov     eax, 0
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
;check if final term
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

; (insert additional procedures here)

END main
