extends AbstractGhost
class_name MainWallGhost

enum Direction {
  HORIZONTAL,
  VERTICAL,
  NEUTRAL,
}

var dir: Direction = Direction.NEUTRAL
var sig: int = 0

signal create_wall

var origin: Vector2
var is_drawing_line: bool = false

@onready var walls: Node2D = $Walls

var wall_ghost: PackedScene = preload("res://core/structures/wall/WallGhost.tscn")
var last_mouse_pos: Vector2 = Vector2.ZERO

var last_wall: WallGhost

func effect(_delta: float) -> void:
	global_position = handle_position()
	if is_drawing_line:
		if dir == Direction.HORIZONTAL && last_mouse_pos.x != get_pos_in_grid().x:
			_update_line_preview()
		elif dir == Direction.VERTICAL && last_mouse_pos.y != get_pos_in_grid().y:
			_update_line_preview()
		elif dir == Direction.NEUTRAL:
			_update_line_preview()
	last_mouse_pos = get_pos_in_grid()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			if !is_drawing_line:
				origin = get_pos_in_grid()
				is_drawing_line = true
			else:
				_place_walls()
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT && mouse_event.pressed:
			destroy()

func _update_line_preview() -> void:
	var mouse_pos: Vector2 = get_pos_in_grid()
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
	
	last_wall = null
	if walls.get_child_count() > 0:
		last_wall = walls.get_children().back()

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
	instance.position = pos
	walls.add_child(instance)

func handle_position() -> Vector2:
	if origin:
		return origin
	else:
		return get_pos_in_grid()

func _place_walls() -> void:
	if (_check_walls() && _check_money()):
		var pos: Array[Vector2] = [] 
		for wall: WallGhost in walls.get_children():
			pos.append(wall.global_position)
		pos.append(origin)
		create_wall.emit(pos)
		destroy()

	else:
		error.emit("L'objet ne peut pas être placé ici, l'espace n'est pas libre.")

func _check_money() -> bool:
	var n: int = walls.get_child_count() + 1
	var total: int = n * type.get_price()
	if Save.get_money() >= total:
		Save.sub_money(total)
		return true
	return false

func _check_walls() -> bool:
	for wall: WallGhost in walls.get_children():
		if wall.can_be_placed != 0:
			return false
	return can_be_placed == 0

func get_first_pos() -> Vector2:
	return global_position

func get_last_pos() -> Vector2:
	return last_wall.global_position if last_wall else global_position
