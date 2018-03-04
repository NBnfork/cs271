TITLE Project5     (project5.asm)

; Author:Noah Buchen
; Course / Project ID: cs271            Date: 3 March 2018
; Description: This program will allow the user to choose 
;			   to create random numbers [10-200] that will 
;			   be displayed in a random order, then the median
;			   value will be displayed, and finally the sorted 
;			   list of numbers.

INCLUDE Irvine32.inc

UPPERLIMIT = 200 ; for user input 
LOWERLIMIT = 10
LO = 100 ; for RandomRange
HI = 999 

.data
mess1       BYTE    "Random Integer Sort by Noah Buchen", 13, 10,0
mess2		BYTE	"This program generates random numbers in the ",
					"range [100... 999],", 13, 10,
					"displays the original list, sorts the list, ",
					"calculates the ", 13, 10,
					"median value, and displays the sorted list.", 13, 10, 0
prompt1		BYTE	"How many numbers should be generated? [10-200]: ", 13, 10, 0
errorMess   BYTE    "Oops, that number is out of range. Enter [10-200]: ", 13, 10, 0
unsortMess	BYTE	"The unsorted random numbers:", 13, 10, 0
sortMess	BYTE	"The sorted list:", 13, 10, 0
medianMess	BYTE	"The median is "
userInput	DWORD	? ;number of ints to display
theArray	DWORD	UPPERLIMIT	DUP(?) ;array for random numbers 

.code
main PROC
	call	Randomize 
	call	intro
	;pass parameters for getData
	push	OFFSET userInput
	call	getData
	;pass parameters for fillArray
	push	OFFSET theArray
	push	userInput
	call	fillArray
	;pass parameters for displayList, set Carryflag
	push	OFFSET theArray
	push	userInput
	push	OFFSET unsortMess
	call	displayList
	;pass parameters for sortList
	push	OFFSET theArray
	push	userInput
	call	sortList
	;pass parameters for displayMedian
	push	OFFSET theArray
	push	userInput
	push	OFFSET medianMess
	call	displayMedian
	;pass parameters for displayList
	push	OFFSET theArray
	push	userInput
	push	OFFSET sortMess
	call	displayList

	exit	; exit to operating system
main ENDP

;Procedure to print intro of program.
;receives: 
;returns: 
;preconditions:
;registers changed: edx

intro PROC
	mov     edx, OFFSET mess1
	call    Writestring
	mov		edx, OFFSET mess2
	call	Writestring
	call	CrLF
	ret
intro	ENDP

;Procedure to gather data from user.
;receives: OFFSET userInput
;returns: userInput
;preconditions:
;registers changed:

getData	PROC
	pushad
	mov		ebp, esp
	;mov OFFSET of userInput to edi
	mov		edi, [ebp + 8]
	;output prompt
	mov		edx, OFFSET Prompt1
	call	WriteString
	;get input, set value and validate
	call	ReadDec
	mov		[edi], eax
	call	CrLf
	;pass validate parameters
	push	[edi]
	call	validate ;recursive
	popad
	ret
getData	ENDP

;Procedure to fill array with random numbers
;receives: OFFSET theArray, userInput
;returns: 
;preconditions: userInput <= 10
;registers changed:
fillArray	PROC

	ret
fillArray	ENDP

;Procedure to display each element of the array.
;receives: OFFSET theArray, userInput, OFFSET (message to print)
;returns: 
;preconditions: array size = userInput
;registers changed:
displayList	PROC
;set up stack frame
	pushad
	mov		ebp, esp
	; mov theArray into esi
	mov		esi, [ebp + 16]
	; mov userInput (count) into ecx
	mov		ecx, [ebp + 12]
	;mov Mess into edx to print
	mov		edx, [ebp + 8]
	call	WriteString
	call	CrLf

	mov		ebx, 1 ; to manage column formating
PrintLoop:
	;print value
	mov		eax, [esi]
	call	WriteDec
	call	manageOutput ;uses ebx
	;add 4 to esi to get to next value
	add		esi, 4
	loop	PrintLoop
	call	CrLF
	;clean up
	popad	
	ret 12
displayList	ENDP

;Procedure to sort the list into decesending order
;receives: OFFSET theArray, userInput
;returns: 
;preconditions: array size = userInput
;registers changed:
sortList	PROC

	ret
sortList	ENDP

;Procedure to exchange array elements for selection sort.
;receives: OFFSET theArray[i], OFFSET theArray[j] (i and j are elements to be compared)
;returns: 
;preconditions: i and j must be > userInput - 1
;registers changed:
exchange	PROC

	ret
exchange	ENDP

;Procedure calculate the  median value.
;receives: OFFSET theArray, userInput, OFFSET medianMess 
;returns: 
;preconditions: theArray is sorted
;registers changed:
displayMedian	PROC
;set up stack frame
	pushad
	mov		ebp, esp
	; mov theArray into esi
	mov		esi, [ebp + 16]
	; mov userInput (count) into ebx
	mov		eax, [ebp + 12]
	;mov medianMess into edx and print
	mov		edx, [ebp + 8]
	call	WriteString
	;calculate median
	;check if odd or even elements
	;div count by 2
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	;check remainder
	cmp		edx, 0
	je		ifEven
	;if odd: access and print value @theArray[quoient + 1]
	shl		eax, 2 ;a.k.a mul by 4
	add		esi, eax
	mov		eax, [esi]
	call	WriteDec
	call	CrLf
	call	CrLf
	jmp		cleanUp
ifEven:
	
	;add value @theArray[i] and @theArray[i+1]
	;save current index value
	mov		ebx, eax
	;access quoient + 1
	shl		eax, 2 ;a.k.a mul by 4
	add		esi, eax
	mov		eax, [esi]
	;save value in ebx
	mov		ebx, eax
	;sub 4 from esi to access Array[i]
	sub		esi, 4
	;access value @ theArray[i]
	mov		eax, [esi]
	add		eax, ebx
	;find average by dividing by two
	mov		edx, 0
	mov		ebx, 2
	div		ebx ; quoient in eax
	;print result and linefeed
	call	WriteDec
	call	CrLf
	call	CrLf

cleanUp:
	;clean up
	popad
	ret 12
displayMedian	ENDP

;Procedure to print spaces and linefeeds
;receives: 
;returns: 
;preconditions: 
;registers changed: ebx

manageOutput	PROC
	;save registers
	push	ecx
	push	eax

	; loop to print spaces
	mov		ecx, 4
spaceLoop:
	mov		eax, ' '
	call	WriteChar
	loop	spaceLoop

	;check for linefeed
	cmp     ebx, 10
	je      lineFeed
	inc		ebx
	;restore registers
	pop		ecx
	pop		eax
	ret

lineFeed:
	call	CrLF
	;reset ebx (column counter)
	mov     ebx, 1
	;restore registers
	pop		ecx
	pop		eax
	ret
manageOutput ENDP

;Recursive procedure to validate input range
;receives: userInput 
;returns: 
;preconditions: userInput != ?
;registers changed: 
validate PROC
;termsTotal is <= upperlimit
	pushad
	mov		ebp, esp
	;move param value to eax
	mov		eax, [ebp + 8]
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
	mov     edx, OFFSET errorMess
	call    WriteString
	call	getData

validated: 
	popad
	ret 4
validate ENDP
END main
