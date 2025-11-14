extends Control
class_name AquariumShop

signal create_tank

func open() -> void:
	show()

func close() -> void:
	hide()

func _on_aquarium_shop_button_shop_button_pressed(type: AquariumType) -> void:
	create_tank.emit(type)
