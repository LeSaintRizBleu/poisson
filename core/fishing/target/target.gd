extends Node2D
class_name Target

var mouse_in: bool = false
var is_stopped: bool = false

signal click

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false

func _input(event: InputEvent) -> void:
	if is_stopped: return
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			click.emit(mouse_in)
			if mouse_in:
				destroy()

func destroy() -> void:
	queue_free()

func stop() -> void:
	is_stopped = true
