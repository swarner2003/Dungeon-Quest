INCLUDE dqPROTO.inc

.386
.model flat,stdcall
.stack 4096

.data

emtpyBP BYTE "EMPTY", 0

; playerClass STRUCT
playerClass STRUCT
	className DWORD ?
	hpRate DWORD ?
	manaRate DWORD ?
	strengthRate BYTE ?
	dexRate BYTE ?
	intRate BYTE ?
	wisRate BYTE ?
	weapon DWORD ?
	weaponNum WORD ?
	weaponID BYTE 1
	armor DWORD ?
	armorNum WORD ?
	armorID BYTE 2
	spell DWORD ?
	spellNum WORD ?
	spellID BYTE 3
	backPack DWORD OFFSET emtpyBP, OFFSET emtpyBP, OFFSET emtpyBP, OFFSET emtpyBP, OFFSET emtpyBP
	backPackNum WORD 5 DUP(0)
	backPackID BYTE 5 DUP(0)
playerClass ENDS

rpClass playerClass <,,,,,,,,,,,,,,>
bpIndex BYTE 0

; the following data will be used when choosing what class we want to play
fighterNameSpace BYTE "Fighter", 0
fighterWeaponSpace BYTE "STEEL SWORD", 0
fighterArmorSpace BYTE "IRON ARMOR", 0
fighterSpellSpace BYTE "FIRE BOLT", 0

rogueNameSpace BYTE "Rogue", 0
rogueWeaponSpace BYTE "STEEL DAGGER", 0
rogueArmorSpace BYTE "LEATHER ARMOR", 0
rogueSpellSpace BYTE "FROZEN GUST", 0

wizardNameSpace BYTE "Wizard", 0
wizardWeaponSpace BYTE "WOODEN STAFF", 0
wizardArmorSpace BYTE "WIZARD ROBE", 0
wizardSpellSpace BYTE "FIRE BALL", 0

priestNameSpace BYTE "Priest", 0
priestWeaponSpace BYTE "WOODEN STAFF", 0
priestArmorSpace BYTE "PRIEST VESTMENTS", 0
priestSpellSpace BYTE "HOLY NOVA", 0

.code
loadClass PROC, classID:DWORD
	; the following if statements load the playerClass STRUCT based on the classID

	.IF classID == 1 ; Fighter
		mov rpClass.className, OFFSET fighterNameSpace
		mov rpClass.hpRate, 77
		mov rpClass.manaRate, 50
		mov rpClass.strengthRate, 7
		mov rpClass.dexRate, 2
		mov rpClass.intRate, 2
		mov rpClass.wisRate, 2
		mov rpClass.weapon, OFFSET fighterWeaponSpace
		mov rpClass.weaponNum, 112
		mov rpClass.armor, OFFSET fighterArmorSpace
		mov rpClass.armorNum, 16
		mov rpClass.spell, OFFSET fighterSpellSpace
		mov rpClass.spellNum, 108 ; 1 is for FIRE damage

	.ELSEIF classID == 2 ;Rogue
		mov rpClass.className, OFFSET rogueNameSpace
		mov rpClass.strengthRate, 1
		mov rpClass.hpRate, 44
		mov rpClass.manaRate, 80
		mov rpClass.dexRate, 7
		mov rpClass.intRate, 4
		mov rpClass.wisRate, 2
		mov rpClass.weapon, OFFSET rogueWeaponSpace
		mov rpClass.weaponNum, 208
		mov rpClass.armor, OFFSET rogueArmorSpace
		mov rpClass.armorNum, 14
		mov rpClass.spell, OFFSET rogueSpellSpace
		mov rpClass.spellNum, 212 ; 2 is for COLD damage

	.ELSEIF classID == 3 ;Wizard
		mov rpClass.className, OFFSET wizardNameSpace
		mov rpClass.hpRate, 32
		mov rpClass.manaRate, 182
		mov rpClass.strengthRate, 1
		mov rpClass.dexRate, 1
		mov rpClass.intRate, 7
		mov rpClass.wisRate, 4
		mov rpClass.weapon, OFFSET wizardWeaponSpace
		mov rpClass.weaponNum, 104
		mov rpClass.armor, OFFSET wizardArmorSpace
		mov rpClass.armorNum, 12
		mov rpClass.spell, OFFSET wizardSpellSpace
		mov rpClass.spellNum, 122
	.ELSE ;priest
		mov rpClass.className, OFFSET priestNameSpace
		mov rpClass.hpRate, 45
		mov rpClass.manaRate, 140
		mov rpClass.strengthRate, 1
		mov rpClass.dexRate, 1
		mov rpClass.intRate, 4
		mov rpClass.wisRate, 8
		mov rpClass.weapon, OFFSET priestWeaponSpace
		mov rpClass.weaponNum, 104
		mov rpClass.armor, OFFSET priestArmorSpace
		mov rpClass.armorNum, 14
		mov rpClass.spell, OFFSET priestSpellSpace
		mov rpClass.spellNum, 318 ; 3 is for RADIANT damage
		
	.ENDIF

	ret

