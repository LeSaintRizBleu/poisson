class_name FishInfo
extends Resource

enum WATER_TYPE {SALT, FRESH, BRACKISH, ABYSSAL}

## name of the fish (have to be the same as the file name)
@export var name: String
## small description of the fish
@export_multiline var description: String = "TODO"
## the sprite of the fish
@export var sprite: CompressedTexture2D
## the type of water
@export var water_type: WATER_TYPE
## the sell value of the fish
@export var sell_value: int = 50

@export_group("visualisation")
## the max nuber of fishes inside a shoal
@export var max_in_shoal: int = 1
## the speed of the shoal
@export var speed: int = 50
## the rotation speed of the fishes inside the shoal 
@export var rotation_speed: float = 0.1
## the max distance the fish can go
@export var orbit_radius: int = 50

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

func get_description() -> String:
	return description

func get_sprite() -> CompressedTexture2D:
	return sprite

func get_sell_value() -> int:
	return sell_value
