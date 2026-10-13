extends Area2D


enum FlightState {OUTGOING, RETURNING}
var active_state: FlightState = FlightState.OUTGOING


var throw_direction: Vector2 = Vector2.ZERO
var travel_speed: float = 0.0
var distance_traveled: float = 0.0
var max_range: float = 0.0

var is_magic_boomerang: bool = false

@export var base_speed: float = 180.0
@export var return_speed: float = 220.0

var player: CharacterBody2D = null

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_detector: RayCast2D = $WallDetector

var timer: float = 0.05

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	#$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)


func initialize_throw(direction: Vector2, boomerang: String) -> void:
	throw_direction = direction.normalized()
	travel_speed = base_speed
	timer = 0.05
	

	
	if boomerang == "MagicBoomerang":
		is_magic_boomerang = true
		max_range = 160.0
		travel_speed *= 1.3
		sprite.play("Magic_Spin")
	else:
		is_magic_boomerang = false
		travel_speed = base_speed
		max_range = 100.0
		sprite.play("Basic_Spin")
	


func _physics_process(delta: float) -> void:
	if timer > 0.0:
		timer -= delta
	
	match active_state:
		FlightState.OUTGOING:
			
			var velocity: Vector2 = throw_direction * travel_speed * delta
			global_position += velocity
			
			if wall_detector:
				wall_detector.target_position = throw_direction * (velocity.length() + 4.0)
				wall_detector.force_raycast_update()
			
			
			if (wall_detector and wall_detector.is_colliding()) or distance_traveled >= max_range:
				active_state = FlightState.RETURNING
				return 
			
			distance_traveled += velocity.length()
			
				
		FlightState.RETURNING:
			if not is_instance_valid(player):
				queue_free()
				return
			
			var vector_to_character: Vector2 = player.global_position - global_position
			var direction_to_character: Vector2 = vector_to_character.normalized()
			
			global_position += direction_to_character * return_speed * delta
			
			if vector_to_character.length() < 12.0 and timer <= 0.0 :
				_return_to_character()

func _on_body_entered(body: Node2D) -> void:
	print("Body Entered, boomerang script")
	print("BOOMERANG STRUCK AN OBJECT: ", body.name, " | Path: ", body.get_path())
	
	if body == player:
		return
	
	if timer > 0.0:
		return
	
	if body.is_in_group("Hostiles"):
		print("Found Hostile")
		
		if body and body.has_method("boomerang_hit"):
			print("Hostile Should be taking damage...")
			body.boomerang_hit(self)
		active_state = FlightState.RETURNING
	
	
	if body.is_in_group("Attackable Switches"):
		print("Found a Switch")
		if body.has_method("toggle_switch"):
			body.toggle_switch()
	
	if active_state == FlightState.OUTGOING:
		active_state = FlightState.RETURNING
		

func _on_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("item_drops") or (area.owner and area.owner.is_in_group("item_drops")):
		area.call_deferred("reparent", self)
		area.call_deferred("position", Vector2.ZERO)
	

func _return_to_character() -> void:
	for child in get_children():
		if child.is_in_group("item_drops"):
			if child.has_method("collect_item"):
				child.collect_item()
				
	queue_free()
