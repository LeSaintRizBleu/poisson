extends Node2D
class_name MainWallGhost

var can_be_placed: int = 0
var type: Structure

var grid_size: Vector2 = Vector2(32, 32)

var origin: Vector2
var is_drawing_line: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var walls: Node2D = $Walls

var wall_ghost: PackedScene = preload("res://core/structures/wall/WallGhost.tscn")
var last_mouse_pos: Vector2 = Vector2.ZERO

signal create_tank
signal error

func _ready() -> void:
	Context.ghost_on = true

func _process(_delta: float) -> void:
	global_position = handle_position()
	if is_drawing_line && last_mouse_pos != _get_pos_in_grid():
		_update_line_preview()
	var shader_material: ShaderMaterial = sprite.material as ShaderMaterial
	if can_be_placed == 0:
		shader_material.set_shader_parameter("target_color", Vector4(0.0, 1.0, 0.0, 0.5))
	else:
		shader_material.set_shader_parameter("target_color", Vector4(1.0, 0.0, 0.0, 0.5))
	last_mouse_pos = _get_pos_in_grid()

func _get_pos_in_grid() -> Vector2:
	return get_global_mouse_position().snapped(grid_size)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			if !is_drawing_line:
				origin = _get_pos_in_grid()
				is_drawing_line = true
			else:
				#TODO
				pass
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT && mouse_event.pressed:
			destroy()

func _update_line_preview() -> void:
	for child in walls.get_children():
		child.queue_free()

	var mouse_pos: Vector2 = _get_pos_in_grid()
	if abs(mouse_pos.x - origin.x) > abs(mouse_pos.y - origin.y):
		mouse_pos.y = origin.y
		var steps: int = int((mouse_pos.x - origin.x) / 32)
		var s: int = signi(steps)
		for i in range (1, abs(steps)+1):
			add_wall(Vector2(i*32*s, 0))

	else:
		mouse_pos.x = origin.x
		var steps: int = int((mouse_pos.y - origin.y) / 32)
		var s: int = signi(steps)
		for i in range (1, abs(steps)+1):
			add_wall(Vector2(0, i*32*s))

func add_wall(pos: Vector2) -> void:
	var instance: WallGhost = wall_ghost.instantiate()
	instance.type = type
	instance.position = pos
	walls.add_child(instance)

func handle_position() -> Vector2:
	if origin:
		return origin
	else:
		return _get_pos_in_grid()

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
