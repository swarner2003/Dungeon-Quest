INCLUDE Irvine32.inc

addItemToBP PROTO, itemName:DWORD, itemNum:WORD, itemID:BYTE
setValOnMap PROTO, xCord:BYTE, yCord:BYTE, val:BYTE
callTwo PROTO, tempOne:DWORD, tempTwo:DWORD
convertXYtoMAP PROTO, xVal:BYTE, yVal:BYTE
setHp PROTO, amountHp:DWORD, madeOfHP:BYTE
setMana PROTO, amountMana:DWORD, madeOfMana:BYTE
getValOnMap PROTO, xCord:BYTE, yCord:BYTE
printSquare PROTO, typeOfSquare:DWORD
printText PROTO, textID:WORD
loadClass PROTO, classID:DWORD
equipItemFromBP PROTO, slot:BYTE
twoEvent PROTO, eventID:WORD
combatEvent PROTO, enemyID:BYTE
getDamage PROTO, damageNum:WORD
getType PROTO, damageNumber:WORD
playerMove PROTO
readInput PROTO
loadMap PROTO
printMap PROTO
getHP PROTO
getMana PROTO
getStrength PROTO
getDex PROTO
getInt PROTO
getWis PROTO
getWeaponName PROTO
getWeaponNum PROTO
getArmorName PROTO
getArmorNum PROTO
getSpellName PROTO
getSpellNum PROTO
printClass PROTO
getRpClass PROTO
printBP PROTO
backPackMenu PROTO
roll20 PROTO