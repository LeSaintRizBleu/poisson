extends Control
class_name FishingSlider

@onready var player: AnimationPlayer = $AnimationPlayer
@onready var moving_part: Control = $MovingPart

var is_moving: bool = false
var can_move: bool = true
var speed: float

signal bar_stop

func _ready() -> void:
	player.play("move")
	player.active = is_moving

func start_movement() -> void:
	if can_move:
		is_moving = true
		player.active = is_moving

func stop_movement() -> void:
	is_moving = false
	player.active = is_moving

func _check_slider() -> void:
	bar_stop.emit(moving_part.position.y)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed && is_moving:
			if is_moving:
				stop_movement()
				_check_slider()
				await get_tree().create_timer(0.5).timeout
				start_movement()

func stop() -> void:
	can_move = false
	stop_movement()

func set_speed(slider_speed: float) -> void:
	speed = slider_speed
	player.speed_scale = speed
