extends Area2D


signal block_in_area
signal block_out_of_area


func _on_body_entered(body):
	if body.is_in_group("pushable"):
		#print("WTF")
		block_in_area.emit()


func _on_body_exited(body):
	if body.is_in_group("pushable"):
		#print("HELLO!?")
		block_out_of_area.emit()
