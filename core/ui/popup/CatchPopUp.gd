extends CanvasLayer
class_name CatchPopUp

@onready var description: Label = $MarginContainer/MarginContainer/VBoxContainer/Desc
@onready var fish: TextureRect = $MarginContainer/MarginContainer/VBoxContainer/Control/Fish

var map_url: String = "res://core/map/Map.tscn"

var fish_info: FishInfo

func _ready() -> void:
	description.text = "It's a " + fish_info.get_fish_name() + " !\n\n" + fish_info.get_description()
	fish.texture = fish_info.get_sprite()
	var new_offset: Vector2 = Vector2(fish_info.get_sprite().get_height()/2.0, fish_info.get_sprite().get_height()/2.0)
	fish.pivot_offset = new_offset

func _on_button_pressed() -> void:
	Save.add_fish_to_inventory(fish_info.get_fish_name())
	get_tree().change_scene_to_file(map_url)
