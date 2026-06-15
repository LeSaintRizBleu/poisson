extends MarginContainer
class_name AreaButton

@onready var label: Label = $VBoxContainer/Label
@onready var sprite: TextureRect = $VBoxContainer/TextureRect

var fishing_url: String = "res://core/fishing/FishingGame.tscn"

var area: Area

func _ready() -> void:
	label.text = area.get_label()

func _on_button_pressed() -> void:
	Context.area = area
	get_tree().change_scene_to_file(fishing_url)
