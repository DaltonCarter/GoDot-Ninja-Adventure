extends Area2D

@export var tile_texture: Texture2D
@export var secret_id: int

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	if SceneManager.found_secrets.has(secret_id):
		queue_free()
		return
	
	if tile_texture:
		sprite.texture = tile_texture
	
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if area.is_in_group("explosions"):
		$SecretSFX.play()
		reveal_secret()

func reveal_secret() -> void:
	SceneManager.found_secrets.append(secret_id)
	await $SecretSFX.finished
	queue_free()
