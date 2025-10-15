extends Node2D
class_name Tank

var mouse_in: bool = false
var id: String
var type: String

@onready var sprite: Sprite2D = $Sprite2D

var visualisation_url: String = "res://core/visualisation/Visualisation.tscn"

func _ready() -> void:
	_get_color_for_type()

func destroy() -> void:
	queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_in && mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			create_visualisation()

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false

func create_visualisation() -> void:
	if Context.ghost_on == false:
		Context.tank_id = id
		get_tree().change_scene_to_file(visualisation_url)

func _get_color_for_type() -> void:
	match type:
		"small":
			sprite.modulate = Color("#00ff00")
		"medium":
			sprite.modulate = Color("#0000ff")
		"big":
			sprite.modulate = Color("#ff0000")
