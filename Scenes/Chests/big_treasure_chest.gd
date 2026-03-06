extends StaticBody2D
var can_interact: bool = false
var is_open: bool = false

@export var chest_name: String
@export var contents_path: String = "res://Ninja Adventure - Asset Pack/Items/Scroll/Scroll.png"
@export var contents: String = ""

func _ready():
	if SceneManager.opened_chests.has(chest_name):
		is_open = true
		$AnimatedSprite2D.set_animation("open")

func _process(delta):
	if Input.is_action_just_pressed("interact") and can_interact:
		if !is_open:
			$SFX.playing = true
			set_texture_2d()
			open_chest()
			give_contents_to_player()

func open_chest():
	is_open = true
	$AnimatedSprite2D.set_animation("open")
	$Sprite2D.visible = true
	$ME.playing = true
	$Timer.start()
	SceneManager.opened_chests.append(chest_name)
	get_tree().paused = true
	
	
	


func _on_timer_timeout():
	$Sprite2D.visible = false
	get_tree().paused = false

func set_texture_2d():
	var texture_path = ResourceLoader.load(contents_path)
	$Sprite2D.texture = texture_path

func give_contents_to_player():
	match contents:
		"bow":
			print("you found a bow!")
		"wand":
			print("you found a magic wand!")
		"map":
			print("you found the dungeon map!")
		"compass":
			print("you found the dungeon compass!")
		"pinion":
			print("you found the garuda pinion!")
		"lantern":
			print("you found the magic lantern!")
		"flute":
			print("you found the spirit flute!")
		"scroll":
			print("you found the wizards scroll!")
		"power":
			print("you found the power ring!")
		"red":
			print("you found the red ring!")
		"skey":
			print("you found the skeleton key!")
		"mkey":
			print("you found the magic key!")
		"boomerang":
			print("you found the boomerang!")
		"mboomerang":
			print("you found the magic boomerang!")
