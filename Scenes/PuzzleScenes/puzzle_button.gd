extends Area2D

var bodies_on_top: int = 0
signal pressed
signal unpressed

@export var is_single_use: bool = false


func _on_body_entered(body):
	if body.is_in_group("pushable"):
		bodies_on_top += 1
		if bodies_on_top == 1:
			pressed.emit()
			$AnimatedSprite2D.play("pressed")
			print("I have been pressed!")
			$AudioStreamPlayer.playing = true


func _on_body_exited(body):
	if is_single_use:
		return

	if body.is_in_group("pushable"):
		bodies_on_top -= 1
		if bodies_on_top == 0:
			unpressed.emit()
			$AnimatedSprite2D.play("unpressed")
			print("I am no longer pushed!")
			$AudioStreamPlayer.playing = true
