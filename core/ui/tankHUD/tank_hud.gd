extends CanvasLayer
class_name TankHUD

var aquariumUrl: String = "res://core/aquarium/Aquarium.tscn"
@onready var errorPopupManager: ErrorPopupManager  = $ErrorPopupManager

signal addFish
signal deleteTank

func _on_close_pressed() -> void:
	quit()

func _on_add_fish_pressed() -> void:
	addFish.emit()

func _on_delete_pressed() -> void:
	deleteTank.emit()

func quit() -> void:
	Context.tankId = ""
	get_tree().change_scene_to_file(aquariumUrl)

func errorPopup(content: String) -> void:
	errorPopupManager.addPopup(content)
