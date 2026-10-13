extends Area2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var Atk_Dmg: int = 16

var knockback_str: float = 300

func _ready():
	add_to_group("explosions")
	animation.animation_finished.connect(on_explosion_finished)
	animation.play("explosion")
	sfx_player.play()


func on_explosion_finished() -> void:
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("Hostiles"):
		body.take_damage(Atk_Dmg)
	
	#if body is Player:
		#var distance_to_enemy: Vector2 = body.global_position - global_position
		#var knockback_dir: Vector2 = distance_to_enemy.normalized()
	#
		#body.velocity += knockback_dir * knockback_str
	#
