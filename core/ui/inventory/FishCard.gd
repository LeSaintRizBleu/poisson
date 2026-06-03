extends Control
class_name FishCard

var fish_type: String

signal load_description

@onready var label: Label = $MarginContainer/MarginContainer/LabelControl/Name
@onready var sprite: TextureRect = $MarginContainer/MarginContainer/SpriteControl/Sprite

func _ready() -> void:
	load_card()

func load_card() -> void:
	var url: String = "res://resources/fishesInfo/" + fish_type + ".tres"
	var info: FishInfo = load(url)
	label.text = info.name
	sprite.texture = info.sprite

func _on_margin_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			load_description.emit(fish_type)
