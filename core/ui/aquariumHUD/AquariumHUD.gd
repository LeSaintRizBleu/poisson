extends CanvasLayer
class_name AquariumHUD

var map_url: String = "res://core/map/Map.tscn"

@onready var error_popup_manager: ErrorPopupManager = $ErrorPopupManager

@onready var shop_button: Button = $MarginContainer/Shop
@onready var map_button: Button = $MarginContainer/Map

@onready var shop: AquariumShop = $AquariumShop

var is_shop_open: bool = false

signal create_tank

func _on_map_pressed() -> void:
	if randi() % 2 == 0:
		Context.fish = "test1"
	else:
		Context.fish = "test2"
	get_tree().change_scene_to_file(map_url)


func _on_shop_pressed() -> void:
	open_shop()
	
func add_error_popup(content: String) -> void:
	error_popup_manager.add_popup(content)

func open_shop() -> void:
	is_shop_open = true
	shop.open()
	shop_button.hide()
	map_button.hide()

func close_shop() -> void:
	is_shop_open = false
	shop.close()
	shop_button.show()
	map_button.show()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT && mouse_event.pressed:
			if is_shop_open:
				close_shop()

func _on_aquarium_shop_create_tank(type: String) -> void:
	close_shop()
	create_tank.emit(type)
