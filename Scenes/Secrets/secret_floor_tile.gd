extends StaticBody2D


func _on_puzzle_button_pressed():
	$AudioStreamPlayer.playing = true
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)


func _on_puzzle_button_unpressed():
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
