class_name AquariumShopButton
extends Button

@export var type: AquariumType

signal shop_button_pressed

func _ready() -> void:
	text = type.get_label()

func _on_pressed() -> void:
	shop_button_pressed.emit(type)
