INCLUDE dqPROTO.inc

.386
.model flat,stdcall
.stack 4096

.data
; 1 for fire damage ; 2 for cold damage ; 3 for radiant
; 1 is for Melee WEAPONS ; 2 is for armor ; 3 is for spells
; 1 is for strength melee ; 2 is for dex melee
itemNames BYTE "FLAME SWORD", 21 DUP(0)
		  BYTE "TOMB of FIRE LANCE", 14 DUP(0)
		  BYTE "DAPPER SUIT", 21 DUP(0)
		  BYTE "HAMMER DAGGER", 19 DUP(0)
		  BYTE "RADIANT EXPLOSION", 15 DUP(0)
		  BYTE "TOTALLY RAD SHOVEL", 14 DUP(0)

itemNums WORD 115, 132, 11, 219, 322, 101
itemIDs BYTE 1, 3, 2, 1, 3, 1

; each of the following "arrays" are used to store our monster stats
; this allows us to have a modular approach when adding encouters
enemyNames BYTE "SLIME", 27 DUP(0)
		   BYTE "WEIRD SKELETON", 18 DUP(0)
		   BYTE "SKELETON KNIGHT", 17 DUP(0)
		   BYTE "MIMIC", 27 DUP(0)
		   BYTE "DEAD MAGE LICHION", 15 DUP(0)

enemyHps WORD 22, 47, 62, 55, 89
enemyNums WORD 5, 8, 12, 9, 15 ; the amount of damage the monster does
enemyHits BYTE 2, 3, 5, 3, 5 
enemyACs BYTE 12, 14, 16, 14, 15
enemyDDamages BYTE 2, 3, 3, 1, 3 ; this is used for what spell damage would be strong agaisnt the monster

.code

twoEvent PROC, eventID:WORD
	; we move our eventID into eax and mul it by 2
	; becuase each textID for our text handler for twoEvents
	; goes in pairs E.X. (Chest infront of you | Chest opened message)
	movzx eax, eventID
	mov dx, 2
	mul dx

	; 24 is the root textID for all twoEvent messages
	add eax, 24

	mov dx, ax

	; prints out our first twoEvent textID message
	INVOKE printText, dx
	call crlf

	call readInput

	; if we enter 2 that means the player is wanting to LEAVE
	; the event so we just ret
	.IF eax == 2
		ret
	.ENDIF

	; we move up our textID to get the next message in the two event
	inc dx

	INVOKE printText, dx
	call crlf

	call readInput

	; if we enter 2 that means the player is wanting to LEAVE
	; the event so we just ret
	.IF eax == 2
		ret
	.ENDIF

	; we reload eax with eventID making sure its cleared
	movzx eax, eventID

	; the following code preps all our parameters for the addItemToBP fuction
	; all twoEvents adds an item to the backpack

	; we load the address of our itemNames "array"
	; than we select the correct addres for our 32 bit item Name text
	mov ecx, OFFSET itemNames
	mov dx, 32
	mul dx
	add ecx, eax

	; this is us loading in that information from our "arrays"
	movzx eax, eventID
	mov bx, [itemNums + eax*2]
	mov dl, [itemIDs + eax]

	INVOKE addItemToBP, ecx, bx, dl

	ret
twoEvent endp

