extends MarginContainer
class_name AreaButton

@onready var label: Label = $VBoxContainer/Label
@onready var sprite: TextureRect = $VBoxContainer/TextureRect
@onready var button: Button = $VBoxContainer/Button

var fishing_url: String = "res://core/fishing/FishingGame.tscn"

var area: Area

func _ready() -> void:
	label.text = area.get_label()
	button.disabled = area.is_empty()

func _on_button_pressed() -> void:
	Context.area = area
	get_tree().change_scene_to_file(fishing_url)
