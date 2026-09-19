class_name Menu extends Control

# On Button Focused connection and it's corresponding function are not activly used,
# but remains in the code to aid in bug testing/fixing adn general diagnostics.
#DO NOT DELETE THEM!

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _items: Array = %Equippable.get_children() + %Equippable2.get_children()

@onready var equipment_map: Dictionary = {
		"WoodenSword": %Sword,
		"Sword": %Sword,
		"MagicSword": %Sword,
		"TemperedSword": %Sword,
		"BlessedSword": %Sword,
		"Bow": %Bow,
		"Boomerang": %Boomerang,
		"MagicBoomerang": %Boomerang,
		"Bombs": %Bombs,
		"Lantern": %Lantern,
		"MagicLantern": %Lantern,
		"SpiritFlute": %SpiritFlute,
		"MagicWand": %MagicWand,
		"WizardWand": %MagicWand,
		"Meat": %Meat,
		"GarudaPinion": %GarudaPinion,
		"RedPotion": %Potions,
		"BluePotion": %Potions
	}

signal update_x_key
signal update_z_key

const columns: int = 5
@export var in_menu: bool = false
var item_index: int = 0


func _ready():
	initialize_equipment()
	initialize_key_items()
	

func _process(_delta):
	
	if Input.is_action_just_pressed("open_menu"):
		
		if SceneManager.is_knocked_back:
			return
		else:
			toggle_menu()
			initialize_equipment()
			initialize_key_items()
	
	if not in_menu or Input.is_action_just_pressed("open_menu"):
		return
	
	if not has_selectable_item():
		return
	
	if in_menu:
		if Input.is_action_just_pressed("ui_left"):
			menu_navigation("left")
		
		if Input.is_action_just_pressed("ui_right"):
			menu_navigation("right")
		
		if Input.is_action_just_pressed("ui_up"):
			menu_navigation("up")
		
		if Input.is_action_just_pressed("ui_down"):
			menu_navigation("down")
	
		if Input.is_action_just_pressed("interact"):
			menu_navigation("X")
			
		if Input.is_action_just_pressed("action"):
			menu_navigation("Z")
			
		if Input.is_action_just_pressed("ui_focus_next"):
			menu_navigation("right")
		
		if Input.is_action_pressed("ui_focus_next"):
			menu_navigation("right")

func toggle_menu():
	in_menu = !in_menu
	
	if in_menu:
		Input.flush_buffered_events()
		for action in InputMap.get_actions():
			Input.action_release(action)
		call_deferred("_open_menu")

	else:
		_items[item_index].release_focus()
		_animation_player.play("menu_close")
		item_index = 0
		clear_menu()
		await _animation_player.animation_finished
		refresh_player()
		get_tree().paused = false
		in_menu = false

func _open_menu() -> void:
		#print(_items)
		get_tree().paused = true
		_animation_player.play("menu_open")
		await _animation_player.animation_finished
		find_initial_focus()

func refresh_player() -> void:
	var player = get_parent()
	if player and player.has_method("update_equipment"):
		player.update_equipment()

func has_selectable_item() -> bool:
	for button in _items:
		if button.visible and not button.disabled:
			return true
	return false

func find_initial_focus():
	for i in range(_items.size()):
		if _items[i].visible and not _items[i].disabled:
			item_index = i
			_items[item_index].grab_focus()
			print(item_index)
			break
	
	item_index = 0
	release_focus() 

func menu_navigation(string):
	if in_menu:
		match string:
			"left":
				find_visible_button(-1)
			"right":
				find_visible_button(1)
			"up":
				find_visible_vertical_button(-1)
			"down":
				find_visible_vertical_button(1)
			"X":
				var current_focus = get_viewport().gui_get_focus_owner()
				if current_focus and current_focus in _items:
					item_index = _items.find(current_focus)
					
					if not _items[item_index].disabled:
						on_button_pressed(_items[item_index], "X")
			"Z":
				var current_focus = get_viewport().gui_get_focus_owner()
				if current_focus and current_focus in _items:
					item_index = _items.find(current_focus)
					
					if not _items[item_index].disabled:
						on_button_pressed(_items[item_index], "Z")

func find_visible_button(direction: int) -> void:
	var total_buttons = _items.size()
	var checked_count = 0
	var next_index = item_index
	
	while checked_count < total_buttons:
		next_index += direction
		if next_index >= total_buttons:
			next_index = 0
		elif next_index < 0:
			next_index = total_buttons - 1
		
		checked_count =+ 1
		
		if _items[next_index].visible:
			item_index = next_index
			_items[item_index].grab_focus()
			return

