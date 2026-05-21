extends AbstractGhost
class_name WallGhost

var origin: Vector2

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	var shader_material: ShaderMaterial = sprite.material as ShaderMaterial
	shader_material.resource_local_to_scene = true
	Context.ghost_on = true

func _process(_delta: float) -> void:
	var shader_material: ShaderMaterial = sprite.material as ShaderMaterial

	if can_be_placed == 0:
		shader_material.set_shader_parameter("target_color", Vector4(0.0, 1.0, 0.0, 0.5))
	else:
		shader_material.set_shader_parameter("target_color", Vector4(1.0, 0.0, 0.0, 0.5))

func _on_area_2d_area_entered(_area: Area2D) -> void:
	can_be_placed += 1

func _on_area_2d_area_exited(_area: Area2D) -> void:
	can_be_placed -= 1

func get_first_pos() -> Vector2:
	return global_position

func get_last_pos() -> Vector2:
	return global_position

func get_size() -> Vector2:
	return sprite.texture.get_size() * sprite.scale
