extends CanvasLayer
class_name TankHUD

var aquarium_url: String = "res://core/aquarium/Aquarium.tscn"
@onready var error_popup_manager: ErrorPopupManager  = $ErrorPopupManager

signal add_fish
signal delete_tank

func _on_close_pressed() -> void:
	quit()

func _on_add_fish_pressed() -> void:
	add_fish.emit()

func _on_delete_pressed() -> void:
	delete_tank.emit()

func quit() -> void:
	Context.tank_id = ""
	get_tree().change_scene_to_file(aquarium_url)

func add_error_popup(content: String) -> void:
	error_popup_manager.add_popup(content)
