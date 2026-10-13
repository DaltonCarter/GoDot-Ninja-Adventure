extends CharacterBody2D
class_name Player

#Player Stats:
@export var move_speed: float = 100
@export var push_strength: float = 140
@export var acceleration: float = 5
@export var foot_offset: float = -3.0

var current_hp: int
var hearts_list: Array = []

var knockback_str: float = 150
var jump_duration: float = 0.4
var max_jump_height: float = 20.0
var jump_speed: float = 40.0

var last_safe_position: Vector2 = Vector2.ZERO

var position_update_timer: float = 0.0
const update_interval: float = 0.15

#Player States:
var is_attacking: bool = false
var is_jumping: bool = false
var is_dead: bool = false
var is_invulnerable: bool = false
var is_falling: bool = false
var can_interact: bool = false

enum Facing { LEFT, RIGHT, UP, DOWN }
var last_facing_direction: Facing = Facing.UP

#Player Signals
signal health_changed(new_health)
signal health_gained(new_health)
signal new_life_container()
signal used_consumable()



var hurt_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Hit & Impact/Hit9.wav")
var fall_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Hit & Impact/Hit2.wav")
var death_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Elemental/Explosion5.wav")
var sword_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Whoosh & Slash/Slash3.wav")
var push_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Hit & Impact/Impact3.wav")

#HUD Variables:
@onready var hud_x: TextureRect = $"CanvasLayer/Panel/Equip Frame X/Currently Equipped to X"
@onready var hud_z: TextureRect = $"CanvasLayer/Panel/Equip Frame Z/Currently Equipped to Z"

#Tool Variables and States:
@onready var tool_anchor: Node2D = %"ToolAnchor"
@onready var character_sprite: AnimatedSprite2D = %PlayerSprite
var last_vector: Vector2 = Vector2.UP


func _ready():

	update_wallet()
	update_keys()
	update_bombs()
	update_arrows()
	
	update_equipment()
	
	EquipmentManager.refresh_sword_and_armor.connect(refresh_defense)
	refresh_defense()

	
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
	
	update_equipment()
	
	if Input.is_action_just_pressed("interact") and not can_interact:
		_handle_tool_use(EquipmentManager.currently_equipped_to_X)
	
	if Input.is_action_just_pressed("action") and not can_interact:
		_handle_tool_use(EquipmentManager.currently_equipped_to_Z)
	
	move_and_slide()
	update_safe_position(_delta)
	position_update_timer += _delta
	if position_update_timer >= update_interval:
		position_update_timer = 0.0
		check_floor_hazards()

func move_player():
	var move_vector: Vector2 = Input.get_vector("move_left","move_right", "move_up", "move_down")
	
	if is_jumping or is_falling:
		move_and_slide()
		return
	
	if %GUI.in_menu:
		velocity = Vector2.ZERO
		return
	
	if move_vector != Vector2.ZERO:
		last_vector = move_vector.normalized()
	
	velocity = velocity.move_toward(move_vector * move_speed, acceleration)
	
	if velocity.x > 0:
		if is_jumping:
			return
		$PlayerSprite.play("move_right")
		$InteractionArea2D.position = Vector2(5, 1)
		last_facing_direction = Facing.RIGHT

	elif velocity.x < 0:
		if is_jumping:
			return
		$PlayerSprite.play("move_left")
		$InteractionArea2D.position = Vector2(-5, 1)
		last_facing_direction = Facing.LEFT

	elif velocity.y > 0:
		if is_jumping:
			return
		$PlayerSprite.play("move_down")
		$InteractionArea2D.position = Vector2(0, 8)
		last_facing_direction = Facing.DOWN

	elif velocity.y < 0:
		if is_jumping:
			return
		$PlayerSprite.play("move_up")
		$InteractionArea2D.position = Vector2(0, -5)
		last_facing_direction = Facing.UP

	else:
		$PlayerSprite.stop()
		velocity = Vector2.ZERO

func push_blocks():
	
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	
	if collision:
		var collider_node = collision.get_collider()
	
		if not is_instance_valid(collider_node):
			return
	
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

func refresh_defense() -> void:
	var mat = character_sprite.material as ShaderMaterial
	if not mat:
		return
		
	if EquipmentManager.obtained_equipment.has("RedRing"):
		mat.set_shader_parameter("active_palette", SceneManager.red_armor)
		SceneManager.player_defense = 0.25 

		
	elif EquipmentManager.obtained_equipment.has("BlueRing"):
		mat.set_shader_parameter("active_palette", SceneManager.blue_armor)
		SceneManager.player_defense = 0.50
		
	else:
		mat.set_shader_parameter("active_palette", mat.get_shader_parameter("base_palette"))
		SceneManager.player_defense = 1.0

