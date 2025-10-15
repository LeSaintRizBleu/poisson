extends CanvasLayer
class_name Inventory

@onready var fishContainer: GridContainer = $MarginContainer/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var description: Label = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/Label

var card: PackedScene = preload("res://core/ui/inventory/FishCard.tscn")

var mapUrl: String = "res://core/map/Map.tscn"

func _ready() -> void:
	loadInventory()

func loadInventory() -> void:
	for child in fishContainer.get_children():
		fishContainer.remove_child(child)
	var data: Dictionary = Save.getInventory()
	for key: String in data.keys():
		for _x: int in data[key]:
			var instance: FishCard = card.instantiate()
			instance.fishType = key
			fishContainer.add_child(instance)
			instance.loadDescription.connect(onLoadDescription)

func _on_button_pressed() -> void:
	quit()

func quit() -> void:
	get_tree().change_scene_to_file(mapUrl)

func onLoadDescription(fishType: String) -> void:
	var data: Dictionary = Infos.get_fishes_info(fishType)
	description.text = fishType + " : \n" + data["description"]
