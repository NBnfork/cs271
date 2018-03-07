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
prompt1		BYTE	"How many numbers should be generated? [10-200]: ", 0
errorMess   BYTE    "Oops, that number is out of range!", 13, 10, 0
unsortMess	BYTE	"The unsorted random numbers:", 13, 10, 0
sortMess	BYTE	"The sorted list:", 13, 10, 0
medianMess	BYTE	"The median is ", 0
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
	;pass parameters for displayList
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
	push	ebp
	mov		ebp, esp
	;mov OFFSET of userInput to ebx
	mov		ebx, [ebp + 8]
	;output prompt
	mov		edx, OFFSET Prompt1
	call	WriteString
	;get input, set value and validate
	call	ReadInt
	mov		[ebx], eax
	call	validate ;recursive
	call	CrLf
	pop		ebp
	ret		4
getData	ENDP

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
;source: provided excellent anology for QS http://me.dt.in.th/page/Quicksort/
sortList	PROC
	push	ebp
	mov		ebp, esp
	;save Array index	
	mov		esi, [ebp + 12] 
	;save array size 
	mov		ecx, [ebp + 8]
	
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
	pop		ebp
	ret		8	
sortList	ENDP

;Procedure to exchange array elements for selection sort.
;receives: OFFSET theArray[i], OFFSET theArray[j] (i and j are elements to be exchanged)
;returns: 
;preconditions: i and j must be > userInput - 1
;registers changed: none		 
exchange	PROC USES eax ebx edx esi edi
	push	ebp
	mov		ebp, esp
	;save first pram
	mov		esi, [ebp + 8]
	;save second pram
	mov		edi, [ebp + 12]
	;sav first in temp
	mov		eax, [esi]
	;sav second in temp
	mov		ebx, [edi]
	;swap
	mov		[esi], ebx
	mov		[edi], eax	
	;clean up
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
