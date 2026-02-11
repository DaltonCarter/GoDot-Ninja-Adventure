extends Area2D

class_name Health_Drop



func _on_area_2d_body_entered(body):
	if body is Player:
		queue_free()
		
