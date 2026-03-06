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
	#update_hp_bar()
	
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
	
	if Input.is_action_just_pressed("interact") and not can_interact:
		attack()
	
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

func _on_area_2d_body_entered(body):
	if body.is_in_group("interactable"):
		can_interact = true
		body.can_interact = true



func _on_area_2d_body_exited(body):
	if body.is_in_group("interactable"):
		can_interact = false
		body.can_interact = false


func update_equipment_for_z_key():
	pass


func update_equipment_for_x_key():
	pass



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
	SceneManager.player_life_containers += 1
	SceneManager.player_max_hp = 4 * SceneManager.player_life_containers
	new_life_container.emit()
	heal_damage(80)
	

func attack():
	if not $AttackDuration.is_stopped():
		return
	
	$AttackDuration.start()
	$PlayerSFX.stream = sword_sfx
	$PlayerSFX.volume_db = -2.0
	$PlayerSFX.pitch_scale = 0.8
	$PlayerSFX.playing = true
	$Sword.visible = true
	%SwordArea2D.monitoring = true
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
	%SwordArea2D.monitoring = false
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
