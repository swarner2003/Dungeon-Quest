INCLUDE dqPROTO.inc

.386
.model flat,stdcall
.stack 4096

.data

playerX BYTE 0
playerY BYTE 6

.code

readInput PROC
	start:
		; reads in the players decimal numbers input until enter is slected
		call ReadDec
		; carry flag is set if the number is to big or not a number
		jc trashInput
		
		; we reject any number above 5
		.IF eax > 5
			jmp trashInput
		.ENDIF

		ret

	trashInput:
		; prints out the invalid input text
		INVOKE printText, 14
		call crlf
		jmp start

readInput endp

playerMove PROC
	local playerDir:BYTE

	movStart:	

		call readInput

		; moves the direction number into our temp variable
		mov playerDir, al
		
		; we load our player x and y into eax and edx
		; so when we attemp our movement we dont overwrite the cords
		; if the movement is invalid
		movzx eax, playerX 
		movzx edx, playerY

		; updates x or y according to the direction inputed by the players
		; if its 5 that means that the player has chosen to enter the inventory
		; instead of moving
		.IF playerDir == 1
			inc eax
		.ELSEIF playerDir == 2
			sub eax, 1
		.ELSEIF playerDir == 3
			sub edx, 1
		.ELSEIF playerDir == 4
			inc edx
		.ELSE
			jmp inventoryDUMP
		.ENDIF

		; checks if any of our sub proc set the carry flag
		; meaning a 0-1 
		jc invalidMovement

		; checks if we are bounding in the positive direction
		.IF eax == 20
			jmp invalidMovement
		.ELSEIF edx == 7
			jmp invalidMovement
		.ENDIF

		push eax
		push edx

		; moves al into bl
		; because getValOnMap overwrite eax
		mov bl, al

		; finds what the current value is on the map
		; that we have moved to
		INVOKE getValOnMap, bl, dl

		mov esi, eax

		; 0 means that we are trying to move into a wall
		; so its an invalidMovement
		.IF esi == 0
			jmp invalidMovement
		.ENDIF

		pop edx
		pop eax
		mov bl, al

		; we set values on our mapes
		; 2 being our player number and 3 being the yellow visited trace
		INVOKE setValOnMap, bl, dl, 2
		INVOKE setValOnMap, playerX, playerY, 3

		; we update our playerX and playerY to there new values
		mov playerX, bl
		mov playerY, dl

		; we check if its a combat event
		.IF esi >= 10
			; if it is we subtract 10
			; to start our combatIDs at 0
			mov eax, esi
			sub eax, 10

			INVOKE combatEvent, al
		.ELSEIF esi >= 4 
			; samething as above but with our 2 event ids
			mov eax, esi
			sub eax, 4

			INVOKE twoEvent, ax
		.ENDIF

		; moves 0 into eax showing that this was a movement event rather 
		; than an inventory event
		mov eax, 0

		ret

	invalidMovement:
		; prints out our invalid movement text
		; loops back to the start
		INVOKE printText, 20
		call crlf

		jmp movStart

	inventoryDUMP:
		; sets eax to 1 showing that the player has choesn the inventory option
		mov eax, 1
		ret
	
playerMove endp

backPackMenu PROC
	
	; we printOut our class information
	; which includes our backpack information as well
	call printClass
	call crlf

	jmp startOfMenu

	startOfMenu:
		; we prompt the player if they want to equip something from the backpack
		; or leave
		INVOKE printText, 21
		call crlf

		call readInput

		; 2 means leave so we ret
		.IF eax == 2
			ret
		.ENDIF

		; else means they want to equip something from the backpack
		; so we print out the information prompt about that
		INVOKE printText, 22
		call crlf

		call readInput

		; 0 means leave so we go back to the start of the menu
		.IF eax == 0
			jmp startOfMenu
		.ENDIF

		; we decrease eax to match it with the 0-4 used in "arrays"
		dec eax

		; we equip the item from the player input
		INVOKE equipItemFromBP, al

		; we then clear the screen and go back to the start of the menu
		call Clrscr
		call printMap
		call printClass
		call crlf

		jmp startOfMenu



backPackMenu endp


END