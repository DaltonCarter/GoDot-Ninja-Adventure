extends Area2D


func _on_area_2d_body_entered(body):
	if body is Player:
		SceneManager.bombs += 3
		print(SceneManager.bombs)
		queue_free()
