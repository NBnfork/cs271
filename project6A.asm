TITLE Project6A     (project6A.asm)

; Author:Noah Buchen
; Course / Project ID: cs271 #6A         Date: 15 March 2018
; Description: This program will allow the user to input 10
;			   unsigned numbers that will be displayed, summed 
;			   and averaged.			  

INCLUDE Irvine32.inc

LOWERLIMIT = 0 ;of user input
UPPERLIMIT = 4,294,967,295 

;marco will display a string 
;parameters: name of the string
mDisplayString MACRO stringName
	push	edx
	mov		edx, OFFSET stringName
	call	WriteString
	pop		edx
ENDM

;macro will display a prompt and store a string in a variable
;parameters: prompt, name of variable to 
mGetString MACRO prompt, varName
	push	eax
	push	ecx
	;display prompt
	mDisplayString prompt
	;get string and  save in varName, 
	mov		edx, OFFSET	varName
	mov		ecx, (SIZEOF varName) - 1
	call	ReadString
	call	CrLf
	pop		edx
	pop		ecx
	pop		eax
ENDM

.data
mess1       BYTE    "Low Level I/O Fun by Noah Buchen", 13, 10,0
mess2		BYTE	"Please provide 10 unsigned decimal integers.", 13, 10
					"The integers must fit in a 32 bit register. ", 13, 10
					"This program will then display the integers,",
					" their sum, and their average.", 13, 10, 0
prompt1		BYTE	"Enter an unsigned integer: ", 0
errorMess   BYTE    "ERROR: bad input!", 13, 10,
					"Try again:" , 0
results1	BYTE	"You enter the following numbers: ", 13, 10, 0
results2	BYTE	"Their sum: ", 13, 10, 0
results3	BYTE	"Their average: ", 0
userInput	BYTE	10	DUP(0) ;user inputed string
goodInt		DWORD	?
theArray	DWORD	10	DUP(?) ;array for integers
sum			DWORD	?
average		DWORD	?



.code
main PROC
	;display intoduction
	mDisplayString mess1
	mDisplayString mess2
	call	CrLF
	;buildArray by using ReadVal PROC
	push	OFFSET theArray
	push	goodInt
	call	buildArray
	;pass params
	push	sum
	call	sumArray
	;pass params
	push	average
	call	averageArray
	;pass params
	push	OFFSET theArray
	push	sum
	push	average
	call	displayResults
	exit	; exit to operating system
main ENDP



;Procedure to gather data from user and put it into an array
;receives: OFFSET theArray
;returns: theArray
;preconditions:
;registers changed:

buildArray	PROC
	push	ebp
	mov		ebp, esp
	push	esi
	push	ebx
	push	eax
	;mov OFFSET of theArray to ebx
	mov		esi, [ebp + 12]
	;mov goodInt
	mov		ebx, [ebp +8]
	;set counter
	mov		ecx, 10
fillwith10:
	;push params
	push	ebx 
	call	ReadVal
	;mov goodInt and place in array position
	mov		eax, ebx
	mov		[esi], eax
	add		esi, 4
	loop	fillwith10
	;clean up
	pop		eax
	pop		ebx
	pop		esi
	pop		ebp
	ret		4
buildArray	ENDP

;Procedure to fill array with random numbers
;receives: OFFSET theArray, userInput
;returns: 
;preconditions: userInput <= 10
;registers changed: esi, ecx, eax
;source: Lecture 20: Displaying Arrays and Using Random Numbers
fillArray	PROC
	push	ebp
	mov		ebp, esp
	; mov theArray into esi
	mov		esi, [ebp + 12]
	; mov userInput (count) into ecx
	mov		ecx, [ebp + 8]
	;assert ecx >= 10
	cmp		ecx, 9
	je		assertFailed
fillLoop:
	;generate random between lo and high
	;range = 999 - 100 +1
	mov		eax, 900
	call	RandomRange
	;add low to eax
	add		eax, 100
	;put it in array index [esi]
	mov		[esi], eax
	;inc esi
	add		esi, 4
	loop	fillLoop

assertFailed:
	pop		ebp
	ret		8
fillArray	ENDP

