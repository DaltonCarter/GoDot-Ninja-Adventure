class_name Menu extends Control

# On Button Focused connection and it's corresponding function are not activly used,
# but remains in the code to aid in bug testing/fixing adn general diagnostics.
#DO NOT DELETE THEM!

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _items: Array = %Equippable.get_children() + %Equippable2.get_children()

signal update_x_key
signal update_z_key

const columns: int = 5
var in_menu: bool = false
var item_index: int = 0


func _ready():
	initialize_equipment()
	initialize_key_items()
	
	
	#for button in get_tree().get_nodes_in_group("Equipment Buttons"):
		#button.focus_entered.connect(on_button_focused.bind(button))
		#button.pressed.connect(on_button_pressed_X.bind(button))



# Proposed handling for changing focus, detect input and increment the Item Index up or down and grab focus. 
# Potential handling for up or down to increment/decrement by 5. 
# Needs to restric increment/decrement to the bounds of the array maximum 9 minimum 0 with
# handling for the start of the game when you have literally nothing.
# Once the navigation has been handled I will need to only allow equipping to happen
# when the X or Z key is pressed, and pass the correct info into the Equipment handler
# so that if you have the Magic Lantern it doesn't equip the regular one etc...

func _process(_delta):
	
	if Input.is_action_just_pressed("open_menu"):
		toggle_menu()
		
	initialize_equipment()
	initialize_key_items()
	
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



func toggle_menu():
	in_menu = !in_menu
	
	if in_menu:
		#print(_items)
		get_tree().paused = true
		Input.flush_buffered_events()
		_animation_player.play("menu_open")
		await _animation_player.animation_finished
		find_initial_focus()
	else:
		_items[item_index].release_focus()
		_animation_player.play("menu_close")
		item_index = 0
		await _animation_player.animation_finished
		get_tree().paused = false
		in_menu = false

func find_initial_focus():
	for i in range(_items.size()):
		if _items[i].visible:
			item_index = i
			_items[item_index].grab_focus()
			break


func menu_navigation(string):
	if in_menu:
		match string:
			"left":
				find_visible_button(-1)
			"right":
				find_visible_button(1)
			"up", "down":
				find_visible_vertical_button()
			"X":
				#_items[item_index].pressed.emit()
				if not _items[item_index].disabled:
					on_button_pressed_X(_items[item_index])
					#print(EquipmentManager.currently_equipped_to_X)
			"Z":
				#_items[item_index].pressed.emit()
				if not _items[item_index].disabled:
					on_button_pressed_Z(_items[item_index])
					#print(EquipmentManager.currently_equipped_to_Z)

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

func find_visible_vertical_button() -> void:
	var total_buttons = _items.size()
	var target_index = (item_index + columns) % total_buttons
	
	if _items[target_index].visible:
		item_index = target_index
		_items[item_index].grab_focus()
		return
	
	var target_row_start = (target_index / columns) * columns
	for scan_dist in range(1, columns):
		var right_side_check = target_index + scan_dist
		if right_side_check < target_row_start + columns and _items[right_side_check].visible:
			item_index = right_side_check
			_items[item_index].grab_focus()
			return
		
		var left_side_check = target_index - scan_dist
		if left_side_check >= target_row_start + columns and _items[left_side_check].visible:
			item_index = left_side_check
			_items[item_index].grab_focus()
			return

