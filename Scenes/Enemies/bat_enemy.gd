extends CharacterBody2D

@export var speed: float = 30
@export var starting_point: Vector2

var at_origin: bool = true

var target: Node2D


func _physics_process(delta):
	chase_target()
	
	return_to_start_pos()
	
	animate_enemy()
	
	move_and_slide()

func chase_target():
	if target:
		var distance_to_player: Vector2
		distance_to_player = target.global_position - global_position
		
		var direction_normal: Vector2 = distance_to_player.normalized()
		
		velocity = direction_normal * speed
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
	
	if velocity.x > 0.707:
		$AnimatedSprite2D.play("move_right")
	elif velocity.x < -0.707:
		$AnimatedSprite2D.play("move_left")
	elif velocity.y > 0.707:
		$AnimatedSprite2D.play("move_down")
	elif velocity.y < -0.707:
		$AnimatedSprite2D.play("move_up")


func _on_detection_area_2d_body_entered(body):
	if body is Player:
		target = body


func _on_detection_area_2d_body_exited(body):
	target = null
	
