extends Area2D


func _on_area_2d_body_entered(body):
	if body is Player:
		$Timer.start()
		$Sprite2D.visible = false
		$AudioStreamPlayer.playing = true
		SceneManager.keys += 1
		
		


func _on_timer_timeout():
	queue_free()
