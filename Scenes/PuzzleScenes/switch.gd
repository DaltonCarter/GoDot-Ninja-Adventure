extends StaticBody2D

signal switch_activated
signal switch_deactivated

var can_interact: bool = false
var is_activated: bool = false


func _process(delta):
	if Input.is_action_just_pressed("interact") and can_interact:
		if is_activated:
			deactivate_switch()
		else:
			activate_switch()
			

func activate_switch():
	$SFX.playing = true
	$AnimatedSprite2D.play("Activated")
	switch_activated.emit()
	is_activated = true


func deactivate_switch():
	$SFX.playing = true
	$AnimatedSprite2D.play("Deactivated")
	switch_deactivated.emit()
	is_activated = false
