extends StaticBody2D
var can_interact: bool = false
var is_open: bool = false

@export var chest_name: String
@export var contents_path: String = "res://Ninja Adventure - Asset Pack/Items/Scroll/Scroll.png"
@export var contents: String = ""



func _ready():
	if SceneManager.opened_chests.has(chest_name):
		is_open = true
		$AnimatedSprite2D.set_animation("open")

func _process(_delta):
	if Input.is_action_just_pressed("interact") and can_interact:
		if !is_open:
			$SFX.playing = true
			set_texture_2d()
			open_chest()
			give_contents_to_player()

func open_chest():
	is_open = true
	$AnimatedSprite2D.set_animation("open")
	$Sprite2D.visible = true
	$ME.playing = true
	$Timer.start()
	SceneManager.opened_chests.append(chest_name)
	get_tree().paused = true
	

func _on_timer_timeout():
	$Sprite2D.visible = false
	get_tree().paused = false

func set_texture_2d():
	var texture_path = ResourceLoader.load(contents_path)
	$Sprite2D.texture = texture_path

func give_contents_to_player():
	match contents:
		"bow":
			EquipmentManager.obtained_equipment.append("Bow")
		"wand":
			EquipmentManager.obtained_equipment.append("MagicWand")
		"map":
			print("you found the dungeon map!")
		"compass":
			print("you found the dungeon compass!")
		"pinion":
			EquipmentManager.obtained_equipment.append("GarudaPinion")
		"magiclantern":
			EquipmentManager.obtained_equipment.erase("Lantern")
			if EquipmentManager.currently_equipped_to_X == "Lantern":
				EquipmentManager.currently_equipped_to_X = ""
			elif EquipmentManager.currently_equipped_to_Z == "Lantern":
				EquipmentManager.currently_equipped_to_Z = "" 
			EquipmentManager.obtained_equipment.append("MagicLantern")
		"lantern":
			EquipmentManager.obtained_equipment.append("Lantern")
		"flute":
			EquipmentManager.obtained_equipment.append("SpiritFlute")
		"wizard":
			EquipmentManager.obtained_equipment.erase("MagicWand")
			if EquipmentManager.currently_equipped_to_X == "MagicWand":
				EquipmentManager.currently_equipped_to_X = ""
			elif EquipmentManager.currently_equipped_to_Z == "MagicWand":
				EquipmentManager.currently_equipped_to_Z = "" 
			EquipmentManager.obtained_equipment.append("WizardWand")
		"power":
			EquipmentManager.obtained_equipment.append("PowerRing")
		"blue":
			EquipmentManager.obtained_equipment.append("BlueRing")
			
			EquipmentManager.refresh_sword_and_armor.emit()
		"red":
			EquipmentManager.obtained_equipment.append("RedRing")
			EquipmentManager.obtained_equipment.erase("BlueRing")
			EquipmentManager.refresh_sword_and_armor.emit()
		"skey":
			EquipmentManager.obtained_equipment.append("SkeletonKey")
		"mkey":
			EquipmentManager.obtained_equipment.append("MasterKey")
			EquipmentManager.obtained_equipment.erase("SkeletonKey")
		"boomerang":
			EquipmentManager.obtained_equipment.append("Boomerang")
		"mboomerang":
			EquipmentManager.obtained_equipment.erase("Boomerang")
			if EquipmentManager.currently_equipped_to_X == "Boomerang":
				EquipmentManager.currently_equipped_to_X = ""
			elif EquipmentManager.currently_equipped_to_Z == "Boomerang":
				EquipmentManager.currently_equipped_to_Z = "" 
			EquipmentManager.obtained_equipment.append("MagicBoomerang")
		"bombbag":
			EquipmentManager.obtained_equipment.append("BombSatchel")
		"meat":
			EquipmentManager.obtained_equipment.append("Meat")
		"redpotion":
			EquipmentManager.obtained_equipment.append("RedPotion")
			EquipmentManager.obtained_equipment.erase("BluePotion")
		"bluepotion":
			EquipmentManager.obtained_equipment.append("BluePotion")
			EquipmentManager.obtained_equipment.erase("RedPotion")
		"woodensword":
			EquipmentManager.obtained_equipment.append("WoodenSword")
			EquipmentManager.currently_equipped_to_X = "WoodenSword"
		"letter":
			EquipmentManager.obtained_equipment.append("Letter")
		"watershoes":
			EquipmentManager.obtained_equipment.append("WaterShoes")