func _on_area_2d_body_entered(body):
	if body.is_in_group("interactable"):
		can_interact = true
		body.can_interact = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("interactable"):
		can_interact = false
		body.can_interact = false

func update_equipment() -> void:
	_sync_hud_display(hud_x, EquipmentManager.currently_equipped_to_X)
	_sync_hud_display(hud_z, EquipmentManager.currently_equipped_to_Z)
	
	for child in tool_anchor.get_children():
		child.queue_free()

func _sync_hud_display(target_rect: TextureRect, item_id: String) -> void:
	if item_id == "":
		target_rect.texture = null
		target_rect.visible = false
		return
		
	target_rect.texture = EquipmentManager.get_equipment_texture(item_id)
	target_rect.visible = true

func _handle_tool_use(item_id: String) -> void:
	if item_id == "": return
	
	if "Sword" in item_id:
		attack()
		return
		
	if "Potion" in item_id:
		use_potion()
		return
	
	if item_id == "Boomerang"  or item_id == "MagicBoomerang":
		use_boomerang(item_id)
		return
		
	if item_id =="GarudaPinion":
		use_garuda_pinion()
		return
	
	if item_id =="Bombs":
		use_bomb()
		return

func _on_hitbox_area_2d_body_entered(body):

	if body.is_in_group("Hostiles"):
		
		if not is_invulnerable and SceneManager.player_hp > 0:
			SceneManager.is_knocked_back = true
			$PlayerSFX.stream = hurt_sfx
			$PlayerSFX.playing = true

			take_damage(body.Atk_Dmg)
			is_invulnerable = true
	
			var distance_to_player: Vector2 = global_position - body.global_position
			var knockback_dir: Vector2 = distance_to_player.normalized()
	
			var enemy_knockback_str: float = body.knockback_str
			velocity += knockback_dir * enemy_knockback_str
	
			if %GUI.in_menu:
				velocity = Vector2.ZERO
				return
	
			var mat = character_sprite.material as ShaderMaterial
	
			if mat:
				mat.set_shader_parameter("flash_modifier", 0.60)
				await get_tree().create_timer(0.1).timeout
				mat.set_shader_parameter("flash_modifier", 0.0)
		
			SceneManager.is_knocked_back = false
			await get_tree().create_timer(0.3).timeout
			is_invulnerable = false

func _on_hitbox_area_2d_area_entered(area):
	if area.is_in_group("explosions"):
		
		if not is_invulnerable and SceneManager.player_hp > 0:
			SceneManager.is_knocked_back = true
			$PlayerSFX.stream = hurt_sfx
			$PlayerSFX.playing = true

			take_damage(area.Atk_Dmg)
			is_invulnerable = true
	
			if %GUI.in_menu:
				velocity = Vector2.ZERO
				return
	
			var mat = character_sprite.material as ShaderMaterial
	
			if mat:
				mat.set_shader_parameter("flash_modifier", 0.60)
				await get_tree().create_timer(0.1).timeout
				mat.set_shader_parameter("flash_modifier", 0.0)
		
			SceneManager.is_knocked_back = false
			await get_tree().create_timer(0.3).timeout
			is_invulnerable = false

func take_damage(amount: int):
	
	var calculated_dmg: int = ceil(amount * SceneManager.player_defense)
	var final_dmg: int = max(1, calculated_dmg)
	
	if SceneManager.player_hp - final_dmg <= 0:
		SceneManager.player_hp = clamp(SceneManager.player_hp - final_dmg, 0, SceneManager.player_max_hp)
		health_changed.emit(SceneManager.player_hp)
		is_dead = true
		die()
	else:
		SceneManager.player_hp = clamp(SceneManager.player_hp - final_dmg, 0, SceneManager.player_max_hp)
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

func damage_feedback() -> void:
	
	if is_dead:
		return
	
	is_invulnerable = true
	$PlayerSFX.stream = hurt_sfx
	$PlayerSFX.playing = true
	
	
	var mat = character_sprite.material as ShaderMaterial
	
	if mat:
		mat.set_shader_parameter("flash_modifier", 0.60)
		await get_tree().create_timer(0.1).timeout
		mat.set_shader_parameter("flash_modifier", 0.0)
	
	

	
	await get_tree().create_timer(0.4).timeout
	
	is_invulnerable = false

