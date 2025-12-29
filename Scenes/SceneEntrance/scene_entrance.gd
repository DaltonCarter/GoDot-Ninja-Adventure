extends Area2D

@export var next_scene: String
@export var player_spawn_position: Vector2
@export var player_direction: Vector2

func _on_body_entered(body):
	if body is Player:
		SceneManager.player_spawn_position = player_spawn_position
		SceneManager.player_direction = player_direction
	
		
		get_tree().change_scene_to_file.call_deferred(next_scene)
		
	
