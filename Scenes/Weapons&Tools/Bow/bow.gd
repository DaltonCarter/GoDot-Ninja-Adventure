extends TextureRect


# Called when the node enters the scene tree for the first time.
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