func _on_death_timer_timeout():
	SceneManager.player_hp = SceneManager.player_max_hp
	get_tree().call_deferred("reload_current_scene")

func _on_interaction_area_2d_area_entered(area):
	if area is Life_Drop:
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

func use_potion() -> void:

	var active_slot: String = "X" if EquipmentManager.currently_equipped_to_X in ["BluePotion", "RedPotion"] else "Z"
	var potion_id: String = EquipmentManager.currently_equipped_to_X if active_slot == "X" else EquipmentManager.currently_equipped_to_Z
	
	heal_damage(80)
	
	if potion_id == "BluePotion":
		EquipmentManager.obtained_equipment.erase("BluePotion")
		EquipmentManager.obtained_equipment.append("RedPotion")
		update_equipment()
		used_consumable.emit()
		
		if active_slot == "X":
			EquipmentManager.currently_equipped_to_X = "RedPotion"
		else:
			EquipmentManager.currently_equipped_to_Z = "RedPotion"
			

	elif potion_id == "RedPotion":
		EquipmentManager.obtained_equipment.erase("RedPotion")
		if EquipmentManager.currently_equipped_to_X == "RedPotion": EquipmentManager.currently_equipped_to_X = ""
		if EquipmentManager.currently_equipped_to_Z == "RedPotion": EquipmentManager.currently_equipped_to_Z = ""
		update_equipment()
		used_consumable.emit()
		
	%GUI.initialize_equipment()
	%GUI.initialize_key_items()
	
	update_equipment()

func attack():
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

func use_boomerang(equip_id: String) -> void:
	if get_tree().get_first_node_in_group("active_player_boomerangs") != null:
		return
		
	
	
	var tool_scene: PackedScene = EquipmentManager.get_equipment_scene(equip_id)
	
	if tool_scene == null:
		print("ERROR: Boomerang Scene returned Null from the Equipment Manager!")
		return
	
	var tool_instance = tool_scene.instantiate()
	var current_input: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var throw_direction: Vector2 = Vector2.ZERO
	
	if current_input != Vector2.ZERO:
		throw_direction = last_vector
	else:
		match last_facing_direction:
			Facing.LEFT:  throw_direction = Vector2.LEFT
			Facing.RIGHT: throw_direction = Vector2.RIGHT
			Facing.UP:    throw_direction = Vector2.UP
			Facing.DOWN:  throw_direction = Vector2.DOWN
	
	tool_instance.player = self
	var spawn_offset: Vector2 = throw_direction
	
	tool_instance.global_position = self.global_position + spawn_offset
	get_parent().add_child(tool_instance)
	
	
	tool_instance.initialize_throw(throw_direction, equip_id)

func use_garuda_pinion() -> void:
	if is_jumping or is_attacking or SceneManager.is_knocked_back:
		return
	
	is_jumping = true
	
	match last_facing_direction:
		Facing.UP:
			character_sprite.play("jump_up")
		Facing.DOWN:
			character_sprite.play("jump_down")
		Facing.LEFT:
			character_sprite.play("jump_left")
		Facing.RIGHT:
			character_sprite.play("jump_right")
	
	if has_node("HitboxArea2D"):
		%HitboxArea2D.set_deferred("monitoring", false)
	
	var move_input: Vector2 = velocity.normalized()
	
	if move_input == Vector2.ZERO:
		var facing_vector: Vector2 = get_vector_from_facing_value()
		velocity = facing_vector * 0.01
	else:
		velocity = move_input * jump_speed
	
	execute_jump_arc()

func get_vector_from_facing_value() -> Vector2:
	match last_facing_direction:
		Facing.LEFT:
			return Vector2.LEFT
		Facing.RIGHT:
			return Vector2.RIGHT
		Facing.UP:
			return Vector2.UP
		Facing.DOWN:
			return Vector2.DOWN
		_:
			return Vector2.DOWN

func execute_jump_arc() -> void:
	var jump = create_tween().set_parallel(false)
	
	jump.tween_property(character_sprite, "offset:y", -max_jump_height, jump_duration / 2.0)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	jump.tween_property(character_sprite, "offset:y", 0.0, jump_duration / 2.0)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
		
	jump.finished.connect(on_landing)

func on_landing() -> void:
	is_jumping = false
	
	if has_node("%HitboxArea2D"):
		%HitboxArea2D.set_deferred("monitoring", true)
	
	match last_facing_direction:
		Facing.UP:
			character_sprite.play("move_up")
		Facing.DOWN:
			character_sprite.play("move_down")
		Facing.LEFT:
			character_sprite.play("move_left")
		Facing.RIGHT:
			character_sprite.play("move_right")
	
	character_sprite.offset.y = 0.0
	
	velocity = Vector2.ZERO
	
	if has_method("check_floor_hazzards"):
		check_floor_hazards()

