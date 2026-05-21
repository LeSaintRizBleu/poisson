extends AbstractGhost
class_name TankGhost

@onready var sprite: Sprite2D = $Sprite2D

signal create_tank

func _ready() -> void:
	Context.ghost_on = true

func _process(_delta: float) -> void:
	global_position = get_pos_in_grid()
	var shader_material: ShaderMaterial = sprite.material as ShaderMaterial
	if can_be_placed == 0:
		shader_material.set_shader_parameter("target_color", Vector4(0.0, 1.0, 0.0, 0.5))
	else:
		shader_material.set_shader_parameter("target_color", Vector4(1.0, 0.0, 0.0, 0.5))

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
		create_tank.emit(get_pos_in_grid(), type)
		destroy()
	else:
		error.emit("L'objet ne peut pas être placé ici, l'espace n'est pas libre.")

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
