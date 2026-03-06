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
		"money1":
			SceneManager.wallet += 1
			print(SceneManager.wallet)
		"money5":
			SceneManager.wallet += 5
			print(SceneManager.wallet)
		"key":
			SceneManager.keys += 1
			print(SceneManager.keys)
		"bombs":
			SceneManager.bombs += 4
			print(SceneManager.bombs)
		"arrows5":
			SceneManager.arrows += 5
			print(SceneManager.arrows)
		"arrows10":
			SceneManager.arrows += 10
			print(SceneManager.arrows)
