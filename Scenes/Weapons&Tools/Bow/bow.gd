extends TextureRect



func _ready():
	if SceneManager.arrows == 0:
		%BlessedArrow.visible = false
		%Arrow.visible = false
	else:
		if EquipmentManager.has_holy_arrow == true:
			%BlessedArrow.visible = true
			%Arrow.visible = false
		else:
			%Arrow.visible = true



func _process(_delta):
	if SceneManager.arrows == 0:
		%BlessedArrow.visible = false
		%Arrow.visible = false
	else:
		if EquipmentManager.has_holy_arrow == true:
			%BlessedArrow.visible = true
			%Arrow.visible = false
		else:
			%Arrow.visible = true
