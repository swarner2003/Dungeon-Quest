INCLUDE dqPROTO.inc

.386
.model flat,stdcall
.stack 4096

.data
gameMap DWORD ?

.code
loadMap PROC
	call generateMap

	mov gameMap, eax

	ret
loadMap endp

printMap PROC

	pushad

	call Clrscr
	
	mov ecx, 10
	mov ebx, 0

	L1:
		push ecx
		mov ecx, 10
		L2:

		mov esi, OFFSET gameMap

		push ebx

		mov eax, 4
		mul ebx

		pop ebx

		add esi, eax

		INVOKE printSquare, [esi]

		inc ebx
		loop L2

	call CRLF

	pop ecx
	loop L1


	popad
	ret

printMap endp

END