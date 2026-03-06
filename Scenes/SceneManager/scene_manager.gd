extends Node2D

var player_spawn_position: Vector2 
var player_direction: Vector2
var last_directions_traveled: Array[String]
var opened_chests: Array[String] = []

var player_hp: int = 12
var player_life_containers: int = 3
var player_max_hp: int = 12
var player_damage: int = 1

var enemy_drops: Array[String] = ["health", "1xal", "5xal", "bombs", "arrows", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing", "nothing"]

const LifeDrop: PackedScene = preload("res://Scenes/ItemDrops/life_drop.tscn")
const MoneyDrop1: PackedScene = preload("res://Scenes/ItemDrops/xal_coin.tscn")
const MoneyDrop2: PackedScene = preload("res://Scenes/ItemDrops/xal_coin_5.tscn")
const BombDrop: PackedScene = preload("res://Scenes/ItemDrops/bomb_drop.tscn")
const ArrowDrop: PackedScene = preload("res://Scenes/ItemDrops/arrow_drop.tscn")
const KeyDrop: PackedScene = preload("res://Scenes/ItemDrops/key_drop.tscn")

var wallet: int = 0
var keys: int = 0
var arrows: int = 0
var bombs: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
