extends CharacterBody2D

@export var explosion_scene: PackedScene = preload("res://Scenes/Weapons&Tools/Bomb/explosion_2d.tscn")

@onready var fuse: Timer = $Timer
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var fuse_duration: float = 3.0

func _ready():
	add_to_group("active_bombs")
	
	fuse.wait_time = fuse_duration
	fuse.one_shot = true
	fuse.timeout.connect(on_fuse_timeout)
	fuse.start()
	
	anim_sprite.play("default")
	anim_sprite.speed_scale = 1.0



func _physics_process(delta: float):
	if velocity != Vector2.ZERO:
		move_and_slide()
		velocity = velocity.move_toward(Vector2.ZERO, 300.0 * delta)
		
	var time_left: float = fuse.time_left
		
	if time_left > 1.5:
		anim_sprite.speed_scale = 1.0
	elif  time_left > 0.6:
		anim_sprite.speed_scale = 3.0
	else:
		anim_sprite.speed_scale = 6.0

func on_fuse_timeout() -> void:
	detonate()

func detonate() -> void:
	if explosion_scene:
		var blast_instance = explosion_scene.instantiate()
		get_parent().add_child(blast_instance)
		blast_instance.global_position = self.global_position
		
	queue_free()
