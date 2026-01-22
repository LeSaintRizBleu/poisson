extends Node2D
class_name MainWallGhost

enum Direction {
  HORIZONTAL,
  VERTICAL,
  NEUTRAL,
}

var dir: Direction = Direction.NEUTRAL
var sig: int = 0

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
	if is_drawing_line:
		if dir == Direction.HORIZONTAL && last_mouse_pos.x != _get_pos_in_grid().x:
			_update_line_preview()
		elif dir == Direction.VERTICAL && last_mouse_pos.y != _get_pos_in_grid().y:
			_update_line_preview()
		elif dir == Direction.NEUTRAL:
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
				_place_wall()
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT && mouse_event.pressed:
			destroy()

func _update_line_preview() -> void:
	var mouse_pos: Vector2 = _get_pos_in_grid()
	var delta: Vector2 = mouse_pos - origin
	var steps: int
	
	if abs(delta.x) > abs(delta.y):
		_set_direction(Direction.HORIZONTAL)
		delta.y = 0
		steps = int(delta.x / grid_size.x)
	elif abs(delta.x) < abs(delta.y):
		_set_direction(Direction.VERTICAL)
		delta.x = 0
		steps = int(delta.y / grid_size.y)

	_update_wall_preview(steps)

func _set_direction(new_dir: Direction) -> void:
	if dir != new_dir:
		clear_walls()
		dir = new_dir

func _update_wall_preview(steps: int) -> void:
	if sign(steps) != sig:
		sig = sign(steps)
		clear_walls()
	var target_count: int = abs(steps)

	while walls.get_child_count() > target_count:
		walls.remove_child(walls.get_children()[-1])

	while walls.get_child_count() < target_count:
		var index: int = walls.get_child_count() + 1
		var offset: Vector2
		if dir == Direction.HORIZONTAL:
			offset = Vector2(sig * index * grid_size.x, 0)
		else:
			offset = Vector2(0, sig * index * grid_size.y)
		add_wall(offset)

func clear_walls() -> void:
	for child in walls.get_children():
		child.free()

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

func _place_wall() -> void:
	for wall in walls.get_children():
		pass

func destroy() -> void:
	Context.ghost_on = false
	queue_free()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	can_be_placed += 1

func _on_area_2d_area_exited(_area: Area2D) -> void:
	can_be_placed -= 1