;Procedure to display each element of the array.
;receives: OFFSET theArray, userInput, OFFSET (message to print)
;returns: 
;preconditions: array size = userInput
;registers changed: eax, ebx, ecx
displayList	PROC
;set up stack frame
	push	ebp
	mov		ebp, esp
	; mov theArray into esi
	mov		esi, [ebp + 16]
	; mov userInput (count) into ecx
	mov		ecx, [ebp + 12]
	;mov Mess into edx to print
	mov		edx, [ebp + 8]
	call	WriteString

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
	call	CrLF
	;clean up
	pop		ebp
	ret		12
displayList	ENDP

;Procedure to QuickSort the list into decesending order
;receives: OFFSET theArray, userInput 
;returns: when base case met
;preconditions: array size = userInput
;registers changed: eax, ebx, ecx, edx
;source: provided excellent analogy for QS http://me.dt.in.th/page/Quicksort/
sortList	PROC 
	push	ebp
	mov		ebp, esp
	;save Array index	
	mov		esi, [ebp + 12] 
	;save array size 
	mov		ecx, [ebp + 8]
	pushad
	;set number of comparisons to make
	dec		ecx
	;set GreatThanSize(eax) to zero
	mov		eax, 0
	;set lessThanSize(ebx) to zero
	mov		ebx, 0
	;save pivot value in edi
	mov		edi, [esi]
	;save swapaddress in edx
	add		esi, 4
	mov		edx, esi
Compare:
	
	;compare pivot to next element
	cmp		edi, [esi]
	jg		lessThan ; to make the array of values that are less
	;greater
	;exchange, move swap address up, 
	push	edx
	push	esi
	call	exchange
	add		edx, 4
	;inc size of GreaterThanArray(eax)
	inc		eax
	; then access next element
	add		esi, 4
	loop	Compare
	jmp		Swap
LessThan:	
;	inc size of lessThanArry, then access next element
	inc		ebx
	add		esi, 4
	
	loop	Compare
Swap:
	;swap pivot with position right before swap
	sub		edx, 4
	push	edx ;final @pivot point position
	;get piviot to push
	mov		ecx, userInput
	shl		ecx, 2
	sub		esi, ecx
	push	esi ;@pivot 
	call	exchange


	;check base case for greaterThanArray
	cmp		eax, 2
	jl		checkLess

	;recursivily sort greaterThanArray, push starting address
	push	esi
	push	eax; greatThanArray size
	call	sortList

	;check base case for lessThanArray

checkLess:
	cmp		ebx, 2
	jl		baseCase

	;sort lessThanArray
	add		edx, 4 ;move to [pivot +1]
	push	edx
	push	ebx ; lessThanArray size
	call	sortList

baseCase:
	;clean up
	popad
	pop		ebp
	ret		8	
sortList	ENDP

;Procedure to exchange array elements for selection sort.
;receives: addresses of two elements to swap
;returns: 
;preconditions: 
;registers changed: none		 
exchange	PROC 
	push	ebp
	mov		ebp, esp
	;save first pram
	mov		esi, [ebp + 12]
	;save second pram
	mov		edi, [ebp + 8]
	pushad
	;sav first in temp
	mov		eax, [esi]
	;sav second in temp
	mov		ebx, [edi]
	;swap
	mov		[esi], ebx
	mov		[edi], eax	
	;clean up
	popad
	pop		ebp
	ret		8
exchange	ENDP

;Procedure calculate the  median value.
;receives: OFFSET theArray, userInput, OFFSET medianMess 
;returns: 
;preconditions: theArray is sorted
;registers changed:
displayMedian	PROC
;set up stack frame
	push	ebp
	mov		ebp, esp
	; mov theArray into esi
	mov		esi, [ebp + 16]
	; mov userInput (count) into eax
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
	pop		ebp
	ret		12
displayMedian	ENDP

;Procedure to print spaces and linefeeds
;receives: 
;returns: 
;preconditions: 
;registers changed: ebx

manageOutput	PROC
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
	pop		eax
	pop		ecx
	ret

lineFeed:
	call	CrLF
	;reset ebx (column counter)
	mov     ebx, 1
	pop		eax
	pop		ecx
	ret
manageOutput ENDP

;Recursive procedure to validate input range
;receives: 
;returns: 
;preconditions: userInput != ?
;registers changed: ebx
validate PROC
;termsTotal is <= upperlimit
	pushad
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
	push	OFFSET	userInput
	call	getData

validated: 
	popad
	ret 
validate ENDP

END main
