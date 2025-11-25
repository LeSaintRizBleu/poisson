class_name FishInfo
extends Resource

@export var name: String
@export var description: String
@export var sprite: CompressedTexture2D

# used for visualisation
@export var speed: int
@export var max_in_shoal: int
@export var rotation: float
@export var orbit_radius: int

# used for fishing
@export var difficulty: int
@export var bar_size: int
@export var bar_duration: float

func get_max_offset() -> float:
	return orbit_radius * 2 + 25

func get_fish_name() -> String:
	return name

func get_speed() -> int:
	return speed

func get_max_in_shoal() -> int:
	return max_in_shoal

func get_rotation() -> float:
	return rotation

func get_orbit_radius() -> int:
	return orbit_radius

func get_difficulty() -> int:
	return difficulty

func get_bar_size() -> int:
	return bar_size

func get_bar_duration() -> float:
	return bar_duration

func get_description() -> String:
	return description

func get_sprite() -> CompressedTexture2D:
	return sprite
