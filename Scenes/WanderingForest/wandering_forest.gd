extends Node2D

signal puzzle_solved
signal puzzle_reset




# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.last_directions_traveled.clear()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	puzzle_solution_check()
	#print(SceneManager.last_directions_traveled)

	


func puzzle_solution_check():
	if SceneManager.last_directions_traveled == ['north', 'west', 'south', 'west']:
		puzzle_solved.emit()
		#print('solved')
	else:
		puzzle_reset.emit()
	
