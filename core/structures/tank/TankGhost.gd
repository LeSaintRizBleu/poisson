extends Node2D
class_name TankGhost

var can_be_placed: int = 0
var type: AquariumType

var grid_size: Vector2 = Vector2(32, 32)

@onready var sprite: Sprite2D = $Sprite2D

signal create_tank
signal error

func _ready() -> void:
	Context.ghost_on = true

func _process(_delta: float) -> void:
	global_position = _get_pos_in_grid()
	var shader_material: ShaderMaterial = sprite.material as ShaderMaterial
	if can_be_placed == 0:
		shader_material.set_shader_parameter("target_color", Vector4(0.0, 1.0, 0.0, 0.5))
	else:
		shader_material.set_shader_parameter("target_color", Vector4(1.0, 0.0, 0.0, 0.5))

func _get_pos_in_grid() -> Vector2:
	return get_global_mouse_position().snapped(grid_size)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			create_struct()
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT && mouse_event.pressed:
			destroy()

func create_struct() -> void:
	if can_be_placed == 0:
		Save.sub_money(type.get_price())
		create_tank.emit(_get_pos_in_grid(), type)
		destroy()
	else:
		error.emit("L'objet ne peut pas être placé ici, l'espace n'est pas libre.")

func destroy() -> void:
	Context.ghost_on = false
	queue_free()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	can_be_placed += 1

func _on_area_2d_area_exited(_area: Area2D) -> void:
	can_be_placed -= 1
