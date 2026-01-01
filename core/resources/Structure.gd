class_name Structure
extends Resource

## the id of the structure (have to be the same as the file name)
@export var id: String
## the display name of the structure
@export var name: String
## the price of the tank
@export var price: int

func get_label() -> String:
	return name

func get_price() -> int:
	return price

func get_id() -> String:
	return id

func is_tank() -> bool:
	return false
