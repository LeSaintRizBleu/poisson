extends CanvasLayer
class_name TankInventory

@onready var aquarium_container: ItemList = $MarginContainer/HSplitContainer/Aqurium/VBoxContainer/AquariumList
@onready var inventory_container: ItemList = $MarginContainer/HSplitContainer/Inventory/VBoxContainer/InventoryList
@onready var error_popup_manager: ErrorPopupManager = $ErrorPopupManager

var id: String = ""

signal reload_fishes

func _ready() -> void:
	load_aquarium()
	load_inventory()

func load_inventory() -> void:
	for i: int in range(inventory_container.item_count):
		inventory_container.remove_item(0)
	var data: Dictionary = Save.get_inventory()
	for key: String in data.keys():
		if data[key] > 0:
			var url: String = "res://assets/fishes/" + key + ".png"
			var sprite: Texture2D = load(url)
			for i in range(data[key]):
				inventory_container.add_item(key, sprite)

func load_aquarium() -> void:
	for i: int in range(aquarium_container.item_count):
		aquarium_container.remove_item(0)
	var data: Dictionary = Save.get_fishes_in_aquarium(id)
	for key: String in data.keys():
		if data[key] > 0.0:
			var url: String = "res://assets/fishes/" + key + ".png"
			var sprite: Texture2D = load(url)
			for i in range(data[key]):
				aquarium_container.add_item(key, sprite)

func _on_aquarium_list_item_selected(index: int) -> void:
	var fish: String = aquarium_container.get_item_text(index)
	Save.add_fish_to_inventory(fish)
	Save.remove_fish_from_aquarium(id, fish)
	Save.save_data()
	load_aquarium()
	load_inventory()

func _on_inventory_list_item_selected(index: int) -> void:
	var data: Dictionary = Save.get_aquarium(id)
	var fishes_in: int = 0
	var fishes: Dictionary = data["fishes"]
	var type: String = data["type"]
	var size: int = _get_size_for_type(type)
	for v: int in fishes.values():
		fishes_in += v

	if fishes_in < size:
		var fish: String = inventory_container.get_item_text(index)
		Save.add_fish_to_aquarium(id, fish)
		Save.remove_fish_from_inventory(fish)
		Save.save_data()
		load_aquarium()
		load_inventory()
	else:
		error_popup_manager.add_popup("L'aquarium est plein, vous ne pouvez pas ajouter de poisson")

func _get_size_for_type(type: String) -> int:
	var size: int = 0
	match type:
		"small":
			size = 10
		"medium":
			size = 25
		"big":
			size = 60
	return size

func _on_quit_pressed() -> void:
	quit()

func quit() -> void:
	reload_fishes.emit()
	queue_free()
