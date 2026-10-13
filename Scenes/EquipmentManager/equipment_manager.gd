extends Node

var has_magic_arrow: bool = false
var has_sword: bool = false

var currently_equipped_to_X: String = ""
var currently_equipped_to_Z: String = ""


var obtained_equipment: Array[String] = []

#warning_ignore("unused_private_class_variable") (or function) (or signal)
signal refresh_sword_and_armor

#Equipment Texture Preloads:
var sword_1 = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/WoodenKatana/Sprite.png")
var sword_2 = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/Katana/Sprite.png")
var sword_3 = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/MagicKatana/Sprite.png")
var sword_4 = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/TemperedKatana/Sprite.png")
var sword_5 = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/LegendaryKatana/Sprite.png")

var bow = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/Bow/Bow.png")
var bowandarrow = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/Bow/Bow and Arrow.png")
var bowandmarrow = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/Bow/Bow and Magic Arrow.png")

var boomerang = preload("res://Ninja Adventure - Asset Pack/Items/Projectile/Boomerang.png")
var magic_boomerang = preload("res://Ninja Adventure - Asset Pack/Items/Projectile/MagicBoomerang.png")

var bombs = preload("res://Ninja Adventure - Asset Pack/Items/Projectile/BlueBomb.png")
var meat = preload("res://Ninja Adventure - Asset Pack/Items/Food/Meat.png")
var flute = preload("res://Ninja Adventure - Asset Pack/Items/Object/PanFlute.png")
var pinion = preload("res://Ninja Adventure - Asset Pack/Items/Resource/feather.png")

var lantern = preload("res://Ninja Adventure - Asset Pack/Items/Tool/Lantern.png")
var magic_lantern = preload("res://Ninja Adventure - Asset Pack/Items/Tool/MagicLantern.png")

var red_potion = preload("res://Ninja Adventure - Asset Pack/Items/Potion/RedPotion.png")
var blue_potion = preload("res://Ninja Adventure - Asset Pack/Items/Potion/BluePotion.png")

var magic_wand = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/MagicWand/Sprite.png")
var wizard_wand = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/MagicWand/Sprite2.png")


#Key Item Preloads:
var letter = preload("res://Ninja Adventure - Asset Pack/Items/Other/Letter.png")
var bomb_satchel = preload("res://Ninja Adventure - Asset Pack/Items/Object/Bag.png")

var water_shoes = preload("res://Ninja Adventure - Asset Pack/Items/Other/Water Shoes.png")

var blue_ring = preload("res://Ninja Adventure - Asset Pack/Items/Other/BlueRing.png")
var red_ring = preload("res://Ninja Adventure - Asset Pack/Items/Other/RedRing.png")

var power_ring = preload("res://Ninja Adventure - Asset Pack/Items/Other/PowerRing.png")

var master_key1 = preload("res://Ninja Adventure - Asset Pack/Items/Treasure/GoldKey.png")
var master_key2 = preload("res://Ninja Adventure - Asset Pack/Items/Treasure/MagicKey.png")


#Sacred Relic Preloads:
var chalice = preload("res://Ninja Adventure - Asset Pack/Items/Treasure/GoldCup.png")
var gold_disk = preload("res://Ninja Adventure - Asset Pack/Items/Treasure/GoldCoin.png")
var sacred_gourd = preload("res://Ninja Adventure - Asset Pack/Items/Object/Gourd.png")
var hourglass = preload("res://Ninja Adventure - Asset Pack/Items/Object/Hourglass.png")
var dagger = preload("res://Ninja Adventure - Asset Pack/Items/Weapons/Sword/Sprite.png")
var scroll = preload("res://Ninja Adventure - Asset Pack/Items/Scroll/Scroll.png")
var sacred_seed = preload("res://Ninja Adventure - Asset Pack/Items/Food/SeedLargeWhite.png")
var water = preload("res://Ninja Adventure - Asset Pack/Items/Potion/WaterPot.png")


#Essence and Alloy Preloads:
var adamantine = preload("res://Ninja Adventure - Asset Pack/Items/Resource/BarPurple.png")
var gold = preload("res://Ninja Adventure - Asset Pack/Items/Resource/BarGold.png")
var silver = preload("res://Ninja Adventure - Asset Pack/Items/Resource/BarSilver.png")
var mithril = preload("res://Ninja Adventure - Asset Pack/Items/Resource/BarMithril.png")
var emerald = preload("res://Ninja Adventure - Asset Pack/Items/Resource/GemGreen.png")
var amethyst = preload("res://Ninja Adventure - Asset Pack/Items/Resource/GemPurple.png")
var ruby = preload("res://Ninja Adventure - Asset Pack/Items/Resource/GemRed.png")
var topaz = preload("res://Ninja Adventure - Asset Pack/Items/Resource/GemYellow.png")

#Equipment Scene Preloads:
var wooden_sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/wooden_sword.tscn")
var sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/sword.tscn")
var magic_sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/magic_sword.tscn")
var tempered_sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/tempered_sword.tscn")
var blessed_sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/blessed_sword.tscn")