func check_floor_hazards() -> void:
	var floor_tile: TileMapLayer = get_parent().get_node_or_null("DungeonFloor")
	
	if not floor_tile:
		return
	
	var local_tile: Vector2i = floor_tile.local_to_map(floor_tile.to_local(global_position))
	var tile_data: TileData = floor_tile.get_cell_tile_data(local_tile)
	
	if tile_data == null:
		trigger_fall()
		return
	
	var terrain: String = tile_data.get_custom_data("terrain_type")
	
	match terrain:
		"poison":
			if is_invulnerable or is_jumping:
				return
			take_damage(1)
			damage_feedback()
		"spikes":
			if is_invulnerable or is_jumping:
				return
			take_damage(2)
			damage_feedback()
		"pit":
			if is_jumping:
				return
			trigger_fall()
		_:
			pass

func update_safe_position(delta: float) -> void:
	if is_jumping or is_falling:
		return
	
	position_update_timer += delta
	if position_update_timer >= update_interval:
		position_update_timer = 0.0
		var floor_tile: TileMapLayer = get_parent().get_node_or_null("DungeonFloor")
		
		if floor_tile:
			
			var local_tile: Vector2i = floor_tile.local_to_map(floor_tile.to_local(global_position))
			var tile_data: TileData = floor_tile.get_cell_tile_data(local_tile)
			
			if tile_data:
				var terrain: String = tile_data.get_custom_data("terrain_type")
				
				if terrain != "pit" and terrain != "poison" and terrain != "spikes":
					
					var safe_cell: Vector2i = floor_tile.local_to_map(floor_tile.to_local(global_position))
					var safe_tile_center: Vector2 = floor_tile.to_global(floor_tile.map_to_local(safe_cell))
					last_safe_position = safe_tile_center

func trigger_fall() -> void:
	if is_falling:
		return
		
	is_falling = true
	
	velocity = Vector2.ZERO
	
	var floor_tile: TileMapLayer = get_parent().get_node_or_null("DungeonFloor")
	
	if floor_tile:
		var local_pos = floor_tile.to_local(global_position)
		var map_cell: Vector2i = floor_tile.local_to_map(local_pos)
		var tile_center_pos: Vector2 = floor_tile.to_global(floor_tile.map_to_local(map_cell))
		global_position = tile_center_pos
	
	$PlayerSFX.stream = fall_sfx
	$PlayerSFX.play()
	
	character_sprite.play("jump_down")
	
	var fall_tween = create_tween().set_parallel(false)
	
	fall_tween.tween_property(character_sprite, "scale", Vector2.ZERO, 0.4)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	
	fall_tween.tween_property(character_sprite, "rotation", deg_to_rad(360.0 * 2.0), 0.4)\
		.set_trans(Tween.TRANS_LINEAR)
	
	fall_tween.chain().tween_callback(fall_complete)

func fall_complete() -> void:
	take_damage(2)
	
	if last_safe_position != Vector2.ZERO:
		global_position = last_safe_position
		
	character_sprite.scale = Vector2.ONE
	character_sprite.rotation = 0.0
	is_falling = false
	
	if is_dead:
		return
		
	match last_facing_direction:
		Facing.UP:
			character_sprite.play("move_up")
		Facing.DOWN:
			character_sprite.play("move_down")
		Facing.LEFT:
			character_sprite.play("move_left")
		Facing.RIGHT:
			character_sprite.play("move_right")
	damage_feedback()

func use_bomb() -> void:
	if SceneManager.bombs <= 0:
		return
	
	SceneManager.bombs -= 1
	
	var bomb = load("res://Scenes/Weapons&Tools/Bomb/bomb_item.tscn")
	var bomb_instance = bomb.instantiate()
	get_parent().add_child(bomb_instance)
	
	var drop_offset = get_vector_from_facing_value() * 12.0
	bomb_instance.global_position = global_position + drop_offset
	
	if SceneManager.bombs == 0:
		EquipmentManager.obtained_equipment.erase("Bombs")
		
		if EquipmentManager.currently_equipped_to_X == "Bombs":
			EquipmentManager.currently_equipped_to_X = ""
	
		if EquipmentManager.currently_equipped_to_Z == "Bombs":
			EquipmentManager.currently_equipped_to_Z = ""
	
	update_equipment()
