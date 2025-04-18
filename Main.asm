INCLUDE dqPROTO.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.code
main PROC PUBLIC

	; prints out the starting welcome message
	INVOKE printText, 15
	call crlf

	INVOKE printText, 16
	call crlf

	INVOKE printText, 17

	call readInput

	call Clrscr

	pickClass:
		; prints out the starting pick a class message
		INVOKE printText, 18
		call crlf

		call readInput

		INVOKE loadClass, eax

		; prints out the classes information
		call printClass
		call crlf

		; prints out the class pick prompt
		INVOKE printText, 19
		call crlf

		call readInput

		; if the player enters 2 that means they didnt confirm there class 
		; so we restart the process
		.IF eax == 2
			jmp pickClass
		.ENDIF

	gameLoop:
		; prints out the map
		call printMap
		call crlf

		; prints out the playerMove options
		INVOKE printText, 1
		call crlf

		call playerMove

		; our playerMove PROC returns in eax if the Invetory option was chosen
		; if eax is 1 than we know that the player has enetered the inventory
		; so we go to the backpack menu
		.IF eax == 1
			call backPackMenu
		.ENDIF

		jmp gameLoop
		

	invoke ExitProcess, 0

main endp
end main