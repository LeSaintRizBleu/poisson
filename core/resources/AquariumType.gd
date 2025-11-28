class_name AquariumType
extends Resource

## the id of the tank (have to be the same as the file name)
@export var id: String
## the display name of the tank
@export var name: String
## the color of the tank (will be replaced with a sprite in the future)
@export var color: Color
## the number of fish the tank can hold
@export var capacity: int
## the price of the tank
@export var price: int

func get_label() -> String:
	return name

func get_price() -> int:
	return price

func get_capacity() -> int:
	return capacity

func get_color() -> Color:
	return color

func get_id() -> String:
	return id
