TITLE Project6A     (project6A.asm)

; Author:Noah Buchen
; Course / Project ID: cs271 #6A         Date: 15 March 2018
; Description: This program will allow the user to input 10
;			   unsigned numbers that will be displayed, summed 
;			   and averaged.			  

INCLUDE Irvine32.inc

LOWERLIMIT = 0 ;of user input
UPPERLIMIT = 4294967295 

;marco will display a string 
;parameters: &name of string
mDisplayString MACRO stringName
	push	edx
	mov		edx, stringName
	call	WriteString
	pop		edx
ENDM

;macro will display a prompt and store a string in a variable
;parameters: prompt, name of variable to 
mGetString MACRO prompt, varName
	push	ecx
	push	edx
	;display prompt
	mDisplayString prompt
	;get string and  save in varName, 
	lea		edx, varName
	mov		ecx, (SIZEOF varName) - 1
	call	ReadString
	call	CrLf
	pop		edx
	pop		ecx
ENDM

;macro will display a comma and a space
mPrintComma MACRO
	push	eax
	;clear eax
	mov		eax, 0
	mov		al, ","
	call	WriteString
	mov		al, " "
	call	WriteString
	pop		eax
ENDM

.data
mess1       BYTE    "Low Level I/O Fun by Noah Buchen", 13, 10,0
mess2		BYTE	"Please provide 10 unsigned decimal integers.", 13, 10,
					"The integers must fit in a 32 bit register. ", 13, 10,
					"This program will then display the integers,",
					" their sum, and their average.", 13, 10, 0
prompt1		BYTE	"Enter an unsigned integer: ", 0
errorMess   BYTE    "ERROR: bad input. Try again.", 13, 10, 0
results1	BYTE	"You entered the following numbers: ", 13, 10, 0
results2	BYTE	"Their sum: ", 0
results3	BYTE	"Their average: ", 0
goodInt		DWORD	?
theArray	DWORD	10	DUP(?) ;array for integers
sum			DWORD	?
average		DWORD	?



.code
main PROC
	;display intoduction
	mDisplayString OFFSET mess1
	mDisplayString OFFSET mess2
	call	CrLF
	;buildArray by using ReadVal PROC
	push	OFFSET theArray
	push	OFFSET goodInt
	push	OFFSET prompt1
	push	OFFSET errorMess
	call	buildArray
	;pass params
	push	OFFSET sum
	call	sumArray
	;pass params
	push	OFFSET average
	call	averageArray
	;pass params
	push	OFFSET theArray
	push	OFFSET results1
	call	displayResults
	;pass params
	push	OFFSET sum
	push	OFFSET results2
	push	OFFSET	average
	push	OFFSET	results3
	call	displayResults2
	exit	; exit to operating system
main ENDP



;Procedure to gather data from user and put it into an array
;receives: OFFSET theArray, OFFSET of goodInt, OFFSET prompt1
;returns: theArray
;preconditions:
;registers changed:

buildArray	PROC
	push	ebp
	mov		ebp, esp
	push	esi
	push	ebx
	push	eax
	push	edx
	;mov OFFSET of theArray to esi
	mov		esi, [ebp + 20]
	;mov OFFSET goodInt to ebx
	mov		ebx, [ebp +16]
	;mov prompt1
	mov		edx, [ebp + 12]
	;set counter
	mov		ecx, 10
fillwith10:
	;push params
	;mov errorMess
	mov		eax, [ebp + 8]
	push	ebx
	push	edx
	push	eax
	call	ReadVal
	;mov goodInt and place in array position
	mov		eax, [ebx] 
	mov		[esi], eax
	add		esi, 4
	loop	fillwith10
	;clean up
	pop		edx
	pop		eax
	pop		ebx
	pop		esi
	pop		ebp
	ret		16
buildArray	ENDP

;Procedure to read userString, validate and convert to integer
;receives: &goodInt (where integer will be stored), 
;		   &prompt1, &errorMess
;returns: goodInt
;preconditions: 
;registers changed:

ReadVal PROC
	;declare local array to hold userInput
	LOCAL userInput[32]: BYTE
	;sav registers
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	edi
	push	esi
GetString:
	;assign parameters
	mov		edi, [ebp + 16]; goodInt
	mov		edx, [ebp + 12]; prompt1
	

	;call macro which returns string in local variable
	mGetString edx, userInput 
	
	;eax has size of string move it into loop
	mov		ecx, eax
	;convert and validate
	;set goodInt to zero
	mov		ebx, 0
	mov		[edi], ebx
	;prepare for using lodsb
	lea		esi, userInput
	cld
