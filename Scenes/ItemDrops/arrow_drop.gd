extends Area2D


func _on_area_2d_body_entered(body):
	if body is Player:
		SceneManager.arrows += 5
		print(SceneManager.arrows)
		queue_free()
