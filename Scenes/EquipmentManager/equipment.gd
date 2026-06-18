extends TextureRect


var wooden_sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/wooden_sword.tscn")
var sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/sword.tscn")
var magic_sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/magic_sword.tscn")
var tempered_sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/tempered_sword.tscn")
var blessed_sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/blessed_sword.tscn")

var boomerang: PackedScene = preload("res://Scenes/Weapons&Tools/Boomerang/boomerang.tscn")
var magic_boomerang: PackedScene = preload("res://Scenes/Weapons&Tools/Boomerang/magic_boomerang.tscn")

var lantern: PackedScene = preload("res://Scenes/Weapons&Tools/Lantern/lantern.tscn")
var magic_lantern: PackedScene = preload("res://Scenes/Weapons&Tools/Lantern/magic_lantern.tscn")

var bombs: PackedScene = preload("res://Scenes/Weapons&Tools/Bomb/bomb.tscn")
var bow: PackedScene = preload("res://Scenes/Weapons&Tools/Bow/bow.tscn")


var magic_wand: PackedScene = preload("res://Scenes/Weapons&Tools/MagicWand/magic_wand.tscn")
var wizard_wand: PackedScene = preload("res://Scenes/Weapons&Tools/MagicWand/mage_wand.tscn")

var meat: PackedScene = preload("res://Scenes/Weapons&Tools/KeyItems/meat.tscn")
var flute: PackedScene = preload("res://Scenes/Weapons&Tools/Flute/spirit_flute.tscn")

var red_potion: PackedScene = preload("res://Scenes/Weapons&Tools/Potions/red_potion.tscn")
var blue_potion: PackedScene = preload("res://Scenes/Weapons&Tools/Potions/blue_potion.tscn")

var pinion: PackedScene = preload("res://Scenes/Weapons&Tools/GarudaPinion/garuda_pinion.tscn")


func remove_equip_from_X():
	for child in get_children():
		child.queue_free()

func remove_equip_from_Z():
	for child in get_children():
		child.queue_free()

#Handle Sword Equip:
func equip_wooden_sword_to_X ():
	var equipped_sword = wooden_sword.instantiate()
	add_child(equipped_sword)	

func equip_wooden_sword_to_Z ():
	var equipped_sword = wooden_sword.instantiate()
	add_child(equipped_sword)

func equip_sword_to_X ():
	var equipped_sword = sword.instantiate()
	add_child(equipped_sword)

func equip_sword_to_Z ():
	var equipped_sword = sword.instantiate()
	add_child(equipped_sword)

func equip_magic_sword_to_X ():
	var equipped_sword = magic_sword.instantiate()
	add_child(equipped_sword)

func equip_magic_sword_to_Z ():
	var equipped_sword = magic_sword.instantiate()
	add_child(equipped_sword)

func equip_tempered_sword_to_X ():
	var equipped_sword = tempered_sword.instantiate()
	add_child(equipped_sword)

func equip_tempered_sword_to_Z ():
	var equipped_sword = tempered_sword.instantiate()
	add_child(equipped_sword)

func equip_blessed_sword_to_X ():
	var equipped_sword = blessed_sword.instantiate()
	add_child(equipped_sword)

func equip_blessed_sword_to_Z ():
	var equipped_sword = blessed_sword.instantiate()
	add_child(equipped_sword)

#Handle Bow Equip:
func equip_bow_to_X ():
	var equip_bow = bow.instantiate()
	add_child(equip_bow)

func equip_bow_to_Z ():
	var equip_bow = bow.instantiate()
	add_child(equip_bow)

#Handle Boomerang Equip:
func equip_boomerang_to_X ():
	var equip_boomerang = boomerang.instantiate()
	add_child(equip_boomerang)

func equip_boomerang_to_Z ():
	var equip_boomerang = boomerang.instantiate()
	add_child(equip_boomerang)

func equip_magic_boomerang_to_X ():
	var equip_magic_boomerang = magic_boomerang.instantiate()
	add_child(equip_magic_boomerang)

func equip_magic_boomerang_to_Z ():
	var equip_magic_boomerang = magic_boomerang.instantiate()
	add_child(equip_magic_boomerang)

#Handle Bombs Equip:
func equip_bombs_to_X ():
	var equip_bombs = bombs.instantiate()
	add_child(equip_bombs)

func equip_bombs_to_Z ():
	var equip_bombs = bombs.instantiate()
	add_child(equip_bombs)

#Handle Lantern Equip:
func equip_lantern_to_X ():
	var equip_lantern = lantern.instantiate()
	add_child(equip_lantern)

func equip_lantern_to_Z ():
	var equip_lantern = lantern.instantiate()
	add_child(equip_lantern)

func equip_magic_lantern_to_X ():
	var equip_magic_lantern = magic_lantern.instantiate()
	add_child(equip_magic_lantern)

func equip_magic_lantern_to_Z ():
	var equip_magic_lantern = magic_lantern.instantiate()
	add_child(equip_magic_lantern)

#Handle Spirit Flute Equip:
func equip_spirit_flute_to_X ():
	var equip_flute = flute.instantiate()
	add_child(equip_flute)

func equip_spirit_flute_to_Z ():
	var equip_flute = flute.instantiate()
	add_child(equip_flute)

#Handle Wand Equip:
func equip_magic_wand_to_X ():
	var equip_wand = magic_wand.instantiate()
	add_child(equip_wand)

func equip_magic_wand_to_Z ():
	var equip_wand = magic_wand.instantiate()
	add_child(equip_wand)

func equip_wizard_wand_to_X ():
	var equip_wizard_wand = wizard_wand.instantiate()
	add_child(equip_wizard_wand)

func equip_wizard_wand_to_Z ():
	var equip_wizard_wand = wizard_wand.instantiate()
	add_child(equip_wizard_wand)

#Handle Meat Equip:
func equip_meat_to_X ():
	var equip_meat = meat.instantiate()
	add_child(equip_meat)

func equip_meat_to_Z ():
	var equip_meat = meat.instantiate()
	add_child(equip_meat)

#Handle Garuda Pinion Equip:
func equip_garuda_pinion_to_X ():
	var equip_pinion = pinion.instantiate()
	add_child(equip_pinion)

func equip_garuda_pinion_to_Z ():
	var equip_pinion = pinion.instantiate()
	add_child(equip_pinion)

#Handle Potion Equip:
func equip_red_potion_to_X ():
	var equip_red_potion = red_potion.instantiate()
	add_child(equip_red_potion)

func equip_red_potion_to_Z ():
	var equip_red_potion = red_potion.instantiate()
	add_child(equip_red_potion)

func equip_blue_potion_to_X ():
	var equip_blue_potion = blue_potion.instantiate()
	add_child(equip_blue_potion)

func equip_blue_potion_to_Z ():
	var equip_blue_potion = blue_potion.instantiate()
	add_child(equip_blue_potion)
