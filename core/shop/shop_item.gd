@abstract
class_name ShopItem extends Resource

@export var icon : Texture2D
@export var name : String = "New item"
@export var description : String = "This is a new item"
@export var is_locked : bool = false

func buy() -> bool:
	return false

func _buy_effect() -> void:
	pass
