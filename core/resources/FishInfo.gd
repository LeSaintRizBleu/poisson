class_name FishInfo
extends Resource

## name of the fish (have to be the same as the file name)
@export var name: String
## small description of the fish
@export_multiline var description: String
## the sprite of the fish
@export var sprite: CompressedTexture2D
## the sell value of the fish
@export var sell_value: int

@export_group("visualisation")
## the speed of the shoal
@export var speed: int
## the max nuber of fishes inside a shoal
@export var max_in_shoal: int
## the rotation speed of the fishes inside the shoal 
@export var rotation_speed: float
## the max distance the fish can go
@export var orbit_radius: int

@export_group("fishing")
## the type of catch
@export var difficulty: int
## the length of the bar
@export var bar_size: int
## the speed of the cursor to go from top to bottom
@export var bar_speed: float

func get_max_offset() -> float:
	return orbit_radius * 2 + 25

func get_fish_name() -> String:
	return name

func get_speed() -> int:
	return speed

func get_max_in_shoal() -> int:
	return max_in_shoal

func get_rotation_speed() -> float:
	return rotation_speed

func get_orbit_radius() -> int:
	return orbit_radius

func get_difficulty() -> int:
	return difficulty

func get_bar_size() -> int:
	return bar_size

func get_bar_speed() -> float:
	return bar_speed

func get_description() -> String:
	return description

func get_sprite() -> CompressedTexture2D:
	return sprite

func get_sell_value() -> int:
	return sell_value
