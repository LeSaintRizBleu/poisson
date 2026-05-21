extends AbstractGhost
class_name TankGhost

signal create_tank

func effect(_delta: float) -> void:
	global_position = get_pos_in_grid()

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

func get_first_pos() -> Vector2:
	return global_position

func get_last_pos() -> Vector2:
	return global_position
