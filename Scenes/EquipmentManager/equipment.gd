extends TextureRect


var wooden_sword: PackedScene = preload("res://Scenes/Weapons&Tools/swords/wooden_sword.tscn")




func equip_wooden_sword_to_X ():
	var sword = wooden_sword.instantiate()
	add_child(sword)
	


func equip_wooden_sword_to_Z ():
	var sword = wooden_sword.instantiate()
	add_child(sword)
	
