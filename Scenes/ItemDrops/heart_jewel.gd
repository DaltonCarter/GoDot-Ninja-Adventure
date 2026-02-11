extends Area2D

class_name Heart_Jewel

func _on_area_2d_body_entered(body):
	if body is Player:
		queue_free()
