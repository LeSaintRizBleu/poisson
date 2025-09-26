extends Control
class_name FishCard

var fishType: String

signal loadDescription

@onready var label: Label = $MarginContainer/MarginContainer/Name
@onready var sprite: TextureRect = $MarginContainer/MarginContainer/Control/Sprite

func _ready() -> void:
	loadCard()

func loadCard() -> void:
	label.text = fishType
	var url: String = "res://assets/fishes/" + fishType + ".png"
	sprite.texture = load(url)

func _on_margin_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			loadDescription.emit(fishType)
