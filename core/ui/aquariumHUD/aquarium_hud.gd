extends CanvasLayer
class_name AquariumHUD

var mapUrl: String = "res://core/map/Map.tscn"
@onready var errorPopupManager: ErrorPopupManager = $ErrorPopupManager
@onready var money: Label = $MarginContainer/HBoxContainer/Money

@onready var shopButton: Button = $MarginContainer/Shop
@onready var mapButton: Button = $MarginContainer/Map

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
	createTank.emit()

func errorPopup(content: String) -> void:
	errorPopupManager.addPopup(content)

func update() -> void:
	var m: int = Save.getMoney()
	money.text = str(m) + " $"
