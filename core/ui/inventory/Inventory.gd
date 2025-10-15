extends CanvasLayer
class_name Inventory

@onready var fish_container: GridContainer = $MarginContainer/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var description: Label = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/Label

var card: PackedScene = preload("res://core/ui/inventory/FishCard.tscn")

var map_url: String = "res://core/map/Map.tscn"

func _ready() -> void:
	load_inventory()

func load_inventory() -> void:
	for child in fish_container.get_children():
		fish_container.remove_child(child)
	var data: Dictionary = Save.get_inventory()
	for key: String in data.keys():
		for _x: int in data[key]:
			var instance: FishCard = card.instantiate()
			instance.fish_type = key
			fish_container.add_child(instance)
			instance.load_description.connect(_on_load_description)

func _on_button_pressed() -> void:
	quit()

func quit() -> void:
	get_tree().change_scene_to_file(map_url)

func _on_load_description(fish_type: String) -> void:
	var data: Dictionary = Infos.get_fishes_info(fish_type)
	description.text = fish_type + " : \n" + data["description"]
