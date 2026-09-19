extends TextureRect

@onready var currently_equipped_to_x: TextureRect = %"Currently Equipped to X"
@onready var currently_equipped_to_z: TextureRect = %"Currently Equipped to Z"

func update_hud_slot(slot_name: String, item_id: String) -> void:
	var target_rect: TextureRect = currently_equipped_to_x if slot_name == "X" else currently_equipped_to_z
	
	if item_id == "":
		target_rect.texture = null
		target_rect.visible = false
		return
		
	var new_texture = EquipmentManager.get_equipment_texture(item_id)
	
	if new_texture:
		target_rect.texture = new_texture
		target_rect.visible = true
		
		target_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	else:
		push_error("HUD Error: Unknown or unmapped equipment item_id: " + item_id)
		target_rect.texture = null
		target_rect.visible = false
