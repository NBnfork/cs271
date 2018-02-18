TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

.data
x   DWORD  153461
y   BYTE   37
z   BYTE   90


.code
main PROC
   mov    eax,1
   mov    ebx,4
label6:
   mul    ebx
   call   WriteDec
   call   CrLf
   inc    ebx
   cmp    eax,40
   jbe    label6
   mov    eax,ebx
   call   WriteDec
   call   CrLf
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