Converting:
	;clear eax so no extra data is held over when using lodsb
	mov		eax, 0
	lodsb ; next byte is now in al
	;make sure the ASCII is a digit
	cmp		eax, 48
	jb		error
	cmp		eax, 57
	ja		error
	;conversion algo: x = 10 * x + (str[i] - 48)
	;subtract (str[i] is in eax)
	sub		eax, 48
	;sav results
	mov		ebx, eax
	;prep mul goodInt into eax, multiplier into edx
	mov		eax, [edi]; goodInt
	mov		edx, 10
	; mul x
	mul		edx
	;validate size of integer
	jo		error
	;add results
	add		eax, ebx
	;sav results in goodInt
	mov		[edi], eax
	loop	Converting
	jmp		ConversionComplete
	 
Error:
	;load errorMess into reg
	mov		ebx, [ebp +8]
	mDisplayString ebx; errorMess
	call	CrLf
	jmp		GetString
ConversionComplete:

	;clean up
	pop		esi
	pop		edi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	
	ret		12
ReadVal ENDP

;Procedure to sum values of an array 
;receives: &theArray, &sum
;returns: 
;preconditions: array size > 0
;registers changed: 
sumArray PROC
	ret  8
sumArray ENDP

;Procedure to take average of value of an array.
;receives: &theArray, &sum, &average
;returns: 
;preconditions: theArray > 0
;registers changed: 
averageArray PROC
	ret	12
averageArray ENDP

writeVal PROC
LOCAL	saveMe[10]: DWORD, toConvert: DWORD, printMe[10]: BYTE 
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	;clear registers
	mov		eax, 0
	mov		edx, 0
	;move param
	mov		eax, [ebp + 8]
	mov		toConvert, eax
	lea		edi, saveMe
	;check if int is less then ten
NextDigit:
	cmp		toConvert, 10
	jl		lastSave
	;divide in by 10
	mov		edx, 0
	mov		ebx, 10
	mov		eax, toConvert
	div		ebx
	;save results in toConvert
	mov		toConvert, eax
	;add 48 to remainder
	add		edx, 48
	;add result to front of array
	mov		eax, edx
	stosb
	jmp		NextDigit

LastSave:
	mov		eax, toConvert
	add		eax, 48
	stosb
	;save 0 byte at end of string
	mov		eax, 0
	stosb
	;check number of elements in array and set counter
	mov		ecx, 0
	lea		esi, saveMe
ElementCount:
	lodsb
	cmp		eax, 0
	je		lastElement
	inc		ecx
	jmp		ElementCount
LastElement:
;point esi to "start" of string (4* ecx-1) of array
	lea		esi, saveMe
	mov		ebx, ecx
	dec		ebx ;-1
	shl		ebx, 2 ;*4
	add		esi, ebx
	;set direction flag
	std
	;get ready to stosb
	lea		edi, printME
reverse:
	;load byte
	lodsb
	;put in PrintMe array
	stosb
	loop	reverse
	;add zero byte
	mov		eax, 0
	stosb
	lea		ebx, printME
	mdisplayString ebx

	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret	 4
writeVal ENDP
;Procedure to display array, sum, and average
;receives: &theArray, &result1
;returns: 
;preconditions: theArray size > 0
;registers changed: 
displayResults PROC
	LOCAL	intToPrint:DWORD
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	;assign parameters for array and result1
	mov		esi, [ebp + 12]
	mov		edx, [ebp + 8]
	;print string result1
	mDisplayString edx
	;set counter
	mov		ecx, 10
	cld 
	;clear eax so lodsd work
	mov		eax, 0
PrintArray:
	;load next value
	lodsd
	;convert to string and print with writeVal
	push	eax
	call	writeVal
	;check if final value to print else print comma
	cmp		ecx, 1
	je		LastVal
	;print comma
	mov		al, ','
	call	WriteChar
	;print space
	mov		al, ' '
	call	WriteChar
	loop PrintArray
LastVal:
	call	CrLf
	call	CrLF
	;clean up
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	
	ret		8
displayResults ENDP


;Procedure to displaysum, and average
;receives:  &sum, &result2, &average, &results3, 
;returns: 
;preconditions: 
;registers changed: 

displayResults2 PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	push	edx
	;load params
	mov		eax, [ebp + 20];sum
	mov		ebx, [ebp + 16];results2
	mov		ecx, [ebp + 12];average
	mov		edx, [ebp + 8];results3
	;print result2
	;wDisplayString ebx
	mov		edx, ebx
	call	WriteString
	;pass &sum writeVal
	push	eax
	call	writeVal
	call	CrLf
	;print result3
	call	WriteString
	;wDisplayString edx
	;pass  &average writeVal
	push	ecx
	call	writeVal
	call	CrLf
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	pop		ebp
	ret		16
displayResults2 ENDP

END main