func initialize_equipment():
	var CurrentEquipment = EquipmentManager.obtained_equipment
	#Look into how bad it would be to accomplish this Via Map function to streamline it.

	if CurrentEquipment.has("WoodenSword"):
		%Sword.disabled = false
		%Sword.texture_normal = EquipmentManager.sword_1
		%Sword.visible = true
	elif CurrentEquipment.has("Sword"):
		%Sword.disabled = false
		%Sword.texture_normal = EquipmentManager.sword_2
		%Sword.visible = true
	elif CurrentEquipment.has("MagicSword"):
		%Sword.disabled = false
		%Sword.texture_normal = EquipmentManager.sword_3
		%Sword.visible = true
	elif CurrentEquipment.has("TemperedSword"):
		%Sword.disabled = false
		%Sword.texture_normal = EquipmentManager.sword_4
		%Sword.visible = true
	elif CurrentEquipment.has("BlessedSword"):
		%Sword.disabled = false
		%Sword.texture_normal = EquipmentManager.sword_5
		%Sword.visible = true
	else:
		%Sword.disabled = true
	if CurrentEquipment.has("Boomerang"):
		%Boomerang.disabled = false
		%Boomerang.texture_normal = EquipmentManager.boomerang
		%Boomerang.visible = true
	elif CurrentEquipment.has("MagicBoomerang"):
		%Boomerang.disabled = false
		%Boomerang.texture_normal = EquipmentManager.magic_boomerang
		%Boomerang.visible = true
	else:
		%Boomerang.disabled = true
	if CurrentEquipment.has("Lantern"):
		%Lantern.disabled = false
		%Lantern.texture_normal = EquipmentManager.lantern
		%Lantern.visible = true
	elif CurrentEquipment.has("MagicLantern"):
		%Lantern.disabled = false
		%Lantern.texture_normal = EquipmentManager.magic_lantern
		%Lantern.visible = true
	else:
		%Lantern.disabled = true
	if CurrentEquipment.has("Bow"):
		%Bow.disabled = false
		if !EquipmentManager.has_holy_arrow:
			if SceneManager.arrows == 0:
				%Bow.texture_normal = EquipmentManager.bow
				%Bow.visible = true
			else:
				%Bow.texture_normal = EquipmentManager.bowandarrow
				%Bow.visible = true
		else:
			if SceneManager.arrows == 0:
				%Bow.texture_normal = EquipmentManager.bow
				%Bow.visible = true
			else:
				%Bow.texture_normal = EquipmentManager.bowandmarrow
				%Bow.visible = true
	else:
		%Bow.disabled = true
	if CurrentEquipment.has("BombSatchel") && SceneManager.bombs > 0:
		%Bombs.disabled = false
		%Bombs.texture_normal = EquipmentManager.bombs
		%Bombs.visible = true
	else:
		%Bombs.disabled = true
	if CurrentEquipment.has("SpiritFlute"):
		%SpiritFlute.disabled = false
		%SpiritFlute.texture_normal = EquipmentManager.flute
		%SpiritFlute.visible = true
	else:
		%SpiritFlute.disabled = true
	if CurrentEquipment.has("GarudaPinion"):
		%GarudaPinion.disabled = false
		%GarudaPinion.texture_normal = EquipmentManager.pinion
		%GarudaPinion.visible = true
	else:
		%GarudaPinion.disabled = true
	if CurrentEquipment.has("RedPotion"):
		%Potions.disabled = false
		%Potions.texture_normal = EquipmentManager.red_potion
		%Potions.visible = true
	elif CurrentEquipment.has("BluePotion"):
		%Potions.disabled = false
		%Potions.texture_normal = EquipmentManager.blue_potion
		%Potions.visible = true
	else:
		%Potions.disabled = true
	if CurrentEquipment.has("MagicWand"):
		%MagicWand.disabled = false
		%MagicWand.texture_normal = EquipmentManager.magic_wand
		%MagicWand.visible = true
	elif CurrentEquipment.has("WizardWand"):
		%MagicWand.disabled = false
		%MagicWand.texture_normal = EquipmentManager.wizard_wand
		%MagicWand.visible = true
	else:
		%MagicWand.disabled = true
	if CurrentEquipment.has("Meat"):
		%Meat.disabled = false
		%Meat.texture_normal = EquipmentManager.meat
		%Meat.visible = true
	else:
		%Meat.disabled = true

