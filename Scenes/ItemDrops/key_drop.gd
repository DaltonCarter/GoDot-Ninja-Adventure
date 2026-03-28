extends Area2D


func _on_area_2d_body_entered(body):
	if body is Player:
		$Timer.start()
		$Sprite2D.visible = false
		$AudioStreamPlayer.playing = true
		if SceneManager.keys + 1 >= SceneManager.max_keys:
			SceneManager.keys = SceneManager.max_keys
		else:
			SceneManager.keys += 1
		
		


func _on_timer_timeout():
	queue_free()
