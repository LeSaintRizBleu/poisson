extends Control
class_name FishCard

var fish_type: String

signal load_description

@onready var label: Label = $MarginContainer/MarginContainer/Name
@onready var sprite: TextureRect = $MarginContainer/MarginContainer/Control/Sprite

func _ready() -> void:
	load_card()

func load_card() -> void:
	label.text = fish_type
	var url: String = "res://assets/fishes/" + fish_type + ".png"
	sprite.texture = load(url)

func _on_margin_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			load_description.emit(fish_type)
