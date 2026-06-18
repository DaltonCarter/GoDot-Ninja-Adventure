extends Node

var has_holy_arrow: bool = false
var has_sword: bool = false

var currently_equipped_to_X: String = ""
var currently_equipped_to_Z: String = ""



var obtained_equipment: Array[String] = []


#Equipment Preloads:
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
