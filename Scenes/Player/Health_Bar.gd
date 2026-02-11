extends HFlowContainer

@export var heart_scene: PackedScene

var hearts: Array = []


func _ready():
	current_hp()
		

func current_hp():
	for i in range(SceneManager.player_life_containers):
		var heart = heart_scene.instantiate()
	
		add_child(heart)
		hearts.append(heart)


func add_life_container():
	var heart = heart_scene.instantiate()
	add_child(heart)
	hearts.append(heart)


func update_health_ui(current_hp: int):
	for i in range(SceneManager.player_life_containers):
		var heart_range_start = i * 4
		
		var heart_hp = clamp(current_hp - heart_range_start, 0, 4)
		
		hearts[i].get_child(0).get_child(0).frame = 4 - heart_hp

func update_health_ui_for_healing(current_hp: int):
	for i in range(SceneManager.player_life_containers):
		var heart_range_start = i * 4
		
		var heart_hp = clamp(current_hp - heart_range_start, 0, 4)
		
		hearts[i].get_child(0).get_child(0).frame = 4 - heart_hp
