INCLUDE dqPROTO.inc

.386
.model flat,stdcall
.stack 4096

.data
oToPrint BYTE "O", 0

textALL BYTE "  ", 126 DUP(0)
		BYTE "(1) To Move RIGHT (2) To Move LEFT (3) To Move UP (4) To Move DOWN (5) Inventory", 48 DUP(0)
		BYTE "Current HP: ", 116 DUP(0)
		BYTE "Current Mana: ", 114 DUP(0)
		BYTE "Class: ", 121 DUP(0)
		BYTE "Strength: ", 118 DUP(0)
		BYTE "Dex: ", 123 DUP (0)
		BYTE "Int: ", 123 DUP (0)
		BYTE "Wis: ", 123 DUP (0)
		BYTE "EQUIPPED Weapon: ", 111 DUP(0)
		BYTE "EQUIPPED Armor: ", 112 DUP(0)
		BYTE "EQUIPPED Spell: ", 112 DUP(0)
		BYTE "Backpack: ", 118 DUP(0)
		BYTE ",", 127 DUP(0)
		BYTE "INPUT NOT SUPPORTED", 109 DUP(0)
		BYTE "Welcome to DUNGEON QUEST!!! Journey into the deep dept of the tomb of the DEAD mage Lichion. ", 35 DUP(0)
		BYTE "Find treasure or GLORY! ADVENTURE AWAITS!!!", 85 DUP(0)
		BYTE "Press (1) to continue...", 104 DUP(0)
		BYTE "Choose your class: (1) Fighter (2) Rogue (3) Wizard (4) Priest", 66 DUP(0)
		BYTE "(1) CONFIRM (2) CHOOSE AGAIN", 100 DUP(0)
		BYTE "You try to move in that direction realizing there is a wall in your way! Please select a valid direction!", 23 DUP(0)
		BYTE "(1) Equip Item From Backpack (2) Back", 91 DUP(0)
		BYTE "Enter in a number (1-5) to select item to equip (0) Back", 72 DUP(0)
		BYTE "Backpack is full (0) Discard Item (1-5) Insert into Backpack slot (This will discard that slots item)", 27 DUP(0)
		BYTE "In front of you is an old looking chest! (1) Open (2) Leave", 69 DUP(0)
		BYTE "Inside you find a FLAME SWORD (1) Add to backpack (2) Discard", 67 DUP(0)
		BYTE "Strangely you find a RICH mahogany bookshelf in front of you (1) Explore Bookshelf (2) Leave", 36 DUP(0)
		BYTE "One of the books speaks out to you a TOMB of FIRE LANCE (1) Add to Backpack (2) Discard", 41 DUP(0)
		BYTE "You find a ORNATELY designed GOLDEN wardrobe (1) Open (2) Leave", 65 DUP(0)
		BYTE "Inside is a DAPPER suit (1) Add to Backpack (2) Discard", 73 DUP(0)
		BYTE "On top of an anvil you find an ABSOLUTE monstrosity of a weapon (1) Inspect Further (2) Leave", 35 DUP(0)
		BYTE "You find a HAMMER dagger! (1) Add to Backpack (2) Discard", 71 DUP(0)
		BYTE "A old stone WELL sits in front of you (1) Toss in a coin (2) Leave", 62 DUP(0)
		BYTE "A strange page floats to the top of the water. A page of RADIANT EXPLOSION (1) Add to backpack (2) Discard", 22 DUP(0)
		BYTE "SHOVEL in ground. You pull shovel? (1) Yes (2) Leave", 76 DUP(0)
		BYTE "You get shovel. Shovel in bag? (1) Yes (2) Discard", 78 DUP(0)
		BYTE "(1) Melee Attack (2) Spell", 102 DUP(0)
		BYTE "NOT ENOUGH MANA", 113 DUP(0)
		BYTE "Attack Hits", 117 DUP(0)
		BYTE "Attack Misses", 115 DUP(0)
		BYTE "A slime stands in front of you...TIME TO FIGHT!", 81 DUP(0)
		BYTE "A weird skeleton blocks your path...TIME TO FIGHT!", 78 DUP(0)
		BYTE "A Skeleton Knight charges at you...TIME TO FIGHT!", 79 DUP(0)
		BYTE "The chest turns into a MIMIC...TIME TO FIGHT!", 83 DUP(0)
		BYTE "Its finally time...The Dead Mage Himself stands in front of you...DEAD MAGE Lichion...TIME TO FIGHT", 29 DUP(0)

