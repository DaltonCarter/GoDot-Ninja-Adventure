extends Area2D

func _process(delta):
	await get_tree().create_timer(6.0).timeout
	$AnimationPlayer.play("vanishing")
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _on_area_2d_body_entered(body):
	if body is Player:
		$Timer.start()
		$Sprite2D.visible = false
		$AudioStreamPlayer.playing = true
		if SceneManager.arrows + 5 >= SceneManager.max_arrows:
			SceneManager.arrows = SceneManager.max_arrows
		else:
			SceneManager.arrows += 5
		



func _on_timer_timeout():
	queue_free()
