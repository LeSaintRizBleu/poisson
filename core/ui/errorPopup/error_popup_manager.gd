extends Control
class_name ErrorPopupManager

var popup: PackedScene = preload("res://core/ui/errorPopup/ErrorPopup.tscn")

@onready var container: VBoxContainer = $MarginContainer/VBoxContainer

func addPopup(content: String) -> void:
	var instance: ErrorPopup = popup.instantiate()
	instance.content = content
	container.add_child(instance)
