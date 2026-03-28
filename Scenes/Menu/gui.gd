class_name Menu extends Control

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var in_menu: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("open_menu"):
		toggle_menu()

func toggle_menu():
	in_menu = !in_menu
	if in_menu:
		_animation_player.play("menu_open")
	else:
		_animation_player.play("menu_close")
