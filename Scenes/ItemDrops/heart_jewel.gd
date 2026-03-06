extends Area2D

class_name Heart_Jewel

func _on_area_2d_body_entered(body):
	if body is Player:
		$Timer.start()
		$AudioStreamPlayer.playing = true
		get_tree().paused = true


func _on_timer_timeout():
	get_tree().paused = false
	queue_free()
	