func initialize_key_items():
	var CurrentEquipment = EquipmentManager.obtained_equipment
	#Look into how bad it would be to accomplish this Via Map function to streamline it.
	
	if CurrentEquipment.has("PowerRing"):
		%RingofStrength.texture = EquipmentManager.power_ring
		%RingofStrength.visible = true
	if CurrentEquipment.has("BombSatchel"):
		%BombSatchel.texture = EquipmentManager.bomb_satchel
		%BombSatchel.visible = true
	if CurrentEquipment.has("Letter"):
		%Letter.texture = EquipmentManager.letter
		%Letter.visible = true
	if CurrentEquipment.has("WaterShoes"):
		%WaterShoes.texture = EquipmentManager.water_shoes
		%WaterShoes.visible = true
	if CurrentEquipment.has("BlueRing"):
		%RingofDefense.texture = EquipmentManager.blue_ring
		%RingofDefense.visible = true
	if CurrentEquipment.has("RedRing"):
		%RingofDefense.texture = EquipmentManager.red_ring
		%RingofDefense.visible = true
	if CurrentEquipment.has("SkeletonKey"):
		%MasterKey.texture = EquipmentManager.master_key1
		%MasterKey.visible = true
	if CurrentEquipment.has("MasterKey"):
		%MasterKey.texture = EquipmentManager.master_key2
		%MasterKey.visible = true

func on_button_focused(_button: TextureButton) -> void:
	pass
	#I seemingly don't need this to move the focus around. I will instead leave it as a bug testing and diagnostic function. Might add SFX handling here.

func on_button_pressed_X(button: TextureButton) -> void:
	#print(button, "is pressed with X key.")
	if button.name == "Sword":
		if "WoodenSword" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_Z == "WoodenSword":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "WoodenSword"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "WoodenSword":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "WoodenSword"
				update_x_key.emit()
		elif "Sword" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_Z == "Sword":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "Sword"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "Sword":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "Sword"
				update_x_key.emit()
		elif "MagicSword" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_Z == "MagicSword":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "MagicSword"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "MagicSword":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "MagicSword"
				update_x_key.emit()
		elif "TemperedSword" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_Z == "TemperedSword":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "TemperedSword"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "TemperedSword":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "TemperedSword"
				update_x_key.emit()
		elif "BlessedSword" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_Z == "BlessedSword":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "BlessedSword"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "BlessedSword":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "Blessed-Sword"
				update_x_key.emit()

	if button.name == "Bow":
		if EquipmentManager.currently_equipped_to_Z == "Bow":
			EquipmentManager.currently_equipped_to_Z = ""
			update_z_key.emit()
			EquipmentManager.currently_equipped_to_X = "Bow"
			update_x_key.emit()
		elif EquipmentManager.currently_equipped_to_X == "Bow":
			EquipmentManager.currently_equipped_to_X = ""
			update_x_key.emit()
		else:
			EquipmentManager.currently_equipped_to_X = "Bow"
			update_x_key.emit()

	if button.name == "Boomerang":
		if "MagicBoomerang" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_Z == "MagicBoomerang":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "MagicBoomerang"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "MagicBoomerang":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "MagicBoomerang"
				update_x_key.emit()
		else:
			if EquipmentManager.currently_equipped_to_Z == "Boomerang":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "Boomerang"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "Boomerang":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "Boomerang"
				update_x_key.emit()

	if button.name == "Bombs":
		if EquipmentManager.currently_equipped_to_Z == "Bombs":
			EquipmentManager.currently_equipped_to_Z = ""
			update_z_key.emit()
			EquipmentManager.currently_equipped_to_X = "Bombs"
			update_x_key.emit()
		elif EquipmentManager.currently_equipped_to_X == "Bombs":
			EquipmentManager.currently_equipped_to_X = ""
			update_x_key.emit()
		else:
			EquipmentManager.currently_equipped_to_X = "Bombs"
			update_x_key.emit()

	if button.name == "Lantern":
		if "MagicLantern" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_Z == "MagicLantern":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "MagicLantern"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "MagicLantern":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "MagicLantern"
				update_x_key.emit()
		else:
			if EquipmentManager.currently_equipped_to_Z == "Lantern":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "Lantern"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "Lantern":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "Lantern"
				update_x_key.emit()

	if button.name == "SpiritFlute":
		if EquipmentManager.currently_equipped_to_Z == "SpiritFlute":
			EquipmentManager.currently_equipped_to_Z = ""
			update_z_key.emit()
			EquipmentManager.currently_equipped_to_X = "SpiritFlute"
			update_x_key.emit()
		elif EquipmentManager.currently_equipped_to_X == "SpiritFlute":
			EquipmentManager.currently_equipped_to_X = ""
			update_x_key.emit()
		else:
			EquipmentManager.currently_equipped_to_X = "SpiritFlute"
			update_x_key.emit()

	if button.name == "MagicWand":
		if "MagicLantern" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_Z == "WizardWand":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "WizardWand"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "WizardWand":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "WizardWand"
				update_x_key.emit()
		else:
			if EquipmentManager.currently_equipped_to_Z == "MagicWand":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "MagicWand"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "MagicWand":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "MagicWand"
				update_x_key.emit()

	if button.name == "Meat":
		if EquipmentManager.currently_equipped_to_Z == "Meat":
			EquipmentManager.currently_equipped_to_Z = ""
			update_z_key.emit()
			EquipmentManager.currently_equipped_to_X = "Meat"
			update_x_key.emit()
		elif EquipmentManager.currently_equipped_to_X == "Meat":
			EquipmentManager.currently_equipped_to_X = ""
			update_x_key.emit()
		else:
			EquipmentManager.currently_equipped_to_X = "Meat"
			update_x_key.emit()

	if button.name == "GarudaPinion":
		if EquipmentManager.currently_equipped_to_Z == "GarudaPinion":
			EquipmentManager.currently_equipped_to_Z = ""
			update_z_key.emit()
			EquipmentManager.currently_equipped_to_X = "GarudaPinion"
			update_x_key.emit()
		elif EquipmentManager.currently_equipped_to_X == "GarudaPinion":
			EquipmentManager.currently_equipped_to_X = ""
			update_x_key.emit()
		else:
			EquipmentManager.currently_equipped_to_X = "GarudaPinion"
			update_x_key.emit()

	if button.name == "Potions":
		if "BluePotion" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_Z == "BluePotion":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "BluePotion"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "BluePotion":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "BluePotion"
				update_x_key.emit()
		else:
			if EquipmentManager.currently_equipped_to_Z == "RedPotion":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
				EquipmentManager.currently_equipped_to_X = "RedPotion"
				update_x_key.emit()
			elif EquipmentManager.currently_equipped_to_X == "RedPotion":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
			else:
				EquipmentManager.currently_equipped_to_X = "RedPotion"
				update_x_key.emit()



	#todo: Handle Equip here? Play sound to confirm action here.

