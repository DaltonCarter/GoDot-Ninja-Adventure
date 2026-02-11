extends Area2D

@export var player_transfer_position: Vector2

#All of the following variables are for puzzle handling ONLY
@export var is_puzzle_transfer: bool = false
@export var clear_puzzle_array_on_transfer: bool = false
@export var transfer_direction: String

var puzzle_solved: bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player and !is_puzzle_transfer:
		body.global_position = player_transfer_position
		
	elif body is Player and is_puzzle_transfer:
		
			
		if !puzzle_solved:
			if SceneManager.last_directions_traveled.size() == 4:
				SceneManager.last_directions_traveled.clear()
				SceneManager.last_directions_traveled.append(transfer_direction)
				body.global_position = player_transfer_position
			else:
				SceneManager.last_directions_traveled.append(transfer_direction)
				body.global_position = player_transfer_position
				
		else:
			$"Music Effect".playing = true

	if clear_puzzle_array_on_transfer:
		SceneManager.last_directions_traveled.clear()



func _on_wandering_hills_puzzle_solved():
	puzzle_solved = true


func _on_wandering_hills_puzzle_reset():
	puzzle_solved = false


func _on_wandering_forest_puzzle_solved():
	puzzle_solved = true


func _on_wandering_forest_puzzle_reset():
	puzzle_solved = false
