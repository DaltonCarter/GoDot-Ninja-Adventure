extends CharacterBody2D
class_name Player

@export var move_speed: float = 100
@export var push_strength: float = 140
var current_hp: int

signal health_changed(new_health)
signal health_gained(new_health)
signal new_life_container()

var hearts_list: Array = []

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
func _physics_process(delta):
	
	move_player()
	push_blocks()
	update_wallet()
	update_keys()
	
	move_and_slide()
	




func move_player():
	var move_vector: Vector2 = Input.get_vector("move_left","move_right", "move_up", "move_down")
	
	
	velocity = move_vector * move_speed
	
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
		body.can_interact = true



func _on_area_2d_body_exited(body):
	if body.is_in_group("interactable"):
		body.can_interact = false


func update_equipment_for_z_key():
	pass


func update_equipment_for_x_key():
	pass



func _on_hitbox_area_2d_body_entered(body):
	if body.is_in_group("Hostiles"):
		if SceneManager.player_hp > 0:
			take_damage(1)

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
	$PlayerSprite.play("dead")
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
