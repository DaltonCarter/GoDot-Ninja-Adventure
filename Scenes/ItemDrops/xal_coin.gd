extends Area2D


func _process(delta):
	await get_tree().create_timer(6.0).timeout
	var vanish: Color = Color(1, 1, 1, .5)
	modulate = vanish
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _on_area_2d_body_entered(body):
	if body is Player:
		$Timer.start()
		$AnimatedSprite2D.visible = false
		$AudioStreamPlayer.playing = true
		SceneManager.wallet += 1
		



func _on_timer_timeout():
	queue_free()
