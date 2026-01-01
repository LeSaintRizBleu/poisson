class_name AquariumType
extends Structure

## the color of the tank (will be replaced with a sprite in the future)
@export var color: Color
## the number of fish the tank can hold
@export var capacity: int

func get_capacity() -> int:
	return capacity

func get_color() -> Color:
	return color

func is_tank() -> bool:
	return true
