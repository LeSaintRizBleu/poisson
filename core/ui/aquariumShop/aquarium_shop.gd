extends Control
class_name AquariumShop

signal createTank

func open() -> void:
	show()

func close() -> void:
	hide()

func _on_big_pressed() -> void:
	createTank.emit("big")

func _on_medium_pressed() -> void:
	createTank.emit("medium")

func _on_small_pressed() -> void:
	createTank.emit("small")