func on_button_pressed_Z(button: TextureButton) -> void:
	#print(button, "is pressed with Z key.")
	if button.name == "Sword":
		if "WoodenSword" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_X == "WoodenSword":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "WoodenSword"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "WoodenSword":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "WoodenSword"
				update_z_key.emit()
		elif "Sword" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_X == "Sword":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "Sword"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "Sword":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "Sword"
				update_z_key.emit()
		elif "MagicSword" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_X == "MagicSword":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "MagicSword"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "MagicSword":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "MagicSword"
				update_z_key.emit()
		elif "TemperedSword" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_X == "TemperedSword":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "TemperedSword"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "TemperedSword":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "TemperedSword"
				update_z_key.emit()
		elif "BlessedSword" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_X == "BlessedSword":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "BlessedSword"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "BlessedSword":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "Blessed-Sword"
				update_z_key.emit()

	if button.name == "Bow":
		if EquipmentManager.currently_equipped_to_X == "Bow":
			EquipmentManager.currently_equipped_to_X = ""
			update_x_key.emit()
			EquipmentManager.currently_equipped_to_Z = "Bow"
			update_z_key.emit()
		elif EquipmentManager.currently_equipped_to_Z == "Bow":
			EquipmentManager.currently_equipped_to_Z = ""
			update_z_key.emit()
		else:
			EquipmentManager.currently_equipped_to_Z = "Bow"
			update_z_key.emit()

	if button.name == "Boomerang":
		if "MagicBoomerang" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_X == "MagicBoomerang":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "MagicBoomerang"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "MagicBoomerang":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_z = "MagicBoomerang"
				update_z_key.emit()
		else:
			if EquipmentManager.currently_equipped_to_X == "Boomerang":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "Boomerang"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "Boomerang":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "Boomerang"
				update_z_key.emit()

	if button.name == "Bombs":
		if EquipmentManager.currently_equipped_to_X == "Bombs":
			EquipmentManager.currently_equipped_to_X = ""
			update_x_key.emit()
			EquipmentManager.currently_equipped_to_Z = "Bombs"
			update_z_key.emit()
		elif EquipmentManager.currently_equipped_to_Z == "Bombs":
			EquipmentManager.currently_equipped_to_Z = ""
			update_z_key.emit()
		else:
			EquipmentManager.currently_equipped_to_Z = "Bombs"
			update_z_key.emit()

	if button.name == "Lantern":
		if "MagicLantern" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_X == "MagicLantern":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "MagicLantern"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "MagicLantern":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "MagicLantern"
				update_z_key.emit()
		else:
			if EquipmentManager.currently_equipped_to_X == "Lantern":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "Lantern"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "Lantern":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "Lantern"
				update_z_key.emit()

	if button.name == "SpiritFlute":
		if EquipmentManager.currently_equipped_to_X == "SpiritFlute":
			EquipmentManager.currently_equipped_to_X = ""
			update_x_key.emit()
			EquipmentManager.currently_equipped_to_Z = "SpiritFlute"
			update_z_key.emit()
		elif EquipmentManager.currently_equipped_to_Z == "SpiritFlute":
			EquipmentManager.currently_equipped_to_Z = ""
			update_z_key.emit()
		else:
			EquipmentManager.currently_equipped_to_Z = "SpiritFlute"
			update_z_key.emit()

	if button.name == "MagicWand":
		if "MagicLantern" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_X == "WizardWand":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "WizardWand"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "WizardWand":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "WizardWand"
				update_z_key.emit()
		else:
			if EquipmentManager.currently_equipped_to_X == "MagicWand":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "MagicWand"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "MagicWand":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "MagicWand"
				update_z_key.emit()

	if button.name == "Meat":
		if EquipmentManager.currently_equipped_to_X == "Meat":
			EquipmentManager.currently_equipped_to_X = ""
			update_x_key.emit()
			EquipmentManager.currently_equipped_to_Z = "Meat"
			update_z_key.emit()
		elif EquipmentManager.currently_equipped_to_Z == "Meat":
			EquipmentManager.currently_equipped_to_Z = ""
			update_z_key.emit()
		else:
			EquipmentManager.currently_equipped_to_Z = "Meat"
			update_z_key.emit()

	if button.name == "GarudaPinion":
		if EquipmentManager.currently_equipped_to_X == "GarudaPinion":
			EquipmentManager.currently_equipped_to_X = ""
			update_x_key.emit()
			EquipmentManager.currently_equipped_to_Z = "GarudaPinion"
			update_z_key.emit()
		elif EquipmentManager.currently_equipped_to_Z == "GarudaPinion":
			EquipmentManager.currently_equipped_to_Z = ""
			update_z_key.emit()
		else:
			EquipmentManager.currently_equipped_to_Z = "GarudaPinion"
			update_z_key.emit()

	if button.name == "Potions":
		if "BluePotion" in EquipmentManager.obtained_equipment:
			if EquipmentManager.currently_equipped_to_X == "BluePotion":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "BluePotion"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "BluePotion":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "BluePotion"
				update_z_key.emit()
		else:
			if EquipmentManager.currently_equipped_to_X == "RedPotion":
				EquipmentManager.currently_equipped_to_X = ""
				update_x_key.emit()
				EquipmentManager.currently_equipped_to_Z = "RedPotion"
				update_z_key.emit()
			elif EquipmentManager.currently_equipped_to_Z == "RedPotion":
				EquipmentManager.currently_equipped_to_Z = ""
				update_z_key.emit()
			else:
				EquipmentManager.currently_equipped_to_Z = "RedPotion"
				update_z_key.emit()

	#todo: Handle Equip here? Play sound to confirm action here.
