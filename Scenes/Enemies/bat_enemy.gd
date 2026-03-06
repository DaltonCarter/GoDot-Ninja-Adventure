extends CharacterBody2D

@export var HP: int = 1
@export var Atk_Dmg: int = 1
@export var speed: float = 30
@export var acceleration: float = 5
@export var starting_point: Vector2
@export var knockback_str: float = 150
@export var is_holding_key: bool = false

var at_origin: bool = true

var target: Node2D

var hurt_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Hit & Impact/Impact2.wav")
var death_sfx = preload("res://Ninja Adventure - Asset Pack/Audio/Sounds/Elemental/Explosion3.wav")

func _physics_process(_delta):
	if HP <= 0:
		return
		
	chase_target()
	return_to_start_pos()
	
	animate_enemy()
	move_and_slide()
	



func chase_target():
	if target:
		var distance_to_player: Vector2
		distance_to_player = target.global_position - global_position
		
		var direction_normal: Vector2 = distance_to_player.normalized()
		
		velocity = velocity.move_toward(direction_normal * speed, acceleration)
		
		at_origin = false

func return_to_start_pos():
	if !target:
		if at_origin:
			$AnimatedSprite2D.play("idle")
		else:
			var distance_to_origin: Vector2
			distance_to_origin = starting_point - global_position
		
			var return_direction_normal: Vector2 = distance_to_origin.normalized()
		
			velocity = return_direction_normal * speed
		if global_position.distance_to(starting_point) < 1.0:
			at_origin = true
			velocity = Vector2(0, 0)

func animate_enemy():
	var normal_velocity: Vector2 = velocity.normalized()
	
	if normal_velocity.x > 0.707:
		$AnimatedSprite2D.play("move_right")
	elif normal_velocity.x < -0.707:
		$AnimatedSprite2D.play("move_left")
	elif normal_velocity.y > 0.707:
		$AnimatedSprite2D.play("move_down")
	elif normal_velocity.y < -0.707:
		$AnimatedSprite2D.play("move_up")


func _on_detection_area_2d_body_entered(body):
	if body is Player:
		target = body


func _on_detection_area_2d_body_exited(body):
	if body is Player:
		target = null
	

func take_damage(dmg: int):
	HP -= 1
	
	$EnemySFX.stream = hurt_sfx
	$EnemySFX.pitch_scale = 1.0
	$EnemySFX.playing = true
	
	if HP <= 0:
		$EnemySFX.stream = death_sfx
		$EnemySFX.playing = true
		get_drops()
		die()
		
	var dmg_flash: Color = Color(1, .1, .1)
	modulate = dmg_flash
	
	await get_tree().create_timer(0.2).timeout
	
	if is_instance_valid(self):
		var og_color: Color = Color(1, 1, 1)
		modulate = og_color

func get_drops():
	if !is_holding_key:
		var random_drop = SceneManager.enemy_drops[randi() % SceneManager.enemy_drops.size()]
		match  random_drop:
			"health":
				var heart_drop = SceneManager.LifeDrop.instantiate()
				get_tree().current_scene.call_deferred("add_child", heart_drop)
				heart_drop.global_position = global_position
			"1xal":
				var xal_drop_1 = SceneManager.MoneyDrop1.instantiate()
				get_tree().current_scene.call_deferred("add_child", xal_drop_1)
				xal_drop_1.global_position = global_position
			"5xal":
				var xal_drop_2 = SceneManager.MoneyDrop2.instantiate()
				get_tree().current_scene.call_deferred("add_child", xal_drop_2)
				xal_drop_2.global_position = global_position
			"bombs":
				var bomb_drop = SceneManager.BombDrop.instantiate()
				get_tree().current_scene.call_deferred("add_child", bomb_drop)
				bomb_drop.global_position = global_position
			"arrows":
				var arrow_drop = SceneManager.ArrowDrop.instantiate()
				get_tree().current_scene.call_deferred("add_child", arrow_drop)
				arrow_drop.global_position = global_position
			"nothing":
				pass
	else:
		var key_drop = SceneManager.KeyDrop.instantiate()
		get_tree().current_scene.call_deferred("add_child", key_drop)
		key_drop.global_position = global_position


func die():
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(1).timeout
	queue_free()
