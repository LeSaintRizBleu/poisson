extends Control
class_name AquariumShop

signal create_structure_from_shop

func open() -> void:
	show()

func close() -> void:
	hide()

func _on_aquarium_shop_button_shop_button_pressed(type: Structure) -> void:
	create_structure_from_shop.emit(type)
