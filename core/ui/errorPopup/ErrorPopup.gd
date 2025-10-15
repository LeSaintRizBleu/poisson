extends Container
class_name ErrorPopup

var content: String = ""

var mouse_in: bool = false

@onready var content_label: Label = $MarginContainer/VBoxContainer/Content
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	content_label.text = content

func destroy() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	destroy()

func _on_mouse_entered() -> void:
	mouse_in = true
	color_rect.color = Color("ff0000")

func _on_mouse_exited() -> void:
	mouse_in = false
	color_rect.color = Color("c80000")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && mouse_in:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			destroy()
