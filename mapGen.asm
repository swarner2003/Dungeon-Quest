INCLUDE dqPROTO.inc

.386
.model flat,stdcall
.stack 4096

.data ; LAST EVENT NUM -> 14
baseMap BYTE 6, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 12, 1, 1, 1
		BYTE 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1
		BYTE 0, 1, 0, 5, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1
		BYTE 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 14
		BYTE 0, 10, 1, 1, 1, 4, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1
		BYTE 0, 1, 0, 1, 0, 0, 0, 1, 0, 9, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0
		BYTE 2, 1, 0, 0, 0, 8, 1, 1, 1, 1, 1, 11, 1, 1, 1, 1, 13, 1, 1, 7

.code
printMap PROC

	pushad

	; we first clear the screen
	call Clrscr
	
	; moves in 7 as our outter loop value
	; since our map has "7" rows
	mov ecx, 7
	mov ebx, 0

	; this loops through our "2D ARRAY" which is actually just a line of data in memory
	L1:
		push ecx
		mov ecx, 20 ; 20 collums
		L2:
		
		; we print out our current value of baseMap as a sqaure
		INVOKE printSquare, [baseMap + ebx]

		; since its just a LINE of number in memory we simple just need to increase ebx to go to
		; the next sqaure value of the map
		inc ebx
		loop L2

	; the only reason this needs to be to loops is so
	; we can print out the next line to make the map
	; a sqaure instead of a line of square
	call CRLF

	pop ecx
	loop L1


	popad
	ret

printMap endp


convertXYtoMAP PROC, xVal:BYTE, yVal:BYTE

	push edx
	push ecx

	; we multiple our yVal here by 20 as that reprenets our row
	movzx bx, xVal
	movzx cx, yVal
	mov ax, 20
	mul cx

	; we than add it to our xVal and return
	add bx, ax

	movzx eax, bx

	pop ecx
	pop edx

	ret	
convertXYtoMAP endp

getValOnMap PROC, xCord:BYTE, yCord:BYTE
	push edx

	; we convert our cord parameters to a value that the base map can use
	INVOKE convertXYtoMAP, xCord, yCord
	mov edx, eax
	; we than simply call the "ARRAY" of baseMap by that value
	movzx eax, baseMap[edx] 

	pop edx
	ret
getValOnMap endp

setValOnMap PROC, xCord:BYTE, yCord:BYTE, val:BYTE
	pushad

	; same thing as getValOnMap PROC but we are moving the value
	; into the map 
	INVOKE convertXYtoMAP, xCord, yCord
	mov cl, val
	mov [baseMap + eax], cl

	popad
	ret
setValOnMap endp


END