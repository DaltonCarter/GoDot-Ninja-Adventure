extends Node2D

var player_spawn_position: Vector2 
var player_direction: Vector2
var last_directions_traveled: Array[String]
var opened_chests: Array[String] = []
var found_secrets: Array[int] = []


var player_hp: int = 12
var player_life_containers: int = 3
var player_max_hp: int = 12
var player_damage: int = 1
var player_defense: float = 1.0
var is_knocked_back: bool = false

var enemy_drops: Array[String] = ["health", "health","health", "1xal", "1xal", "5xal", "bombs", "arrows", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing"]

const blue_armor = preload("res://Ninja Adventure - Asset Pack/Actor/Characters/RoninBlue/blue_palette.png")
const red_armor = preload("res://Ninja Adventure - Asset Pack/Actor/Characters/RoninRed/red_palette.png")

const LifeDrop: PackedScene = preload("res://Scenes/ItemDrops/life_drop.tscn")
const MoneyDrop1: PackedScene = preload("res://Scenes/ItemDrops/xal_coin.tscn")
const MoneyDrop2: PackedScene = preload("res://Scenes/ItemDrops/xal_coin_5.tscn")
const BombDrop: PackedScene = preload("res://Scenes/ItemDrops/bomb_drop.tscn")
const ArrowDrop: PackedScene = preload("res://Scenes/ItemDrops/arrow_drop.tscn")
const KeyDrop: PackedScene = preload("res://Scenes/ItemDrops/key_drop.tscn")

var wallet: int = 0
var max_wallet: int = 999
var keys: int = 0
var max_keys: int = 10
var arrows: int = 0
var max_arrows: int = 30
var bombs: int = 0
var max_bombs: int = 12
