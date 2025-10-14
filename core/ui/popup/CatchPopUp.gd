extends CanvasLayer
class_name CatchPopUp

@onready var description: Label = $MarginContainer/MarginContainer/VBoxContainer/Desc
var mapUrl: String = "res://core/map/Map.tscn"

var fish: String

func _ready() -> void:
	var data: Dictionary = Infos.get_fishes_info(fish)
	description.text = "It's a " + fish + " !\n\n" + data["description"]


func _on_button_pressed() -> void:
	Save.addFishToInventory(fish)
	get_tree().change_scene_to_file(mapUrl)
