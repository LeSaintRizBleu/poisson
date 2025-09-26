extends CanvasLayer
class_name TankInventory

@onready var aquariumContainer: ItemList = $MarginContainer/HSplitContainer/Aqurium/VBoxContainer/AquariumList
@onready var inventoryContainer: ItemList = $MarginContainer/HSplitContainer/Inventory/VBoxContainer/InventoryList
@onready var errorPopupManager: ErrorPopupManager = $ErrorPopupManager

var id: String = ""

signal reload_fishes

func _ready() -> void:
	loadAquarium()
	loadInventory()

func loadInventory() -> void:
	for i: int in range(inventoryContainer.item_count):
		inventoryContainer.remove_item(0)
	var data: Dictionary = Save.getInventory()
	for key: String in data.keys():
		if data[key] > 0:
			var url: String = "res://assets/fishes/" + key + ".png"
			var sprite: Texture2D = load(url)
			for i in range(data[key]):
				inventoryContainer.add_item(key, sprite)

func loadAquarium() -> void:
	for i: int in range(aquariumContainer.item_count):
		aquariumContainer.remove_item(0)
	var data: Dictionary = Save.getFishesInAquarium(id)
	for key: String in data.keys():
		if data[key] > 0.0:
			var url: String = "res://assets/fishes/" + key + ".png"
			var sprite: Texture2D = load(url)
			for i in range(data[key]):
				aquariumContainer.add_item(key, sprite)

func _on_aquarium_list_item_selected(index: int) -> void:
	var fish: String = aquariumContainer.get_item_text(index)
	Save.addFishToInventory(fish)
	Save.removeFishFromAquarium(id, fish)
	Save.saveData()
	loadAquarium()
	loadInventory()

func _on_inventory_list_item_selected(index: int) -> void:
	var data: Dictionary = Save.getAquarium(id)
	var size: int = data["size"]
	var fishesIn: int = 0
	var fishes: Dictionary = data["fishes"]
	for v: int in fishes.values():
		fishesIn += v

	if fishesIn < size:
		var fish: String = inventoryContainer.get_item_text(index)
		Save.addFishToAquarium(id, fish)
		Save.removeFishFromInventory(fish)
		Save.saveData()
		loadAquarium()
		loadInventory()
	else:
		errorPopupManager.addPopup("L'aquarium est plein, vous ne pouvez pas ajouter de poisson")

func _on_quit_pressed() -> void:
	quit()

func quit() -> void:
	reload_fishes.emit()
	queue_free()
