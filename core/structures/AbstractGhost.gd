@abstract
extends Node2D
class_name AbstractGhost

@abstract func get_first_pos() -> Vector2
@abstract func get_last_pos() -> Vector2

var grid_size: Vector2 = Vector2(32, 32)
var can_be_placed: int = 0

var type: Structure

signal error

func destroy() -> void:
	Context.ghost_on = false
	queue_free()

func get_pos_in_grid() -> Vector2:
	return get_global_mouse_position().snapped(grid_size)
