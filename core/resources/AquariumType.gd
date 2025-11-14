class_name AquariumType
extends Resource

@export var id: String
@export var name: String
@export var price: int
@export var capacity: int
@export var color: Color

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
