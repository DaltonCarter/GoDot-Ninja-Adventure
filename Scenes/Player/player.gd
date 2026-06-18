extends CharacterBody2D
class_name Player


@export var move_speed: float = 100
@export var push_strength: float = 140
@export var acceleration: float = 5
var current_hp: int
var is_attacking: bool = false

var knockback_str: float = 150

signal health_changed(new_health)
signal health_gained(new_health)
signal new_life_container()

var hearts_list: Array = []

var hurt_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Hit & Impact/Hit9.wav")
var death_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Elemental/Explosion5.wav")
var sword_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Whoosh & Slash/Slash3.wav")
var push_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Hit & Impact/Impact3.wav")

var can_interact: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():

	update_wallet()
	update_keys()
	update_bombs()
	update_arrows()
	
	update_equipment_for_x_key()
	update_equipment_for_z_key()
	
	if SceneManager.player_spawn_position != Vector2(0, 0):
		position = SceneManager.player_spawn_position
	
	if SceneManager.player_direction == Vector2(0, 1):
		$PlayerSprite.set_animation("move_down")
	elif SceneManager.player_direction == Vector2(0, -1):
		$PlayerSprite.set_animation("move_up")
	elif SceneManager.player_direction == Vector2(1, 0):
		$PlayerSprite.set_animation("move_right")
	elif SceneManager.player_direction == Vector2(-1, 0):
		$PlayerSprite.set_animation("move_left")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if SceneManager.player_hp <= 0:
		return
	
	if not is_attacking:
		move_player()
	
	push_blocks()
	update_wallet()
	update_keys()
	update_bombs()
	update_arrows()
	
	update_equipment_for_x_key()

	update_equipment_for_z_key()
	
	if Input.is_action_just_pressed("interact") and not can_interact:
		attack()
	
	if Input.is_action_just_pressed("action") and not can_interact:
		action()
	
	
	move_and_slide()
	




func move_player():
	var move_vector: Vector2 = Input.get_vector("move_left","move_right", "move_up", "move_down")
	
	velocity = velocity.move_toward(move_vector * move_speed, acceleration)
	
	
	if velocity.x > 0:
		$PlayerSprite.play("move_right")
		$InteractionArea2D.position = Vector2(5, 1)

	elif velocity.x < 0:
		$PlayerSprite.play("move_left")
		$InteractionArea2D.position = Vector2(-5, 1)

	elif velocity.y > 0:
		$PlayerSprite.play("move_down")
		$InteractionArea2D.position = Vector2(0, 8)

	elif velocity.y < 0:
		$PlayerSprite.play("move_up")
		$InteractionArea2D.position = Vector2(0, -5)

	else:
		$PlayerSprite.stop()


func push_blocks():
	var collision: KinematicCollision2D = get_last_slide_collision()
	
	if collision:
		var collider_node = collision.get_collider()
		if collider_node.is_in_group("pushable"):
			if !$PlayerSFX.playing:
				$PlayerSFX.stream = push_sfx
				$PlayerSFX.volume_db = -3.0
				$PlayerSFX.pitch_scale = 0.7
				$PlayerSFX.playing = true
			var collision_normal: Vector2 = collision.get_normal()
			
			collider_node.apply_central_force(-collision_normal * push_strength)


func update_wallet():
	var wallet_amount: int = SceneManager.wallet
	%money.text = "x " + str(wallet_amount)

func update_keys():
	var key_amount: int = SceneManager.keys
	%keys.text = "x " + str(key_amount)

func update_bombs():
	var bomb_amount: int = SceneManager.bombs
	%Bombs.text = "x " + str(bomb_amount)

func update_arrows():
	var arrow_amount: int = SceneManager.arrows
	%Arrows.text = "x " + str(arrow_amount)

func _on_area_2d_body_entered(body):
	if body.is_in_group("interactable"):
		can_interact = true
		body.can_interact = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("interactable"):
		can_interact = false
		body.can_interact = false

func update_equipment_for_x_key():
	if EquipmentManager.currently_equipped_to_X != "":
		%"Currently Equiped to X".remove_equip_from_X()
		match_equipment_X()
	else:
		if %"Currently Equiped to X".get_child_count() == 0:
			pass
		else:
			%"Currently Equiped to X".remove_equip_from_X()

func update_equipment_for_z_key():
	if EquipmentManager.currently_equipped_to_Z != "":
		match_equipment_Z()
	else:
		if %"Currently Equipped to Z".get_child_count() == 0:
			pass
		else:
			%"Currently Equipped to Z".remove_equip_from_Z()