loadClass endp

; following are abunch of getters and setters for our STRUCT
getHP PROC
	mov eax, rpClass.hpRate
	ret
getHP endp

setHp PROC, amountHP:DWORD, madeOfHP:BYTE
	mov eax, rpClass.hpRate

	.IF madeOfHP == 0
		add eax, amountHP
	.ELSE
		sub eax, amountHP
	.ENDIF

	mov rpClass.hpRate, eax
	ret
setHp endp

getMana PROC
	mov eax, rpClass.manaRate
	ret
getMana endp

setMana PROC, amountMana:DWORD, madeOfMana:BYTE
	mov eax, rpClass.manaRate

	.IF madeOfMana == 0
		add eax, amountMana
	.ELSE
		sub eax, amountMana
	.ENDIF

	mov rpClass.manaRate, eax
	ret
setMana endp

getStrength PROC
	movzx eax, rpClass.strengthRate
	ret
getStrength endp

getDex PROC
	movzx eax, rpClass.dexRate
	ret
getDex endp

getInt PROC
	movzx eax, rpClass.intRate
	ret
getInt endp

getWis PROC
	movzx eax, rpClass.wisRate
	ret
getWis endp

getRpClass PROC
	mov eax, rpClass.className
	ret
getRpClass endp

getWeaponName PROC
	mov eax, rpClass.weapon
	ret
getWeaponName endp

getWeaponNum PROC
	movzx eax, rpClass.weaponNum
	ret
getWeaponNum endp

getArmorName PROC
	mov eax, rpClass.armor
	ret
getArmorName endp

getArmorNum PROC
	movzx eax, rpClass.armorNum
	ret
getArmorNum endp

getSpellName PROC
	mov eax, rpClass.spell
	ret
getSpellName endp

getSpellNum PROC
	movzx eax, rpClass.spellNum
	ret
getSpellNum endp


getDamage PROC, damageNum:WORD
	movzx eax, damageNum
	; for damageNums we want to subract the 100s place of the number
	; this is used to determine the type of damage
	.IF eax > 499
		sub eax, 500
	.ELSEIF eax > 399
		sub eax, 400
	.ELSEIF eax > 299
		sub eax, 300
	.ELSEIF eax > 199
		sub eax, 200
	.ELSE 
		sub eax, 100
	.ENDIF
	ret
getDamage endp
	
getType PROC, damageNumber:WORD
	movzx eax, damageNumber
	; same thing as the getDamage PROC however this one gets the ID
	; of the type of damage rather than the number
	.IF eax > 499
		mov eax, 5
	.ELSEIF eax > 399
		mov eax, 4
	.ELSEIF eax > 299
		mov eax, 3
	.ELSEIF eax > 199
		mov eax, 2
	.ELSE 
		mov eax, 1
	.ENDIF
	ret
