extends StaticBody2D



func _on_remove_block_secret_block_in_area():
	#print('block is IN AREA')
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)


func _on_remove_block_secret_block_out_of_area():
	#print('Block is OUT OF AREA')
	if $AudioStreamPlayer.is_inside_tree():
		$AudioStreamPlayer.set_deferred("playing", true)
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
