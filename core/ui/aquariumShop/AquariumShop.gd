extends Control
class_name AquariumShop

signal create_tank

func open() -> void:
	show()

func close() -> void:
	hide()

func _on_big_pressed() -> void:
	create_tank.emit("big")

func _on_medium_pressed() -> void:
	create_tank.emit("medium")

func _on_small_pressed() -> void:
	create_tank.emit("small")