.code
printText PROC, textID:WORD
	pushad

	; moves our textID into ax
	; and multiples it by 128 to set to to the correct
	; amount of bits for the message
	mov ax, textID
	mov cx, 128
	mul cx

	; moves into eax to make sure its fully cleared
	movzx eax, ax
	
	; offsets our textALL memory adress
	mov edx, OFFSET textALL

	; adds our textID*128 to select the correct message
	add edx, eax

	; writes out that message
	call WriteString

	popad
	ret
printText endp

printClass PROC
	pushad

	INVOKE printText, 4 ; Class
	call getRpClass
	mov edx, eax
	call WriteString
	INVOKE printText, 0

	INVOKE printText, 5 ; Strength
	call getStrength
	call WriteDec
	INVOKE printText, 0

	INVOKE printText, 6 ; Dex
	call getDex
	call WriteDec
	INVOKE printText, 0

	INVOKE printText, 7 ; Int
	call getInt
	call WriteDec
	INVOKE printText, 0

	INVOKE printText, 8 ; Wis
	call getWis
	call WriteDec
	INVOKE printText, 0
	
	call Crlf

	INVOKE printText, 2 ; HP
	call getHP
	call WriteDec
	INVOKE printText, 0

	INVOKE printText, 3 ; Mana
	call getMana
	call WriteDec
	INVOKE printText, 0

	call Crlf

	INVOKE printText, 9 ; equipped Weapon
	call getWeaponName
	mov edx, eax
	call WriteString
	INVOKE printText, 0
	call getWeaponNum
	INVOKE getDamage, ax
	call WriteDec
	INVOKE printText, 0

	INVOKE printText, 10 ; equipped Armor
	call getArmorName
	mov edx, eax
	call WriteString
	INVOKE printText, 0
	call getArmorNum
	call WriteDec
	INVOKE printText, 0

	INVOKE printText, 11 ; equipped Spell
	call getSpellName
	mov edx, eax
	call WriteString
	INVOKE printText, 0
	call getSpellNum
	INVOKE getDamage, ax

	call WriteDec
	INVOKE printText, 0

	call Crlf

	call printBP

	popad
	ret
printClass endP

printSquare PROC, typeOfSquare:DWORD
	
	push eax
	push edx

	mov eax, typeOfSquare

	; checks for the type of sqaure and jumps to that label
	; each label makes the bg color and text color the same
	; so we are then able to print out the sqaures
	.IF typeOfSquare == 0
		jmp setGray
	.ELSEIF typeOfSquare == 2
		jmp setGreen
	.ELSEIF typeOfSquare == 3
		jmp setYellow
	.ELSE
		jmp setWhite
	.ENDIF

	setGray:
		mov eax, gray+(gray*16)
		jmp printOUT

	setWhite:
		mov eax, white+(white*16)
		jmp printOUT

	setGreen:
		mov eax, green+(green*16)
		jmp printOUT

	setYellow:
		mov eax, yellow+(yellow*16)
		jmp printOUT

	printOUT:
		call SetTextColor

		; selects "O" as our string to print
		mov edx, OFFSET oToPrint
		call WriteString

		; resets our text color
		mov eax, white+(black*16)
		call SetTextColor

	pop edx
	pop eax

	ret

printSquare endp

END