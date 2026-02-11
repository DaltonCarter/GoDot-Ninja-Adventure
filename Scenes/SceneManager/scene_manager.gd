extends Node2D

var player_spawn_position: Vector2 
var player_direction: Vector2
var last_directions_traveled: Array[String]
var opened_chests: Array[String] = []

var player_hp: int = 12
var player_life_containers: int = 3
var player_max_hp: int = 12



var wallet: int = 0
var keys: int = 0
var arrows: int = 0
var bombs: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
