extends Area2D


func _on_area_2d_body_entered(body):
	if body is Player:
		$Timer.start()
		$AnimatedSprite2D.visible = false
		$AudioStreamPlayer.playing = true
		SceneManager.wallet += 5
		


func _on_timer_timeout():
	queue_free()
