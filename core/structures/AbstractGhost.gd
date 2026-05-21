@abstract
extends Node2D
class_name AbstractGhost

@abstract func get_first_pos() -> Vector2
@abstract func get_last_pos() -> Vector2

var grid_size: Vector2 = Vector2(32, 32)
var can_be_placed: int = 0

var type: Structure

signal error

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D

func effect(_delta: float) -> void:
	pass

func init() -> void:
	pass

func _ready() -> void:
	var shader_material: ShaderMaterial = sprite.material as ShaderMaterial
	shader_material.resource_local_to_scene = true
	area.area_entered.connect(_on_area_2d_area_entered)
	area.area_exited.connect(_on_area_2d_area_exited)
	Context.ghost_on = true
	init()

func _process(delta: float) -> void:
	effect(delta)
	var shader_material: ShaderMaterial = sprite.material as ShaderMaterial
	if can_be_placed == 0:
		shader_material.set_shader_parameter("target_color", Vector4(0.0, 1.0, 0.0, 0.5))
	else:
		shader_material.set_shader_parameter("target_color", Vector4(1.0, 0.0, 0.0, 0.5))

func destroy() -> void:
	Context.ghost_on = false
	queue_free()

func get_pos_in_grid() -> Vector2:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var offset: Vector2 = get_size() / 2.0
	return (mouse_pos - offset).snapped(grid_size) + offset + Vector2(1,1)

func get_size() -> Vector2:
	return sprite.texture.get_size() * sprite.scale

func _on_area_2d_area_entered(_area: Area2D) -> void:
	can_be_placed += 1

func _on_area_2d_area_exited(_area: Area2D) -> void:
	can_be_placed -= 1