func match_equipment_X():
	
	match EquipmentManager.currently_equipped_to_X:
		"WoodenSword": 
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_wooden_sword_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_wooden_sword_to_X()
		"Sword":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_sword_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_sword_to_X()
		"MagicSword":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_magic_sword_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_magic_sword_to_X()
		"TemperedSword":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_tempered_sword_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_tempered_sword_to_X()
		"BlessedSword":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_blessed_sword_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_blessed_sword_to_X()
		"Bow":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_bow_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_bow_to_X()
		"Boomerang":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_boomerang_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_boomerang_to_X()
		"MagicBoomerang":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_magic_boomerang_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_magic_boomerang_to_X()
		"Bombs":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_bombs_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_bombs_to_X()
		"Lantern":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_lantern_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_lantern_to_X()
		"MagicLantern":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_magic_lantern_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_magic_lantern_to_X()
		"SpiritFlute":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_spirit_flute_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_spirit_flute_to_X()
		"MagicWand":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_magic_wand_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_magic_wand_to_X()
		"WizardWand":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_wizard_wand_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_wizard_wand_to_X()
		"Meat":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_meat_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_meat_to_X()
		"GarudaPinion":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_garuda_pinion_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_garuda_pinion_to_X()
		"RedPotion":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_red_potion_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_red_potion_to_X()
		"BluePotion":
			if %"Currently Equiped to X".get_child_count() == 0:
				%"Currently Equiped to X".equip_blue_potion_to_X()
			else:
				%"Currently Equiped to X".remove_equip_from_X()
				%"Currently Equiped to X".equip_blue_potion_to_X()

func match_equipment_Z():
	
	match EquipmentManager.currently_equipped_to_Z:
		"WoodenSword": 
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_wooden_sword_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_wooden_sword_to_Z()
		"Sword":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_sword_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_sword_to_Z()
		"MagicSword":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_magic_sword_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_magic_sword_to_Z()
		"TemperedSword":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_tempered_sword_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_tempered_sword_to_Z()
		"BlessedSword":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_blessed_sword_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_blessed_sword_to_Z()
		"Bow":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_bow_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_bow_to_Z()
		"Boomerang":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_boomerang_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_boomerang_to_Z()
		"MagicBoomerang":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_magic_boomerang_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_magic_boomerang_to_Z()
		"Bombs":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_bombs_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_bombs_to_Z()
		"Lantern":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_lantern_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_lantern_to_Z()
		"MagicLantern":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_magic_lantern_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_magic_lantern_to_Z()
		"SpiritFlute":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_spirit_flute_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_spirit_flute_to_Z()
		"MagicWand":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_magic_wand_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_magic_wand_to_Z()
		"WizardWand":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_wizard_wand_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_wizard_wand_to_Z()
		"Meat":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_meat_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_meat_to_Z()
		"GarudaPinion":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_garuda_pinion_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_garuda_pinion_to_Z()
		"RedPotion":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_red_potion_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_red_potion_to_Z()
		"BluePotion":
			if %"Currently Equipped to Z".get_child_count() == 0:
				%"Currently Equipped to Z".equip_blue_potion_to_Z()
			else:
				%"Currently Equipped to Z".remove_equip_from_Z()
				%"Currently Equipped to Z".equip_blue_potion_to_Z()

func _on_hitbox_area_2d_body_entered(body):
	if body.is_in_group("Hostiles"):
		if SceneManager.player_hp > 0:
			$PlayerSFX.stream = hurt_sfx
			$PlayerSFX.playing = true
			take_damage(body.Atk_Dmg)
	
	var distance_to_player: Vector2 = global_position - body.global_position
	var knockback_dir: Vector2 = distance_to_player.normalized()
	
	var enemy_knockback_str: float = body.knockback_str
	velocity += knockback_dir * enemy_knockback_str
	
	var dmg_flash: Color = Color(1, .1, .1)
	modulate = dmg_flash
	
	await get_tree().create_timer(0.2).timeout
	
	var og_color: Color = Color(1, 1, 1)
	modulate = og_color

func take_damage(amount: int):
	if SceneManager.player_hp - amount <= 0:
		SceneManager.player_hp = clamp(SceneManager.player_hp - amount, 0, SceneManager.player_max_hp)
		health_changed.emit(SceneManager.player_hp)
		die()
	else:
		SceneManager.player_hp = clamp(SceneManager.player_hp - amount, 0, SceneManager.player_max_hp)
		health_changed.emit(SceneManager.player_hp)
		print(SceneManager.player_hp)