combatEvent PROC, enemyID:BYTE
	LOCAL enemyName:DWORD, enemyDamage:WORD, enemyHP:WORD, enemyHit:BYTE, enemyAC:BYTE, enemyVun:BYTE
	
	movzx eax, enemyID

	; same concept of loading used in twoEvent for the items
	; but with the enemy information "arrays"
	mov ecx, OFFSET enemyNames
	mov dx, 32
	mul dx
	add ecx, eax

	mov enemyName, ecx

	; we load each in taking care of DWORDS, WORDS and BYTES
	movzx eax, enemyID
	mov ax, [enemyNums + 2*eax]
	mov enemyDamage, ax

	movzx eax, enemyID
	mov ax, [enemyHps + 2*eax]
	mov enemyHP, ax

	movzx eax, enemyID
	mov al, [enemyHits + eax]
	mov enemyHit, al

	movzx eax, enemyID
	mov al, [enemyACs + eax]
	mov enemyAC, al

	movzx eax, enemyID
	mov al, [enemyDDamages + eax]
	mov enemyVun, al

	movzx eax, enemyID
	add eax, 40 ;40 is the base textID for the start of enemy textID messages

	; prints out our first enemy encouter text
	INVOKE printText, ax
	call crlf

	combatStart:
		; prints out the enemy name and HP
		mov edx, enemyName
		call WriteString
		INVOKE printText, 0 ; this is a " " character

		movzx eax, enemyHP
		call WriteDec
		call crlf
		
		; prints out the players information
		INVOKE printText, 2 ; HP
		call getHP
		call WriteDec
		INVOKE printText, 0

		INVOKE printText, 3 ; Mana
		call getMana
		call WriteDec
		INVOKE printText, 0 ; this is a " " character
		call Crlf

		; prints out the players combat options
		INVOKE printText, 36
		call crlf

		call readInput

		; if they eneter 2 we know they want to do a spellAttack
		.IF eax == 2
			jmp spellAttack
		.ENDIF

		jmp meleeAttack

		meleeAttack:
			; we roll a d20 and store it in dx
			call roll20
			mov dx, ax

			; we get our type
			call getWeaponNum
			INVOKE getType, ax

			; if the type is 1 its strenth
			; if its 2 its dex
			; we add this to our d20 roll to add our hit
			.IF ax == 1
				call getStrength
				add dx, ax
			.ELSE
				call getDex
				add dx, ax
			.ENDIF

			; we check if our role is greater than our enemy ac
			; if it is we hit them
			.IF dl > enemyAC
				; we make sure that edx is clear
				mov edx, 0

				mov dx, ax

				; we get our weapons damage
				call getWeaponNum
				INVOKE getDamage, ax

				; we add our dex/strength modifier to the attack
				add edx, eax

				; we sub that from our enemysHP and we check for carry
				; if carry is set we know that the enemy has negative HP
				; thus they are dead
				sub enemyHP, dx
				jc enemyDied

				; prints out the attack hit message
				INVOKE printText, 38
				call crlf

			.ELSE
				; prints out the attaack miss message
				INVOKE printText, 39
				call crlf
			.ENDIF

			; goes to enemy turn
			jmp enemyTurn

		spellAttack:
			; same concept as a melee attack
			call getSpellNum
			INVOKE getDamage, ax

			; howver we check if we have enough mana to cast
			movzx edx, ax
			call getMana

			; if we have enough we skip over the "not eneough mana message"
			sub eax, edx
			jnc enoughtMana

			INVOKE printText, 37 ; not enough mana message
			jmp enemyTurn


		enoughtMana:
			; we get the spell Num
			; and get its damage
			call getSpellNum
			INVOKE getDamage, ax
			movzx esi, ax
			movzx edx, ax

			; this is used to subtract from our mana
			INVOKE setMana, edx, 1

			; we get the spell Num 
			; to see if its affective agaisnt the creature or not
			call getSpellNum
			INVOKE getType, ax

			; if it is we double our damage
			.IF al == enemyVun
				add edx, esi
			.ENDIF

			; we check if its a wisdom or and int spell
			; and add damage to the attack based on that
			.IF al == 3
				call getWIs
				add edx, eax
			.ELSE
				call getInt
				add edx, eax
			.ENDIF

			; same as melee attack checking
			sub enemyHP, dx
			jc enemyDied

			jmp enemyTurn
			
		enemyTurn:
			; same concept of the players melee attack but just for the creature
			call getArmorNum
			mov edx, eax

			call roll20
			movzx esi, enemyHit
			add eax, esi
			
			.IF eax > edx
				mov edx, enemyName
				call WriteString
				INVOKE printText, 0
				INVOKE printText, 38

				call crlf

				call getHP
				movzx edx, enemyDamage
				sub eax, edx

				jc playerDied

				movzx eax, enemyDamage

				INVOKE setHp, eax, 1
				jmp combatStart
			.ELSE
				mov edx, enemyName
				call WriteString
				INVOKE printText, 0
				INVOKE printText, 39
				call crlf

				jmp combatStart
			.ENDIF

		enemyDied:
			ret

		playerDied:
			invoke ExitProcess, 0

combatEvent endp

roll20 PROC
	mov eax, 20
	call RandomRange
	inc eax
	ret
roll20 endp

END