getType endp

equipItemFromBP PROC, slot:BYTE
	pushad

	movzx esi, slot

	; moves the id of the item we are wanting to equip to eax
	; this is used to determine what equipment slot we are 
	; going to use
	movzx eax, [rpClass.backPackID + esi]

	.IF eax == 1 ; weapon
		; useing "arrays" we swap each of the values from our equipped slot to our
		; backpack slot
		; this concept is used for each of the following IF blocks
		mov eax, [rpClass.backPack + 4*esi]
		XCHG rpClass.weapon, eax
		mov [rpClass.backPack + 4*esi], eax

		mov ax, [rpClass.backPackNum + 2*esi]
		XCHG rpClass.weaponNum, ax
		mov [rpClass.backPackNum + 2*esi], ax

		mov al, [rpClass.backPackID + esi]
		XCHG rpClass.weaponID, al
		mov [rpClass.backPackID + esi], al

	.ELSEIF eax == 2 ; armor
		mov eax, [rpClass.backPack + 4*esi]
		XCHG rpClass.armor, eax
		mov [rpClass.backPack + 4*esi], eax

		mov ax, [rpClass.backPackNum + 2*esi]
		XCHG rpClass.armorNum, ax
		mov [rpClass.backPackNum + 2*esi], ax

		mov al, [rpClass.backPackID + esi]
		XCHG rpClass.armorID, al
		mov [rpClass.backPackID + esi], al

	.ELSE ; spell
		mov eax, [rpClass.backPack + 4*esi]
		XCHG rpClass.spell, eax
		mov [rpClass.backPack + 4*esi], eax

		mov ax, [rpClass.backPackNum + 2*esi]
		XCHG rpClass.spellNum, ax
		mov [rpClass.backPackNum + 2*esi], ax

		mov al, [rpClass.backPackID + esi]
		XCHG rpClass.spellID, al
		mov [rpClass.backPackID + esi], al

	.ENDIF

	popad
	ret
equipItemFromBP endp

addItemToBP PROC, itemName:DWORD, itemNum:WORD, itemID:BYTE
	pushad

	movzx esi, bpIndex

	; simple copys in the item to an empty slot as long as
	; our bpIndex is below 5 meaning our backpack still has empty slots
	.IF bpIndex < 5
		mov eax, itemName
		mov [rpClass.backPack + esi*4], eax

		mov ax, itemNum
		mov [rpClass.backPackNum + esi*2], ax

		mov al, itemID
		mov [rpClass.backPackID + esi], al
	.ELSE
		; prints out the backpack is full message
		INVOKE printText, 23
		call crlf

		; prints out the backPack
		call printBP
		call crlf

		; reads in the players input
		; 1-5 means we will copy over that item in the slot ID
		; 0 means we simple discard the current item that we collected
		call readInput

		mov esi, eax

		dec esi

		.IF eax != 0
			mov eax, itemName
			mov [rpClass.backPack + esi*4], eax

			mov ax, itemNum
			mov [rpClass.backPackNum + esi*2], ax

			mov al, itemID
			mov [rpClass.backPackID + esi], al
		.ENDIF

		call crlf
	.ENDIF

	inc bpIndex

	popad
	ret
addItemToBP endp

printBP PROC
	pushad

	INVOKE printText, 12 ; backpack

	mov ecx, 4
	mov esi, 0

	; loops through our rpClass.backPack "array"
	; and prints out each item
	L1:
		mov edx, [rpClass.backPack + esi*4]
		call WriteString
		INVOKE printText, 13 ; ,
		INVOKE printText, 0 ; " "
		inc esi
	loop L1

	; prints out slot 5 of our bp that gets skipped in the loop
	mov edx, [rpClass.backPack + esi*4]
	call WriteString

	popad
	ret
printBP endp

END