func heal_damage(amount: int):
	if SceneManager.player_hp + amount > SceneManager.player_max_hp:
		SceneManager.player_hp = SceneManager.player_max_hp
		health_gained.emit(SceneManager.player_hp)
	else:
		SceneManager.player_hp = clamp(SceneManager.player_hp + amount, 4, SceneManager.player_max_hp)
		health_gained.emit(SceneManager.player_hp)

func die():
	if $DeathTimer.is_stopped():
		$DeathTimer.start()
		
	$PlayerSprite.play("dead")
	$PlayerSFX.stream = death_sfx
	$PlayerSFX.playing = true

func _on_death_timer_timeout():
	SceneManager.player_hp = SceneManager.player_max_hp
	get_tree().call_deferred("reload_current_scene")

func _on_interaction_area_2d_area_entered(area):
	if area is Health_Drop:
		heal_damage(4)
	if area is Heart_Jewel:
		
		obtained_new_heart_jewel()
		print(SceneManager.player_hp)
		print(SceneManager.player_max_hp)
		print(SceneManager.player_life_containers)

func obtained_new_heart_jewel():
	if SceneManager.player_life_containers == 20:
		heal_damage(80)
	else:
		SceneManager.player_life_containers += 1
		SceneManager.player_max_hp = 4 * SceneManager.player_life_containers
		new_life_container.emit()
		heal_damage(80)

func attack():
	
	if EquipmentManager.currently_equipped_to_X == "":
		pass
	elif EquipmentManager.currently_equipped_to_X == "WoodenSword":
		if not $AttackDuration.is_stopped():
			return
		
		$AttackDuration.start()
		$PlayerSFX.stream = sword_sfx
		$PlayerSFX.volume_db = -2.0
		$PlayerSFX.pitch_scale = 0.8
		$PlayerSFX.playing = true
		$Sword.visible = true
		%SwordArea2D2.monitoring = true
		is_attacking = true
		velocity = Vector2(0, 0)
		
		var player_anim: String = $PlayerSprite.animation
		
		match player_anim:
			"move_right":
				$PlayerSprite.play("attack_right")
				$AnimationPlayer.play("attack_right")
			"move_left":
				$PlayerSprite.play("attack_left")
				$AnimationPlayer.play("attack_left")
			"move_down":
				$PlayerSprite.play("attack_down")
				$AnimationPlayer.play("attack_down")
			"move_up":
				$PlayerSprite.play("attack_up")
				$AnimationPlayer.play("attack_up")


func action():
	if EquipmentManager.currently_equipped_to_Z == "":
		pass
	elif EquipmentManager.currently_equipped_to_Z == "WoodenSword":
		if not $AttackDuration.is_stopped():
			return
		
		$AttackDuration.start()
		$PlayerSFX.stream = sword_sfx
		$PlayerSFX.volume_db = -2.0
		$PlayerSFX.pitch_scale = 0.8
		$PlayerSFX.playing = true
		$Sword.visible = true
		%SwordArea2D2.monitoring = true
		is_attacking = true
		velocity = Vector2(0, 0)
		
		var player_anim: String = $PlayerSprite.animation
		
		match player_anim:
			"move_right":
				$PlayerSprite.play("attack_right")
				$AnimationPlayer.play("attack_right")
			"move_left":
				$PlayerSprite.play("attack_left")
				$AnimationPlayer.play("attack_left")
			"move_down":
				$PlayerSprite.play("attack_down")
				$AnimationPlayer.play("attack_down")
			"move_up":
				$PlayerSprite.play("attack_up")
				$AnimationPlayer.play("attack_up")


func _on_sword_area_2d_body_entered(body):
	var distance_to_enemy: Vector2 = body.global_position - global_position
	var knockback_dir: Vector2 = distance_to_enemy.normalized()
	
	body.velocity += knockback_dir * knockback_str
	
	body.take_damage(SceneManager.player_damage)


func _on_attack_duration_timeout():
	$Sword.visible = false
	%SwordArea2D2.monitoring = false
	is_attacking = false
	
	var player_anim: String = $PlayerSprite.animation
	
	match player_anim:
		"attack_right":
			$PlayerSprite.play("move_right")
		"attack_left":
			$PlayerSprite.play("move_left")
		"attack_down":
			$PlayerSprite.play("move_down")
		"attack_up":
			$PlayerSprite.play("move_up")
