extends Node2D
class_name Tank

var mouse_in: bool = false
var id: String

var visualisationUrl: String = "res://core/visualisation/Visualisation.tscn"

func destroy() -> void:
	queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_in && mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			createVisualisation()

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false

func createVisualisation() -> void:
	if Context.ghostOn == false:
		Context.tankId = id
		get_tree().change_scene_to_file(visualisationUrl)