func find_visible_vertical_button(dir_sign: int) -> void:
	var total_buttons = _items.size()
	var target_index = (item_index + (dir_sign * columns))
	
	if target_index < 0:
		target_index = (target_index + total_buttons) % total_buttons
	elif target_index >= total_buttons:
		target_index = target_index % total_buttons
	
	var target_row_start = (target_index / columns) * columns
	
	if _items[target_index].visible:
		item_index = target_index 
		_items[item_index].grab_focus()
		return
	
	for scan_dist in range(1, columns):
		var right_side_check = target_index + scan_dist
		if right_side_check < target_row_start + columns and _items[right_side_check].visible:
			item_index = right_side_check
			_items[item_index].grab_focus()
			return
		
		var left_side_check = target_index - scan_dist
		if left_side_check >= target_row_start and _items[left_side_check].visible:
			item_index = left_side_check
			_items[item_index].grab_focus()
			return

func initialize_equipment():
	for item_id in EquipmentManager.obtained_equipment:
		if equipment_map.has(item_id):
			var button = equipment_map[item_id]
			
			button.disabled = false
			button.visible = true
			
			var item_texture = EquipmentManager.get_equipment_texture(item_id)
			if item_texture:
				button.texture_normal = item_texture

func clear_menu() -> void:
	for button in equipment_map.values():
		button.visible = false
		button.disabled = true

func initialize_key_items():
	var key_item_map: Dictionary = {
		"Letter": %Letter,
		"BombSatchel": %BombSatchel,
		"PowerRing": %RingofStrength,
		"WaterShoes": %WaterShoes,
		"BlueRing": %RingofDefense,
		"RedRing": %RingofDefense,
		"SkeletonKey": %MasterKey,
		"MasterKey": %MasterKey
		
	}
	
	for textureRect in key_item_map.values():
		textureRect.visible = false
		
	
	for item_id in EquipmentManager.obtained_equipment:
		if key_item_map.has(item_id):
			var textureRect = key_item_map[item_id]
			
			textureRect.visible = true
			
			var item_texture = EquipmentManager.get_equipment_texture(item_id)
			if item_texture:
				textureRect.texture = item_texture

func on_button_focused(_button: TextureButton) -> void:
	pass
	#I seemingly don't need this to move the focus around. I will instead leave it as a bug testing and diagnostic function. Might add SFX handling here.

func on_button_pressed(button: TextureButton, target: String) -> void:
	var item_id: String = _get_current_upgrade(button.name)
	
	if "Bow" in item_id:
		item_id = "Bow"
	
	if target == "X":
		if EquipmentManager.currently_equipped_to_X == item_id:
			EquipmentManager.currently_equipped_to_X = ""
		else:
			if EquipmentManager.currently_equipped_to_Z == item_id:
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			
			EquipmentManager.currently_equipped_to_X = item_id
			
		update_x_key.emit()
		
	elif target == "Z":
		if EquipmentManager.currently_equipped_to_Z == item_id:
			EquipmentManager.currently_equipped_to_Z = ""
		else:
			if EquipmentManager.currently_equipped_to_X == item_id:
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			
			EquipmentManager.currently_equipped_to_Z = item_id
			
		update_z_key.emit()

func _get_current_upgrade(button_name: String) -> String:
	if button_name == "Sword":
		for tier in ["BlessedSword", "TemperedSword", "MagicSword", "Sword", "WoodenSword"]:
			if EquipmentManager.obtained_equipment.has(tier):
				return tier
				
	elif button_name == "Boomerang":
		for tier in ["MagicBoomerang", "Boomerang"]:
			if EquipmentManager.obtained_equipment.has(tier):
				return tier
				
	elif button_name == "Lantern":
		for tier in ["MagicLantern", "Lantern"]:
			if EquipmentManager.obtained_equipment.has(tier):
				return tier
	elif button_name == "MagicWand":
		for tier in ["WizardWand", "MagicWand"]:
			if EquipmentManager.obtained_equipment.has(tier):
				return tier
				
	elif button_name == "Potions":
		for tier in ["BluePotion", "RedPotion"]:
			if EquipmentManager.obtained_equipment.has(tier):
				return tier
				
	return button_name
