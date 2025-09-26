extends Node2D
class_name TankGhost

var can_be_placed: int = 0

@onready var sprite: Sprite2D = $Sprite2D

signal createTank
signal error

func _ready() -> void:
	Context.ghostOn = true

func _process(_delta: float) -> void:
	global_position = get_pos_in_grid()
	if can_be_placed == 0:
		sprite.modulate = Color(0, 1, 0, 0.5)
	else:
		sprite.modulate = Color(1, 0, 0, 0.5)

func get_pos_in_grid() -> Vector2:
	return get_global_mouse_position().snapped(Vector2(128, 128))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			create_struct()
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT && mouse_event.pressed:
			destroy()

func create_struct() -> void:
	if can_be_placed == 0:
		Save.subMoney(100)
		createTank.emit(get_pos_in_grid())
		destroy()
	else:
		error.emit("L'objet ne peut pas être placé ici, l'espace n'est pas libre.")

func destroy() -> void:
	Context.ghostOn = false
	queue_free()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	can_be_placed += 1

func _on_area_2d_area_exited(_area: Area2D) -> void:
	can_be_placed -= 1
