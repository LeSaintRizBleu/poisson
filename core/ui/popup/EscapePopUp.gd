extends CanvasLayer
class_name EscapePopUp

var map_url: String = "res://core/map/Map.tscn"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(map_url)
