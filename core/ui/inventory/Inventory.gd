extends CanvasLayer
class_name Inventory

@onready var fish_container: GridContainer = $MarginContainer/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var description: Label = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/HBoxContainer/Label
@onready var sell_button: Button = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/HBoxContainer/Sell

var card: PackedScene = preload("res://core/ui/inventory/FishCard.tscn")
var fish_info: FishInfo

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

func quit() -> void:
	get_tree().change_scene_to_file(map_url)

func _on_load_description(fish_type: String) -> void:
	var url: String = "res://resources/fishesInfo/"+fish_type+".tres"
	fish_info = load(url)
	description.text = fish_type + " : \n" + fish_info.get_description()
	sell_button.disabled = false
	sell_button.text = "Sell\n(" + str(fish_info.get_sell_value()) + "$)"

func clear_description() -> void:
	description.text = ""
	sell_button.disabled = true
	sell_button.text = "Sell\n(0$)"

func _on_sell_pressed() -> void:
	Save.remove_fish_from_inventory(fish_info.get_fish_name())
	clear_description()
	load_inventory()
	Save.add_money(fish_info.get_sell_value())


func _on_button_pressed() -> void:
	quit()