var boomerang_scn: PackedScene = preload("res://Scenes/Weapons&Tools/Boomerang/boomerang.tscn")
#var magic_boomerang_scn: PackedScene = preload("res://Scenes/Weapons&Tools/Boomerang/magic_boomerang.tscn")

var lantern_scn: PackedScene = preload("res://Scenes/Weapons&Tools/Lantern/lantern.tscn")
var magic_lantern_scn: PackedScene = preload("res://Scenes/Weapons&Tools/Lantern/magic_lantern.tscn")

var bombs_scn: PackedScene = preload("res://Scenes/Weapons&Tools/Bomb/bomb.tscn")
var bow_scn: PackedScene = preload("res://Scenes/Weapons&Tools/Bow/bow.tscn")

var magic_wand_scn: PackedScene = preload("res://Scenes/Weapons&Tools/MagicWand/magic_wand.tscn")
var wizard_wand_scn: PackedScene = preload("res://Scenes/Weapons&Tools/MagicWand/mage_wand.tscn")

var meat_scn: PackedScene = preload("res://Scenes/Weapons&Tools/KeyItems/meat.tscn")
var flute_scn: PackedScene = preload("res://Scenes/Weapons&Tools/Flute/spirit_flute.tscn")

var red_potion_scn: PackedScene = preload("res://Scenes/Weapons&Tools/Potions/red_potion.tscn")
var blue_potion_scn: PackedScene = preload("res://Scenes/Weapons&Tools/Potions/blue_potion.tscn")

var pinion_scn: PackedScene = preload("res://Scenes/Weapons&Tools/GarudaPinion/garuda_pinion.tscn")

#Dictionary:
@onready var EQUIPMENT: Dictionary = {
	"WoodenSword": {
		"texture": sword_1,
		"scene": wooden_sword 
	},
	"Sword": {
		"texture": sword_2,
		"scene": sword 
	},
	"MagicSword": {
		"texture": sword_3,
		"scene": magic_sword 
	},
	"TemperedSword": {
		"texture": sword_4,
		"scene": tempered_sword 
	},
	"BlessedSword": {
		"texture": sword_5,
		"scene": blessed_sword 
	},
	"Bow": {
		"empty": bow,
		"normal": bowandarrow,
		"magic": bowandmarrow,
		"scene": bow_scn 
	},
	"Boomerang": {
		"texture": boomerang,
		"scene": boomerang_scn 
	},
	"MagicBoomerang": {
		"texture": magic_boomerang,
		"scene": boomerang_scn 
	},
	"Bombs": {
		"texture": bombs,
		"scene": bombs_scn 
	},
	"Meat":{
		"texture": meat,
		"scene": meat_scn 
	},
	"SpiritFlute": {
		"texture": flute,
		"scene": flute_scn 
	},
	"GarudaPinion": {
		"texture": pinion,
		"scene": pinion_scn 
	},
	"Lantern": {
		"texture": lantern,
		"scene": lantern_scn 
	},
	"MagicLantern": {
		"texture": magic_lantern,
		"scene": magic_lantern_scn 
	},
	"RedPotion": {
		"texture": red_potion,
		"scene": red_potion_scn 
	},
	"BluePotion": {
		"texture": blue_potion,
		"scene": blue_potion_scn 
	},
	"MagicWand": {
		"texture": magic_wand,
		"scene": magic_wand_scn 
	},
	"WizardWand": {
		"texture": wizard_wand,
		"scene": wizard_wand_scn 
	},
	"Letter": {
		"texture": letter,
		"scene": null
	},
	"BombSatchel": {
		"texture": bomb_satchel,
		"scene": null
	},
	"WaterShoes": {
		"texture": water_shoes,
		"scene": null
	},
	"BlueRing": {
		"texture": blue_ring,
		"scene": null
	},
	"RedRing": {
		"texture": red_ring,
		"scene": null
	},
	"PowerRing": {
		"texture": power_ring,
		"scene": null
	},
	"SkeletonKey": {
		"texture": master_key1,
		"scene": null
	},
	"MasterKey": {
		"texture": master_key2,
		"scene": null
	},
}

func get_equipment_texture(item_id: String) -> Texture2D:
	if not EQUIPMENT.has(item_id):
		push_warning("EquipmentManager Warning: Request for unknown Texture ID: " + item_id)
		return null
		
	var item_data = EQUIPMENT[item_id]
	
	if item_id == "Bow":
		if has_magic_arrow and SceneManager.arrows > 0:
			return item_data["magic"]
		elif SceneManager.arrows > 0:
			return item_data["normal"]
		else:
			return item_data["empty"]
			
	if item_data.has("texture"):
		return item_data["texture"]
		
	return null


func get_equipment_scene(item_id: String) -> PackedScene:
	if not EQUIPMENT.has(item_id):
		return null
		
	var item_data = EQUIPMENT[item_id]
	
	if item_data.has("scene"):
		return item_data["scene"]
		
	return null
