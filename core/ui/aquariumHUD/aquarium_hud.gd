extends CanvasLayer
class_name AquariumHUD

var mapUrl: String = "res://core/map/Map.tscn"

@onready var errorPopupManager: ErrorPopupManager = $ErrorPopupManager
@onready var money: Label = $MarginContainer/HBoxContainer/Money

@onready var shopButton: Button = $MarginContainer/Shop
@onready var mapButton: Button = $MarginContainer/Map

@onready var shop: AquariumShop = $AquariumShop

var shopOpened: bool = false

signal createTank

func _ready() -> void:
	update()

func _on_map_pressed() -> void:
	if randi() % 2 == 0:
		Context.fish = "test1"
	else:
		Context.fish = "test2"
	get_tree().change_scene_to_file(mapUrl)


func _on_shop_pressed() -> void:
	openShop()

func errorPopup(content: String) -> void:
	errorPopupManager.addPopup(content)

func update() -> void:
	var m: int = Save.getMoney()
	money.text = str(m) + " $"

func openShop() -> void:
	shopOpened = true
	shop.open()
	shopButton.hide()
	mapButton.hide()

func closeShop() -> void:
	shopOpened = false
	shop.close()
	shopButton.show()
	mapButton.show()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT && mouse_event.pressed:
			if shopOpened:
				closeShop()

func _on_aquarium_shop_create_tank(type: String) -> void:
	closeShop()
	createTank.emit(type)
