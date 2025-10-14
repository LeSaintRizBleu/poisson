extends Container
class_name ErrorPopup

var content: String = ""

var mouseIn: bool = false

@onready var contentLabel: Label = $MarginContainer/VBoxContainer/Content
@onready var colorRect: ColorRect = $ColorRect

func _ready() -> void:
	contentLabel.text = content

func destroy() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	destroy()

func _on_mouse_entered() -> void:
	mouseIn = true
	colorRect.color = Color("ff0000")

func _on_mouse_exited() -> void:
	mouseIn = false
	colorRect.color = Color("c80000")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && mouseIn:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			destroy()
