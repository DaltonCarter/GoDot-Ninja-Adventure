extends StaticBody2D

@export var buttons_needed = 3

var buttons_pressed: int = 0

func _on_puzzle_button_pressed():
	buttons_pressed += 1
	if buttons_pressed >= buttons_needed:
		$AudioStreamPlayer.playing = true
		visible = false
		$CollisionShape2D.set_deferred("disabled", true)


func _on_puzzle_button_unpressed():
	buttons_pressed -= 1
	if buttons_pressed < buttons_needed :
		visible = true
		$CollisionShape2D.set_deferred("disabled", false)


func _on_remove_block_secret_block_in_area():
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)


func _on_remove_block_secret_2_block_out_of_area():
		$AudioStreamPlayer.playing = true
		visible = false
		$CollisionShape2D.set_deferred("disabled", true)
