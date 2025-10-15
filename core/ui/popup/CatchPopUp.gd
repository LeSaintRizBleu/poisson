extends CanvasLayer
class_name CatchPopUp

@onready var description: Label = $MarginContainer/MarginContainer/VBoxContainer/Desc
var map_url: String = "res://core/map/Map.tscn"

var fish: String

func _ready() -> void:
	var data: Dictionary = Infos.get_fishes_info(fish)
	description.text = "It's a " + fish + " !\n\n" + data["description"]

func _on_button_pressed() -> void:
	Save.add_fish_to_inventory(fish)
	get_tree().change_scene_to_file(map_url)
