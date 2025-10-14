extends CanvasLayer
class_name EscapePopUp

var mapUrl: String = "res://core/map/Map.tscn"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(mapUrl)
