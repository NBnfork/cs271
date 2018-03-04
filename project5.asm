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
unsortMess	BYTE	"The unsorted random numbers:", 13, 10, 0
sortMess	BYTE	"The sorted list:", 13, 10, 0
medianMess	BYTE	"The median is ", 13, 10, 0

userInput	DWORD	? ;number of ints to display
theArray	DWORD	UPPERLIMIT	DUP(?) ;array for random numbers 

.code
main PROC
	call	Randomize 
	call	intro
	call	getData
	call	fillArray
	call	displayList
	call	sortList
	call	displayMedian
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
;receives: OFFSET theArray, userInput, OFFSET unsortedMess, OFFSET sortedMess
;returns: 
;preconditions: array size = userInput
;registers changed:
displayList	PROC

	ret
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
;receives: userInput, OFFSET theArray 
;returns: userInput
;preconditions: theArray is sorted
;registers changed:
displayMedian	PROC

	ret
displayMedian	ENDP

END main
