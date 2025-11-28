extends Node2D
class_name Fishing

@onready var slider: Node2D = $Bar/Slider
@onready var green: Node2D = $Green
@onready var energy_bar: ProgressBar = $EnergyBar
@onready var capture_bar: ProgressBar = $CaptureBar

var down_target: Vector2 = Vector2(15, 495)
var up_target: Vector2 = Vector2(15, 5)

var tween: Tween
var is_moving: bool = false
var moving_up: bool = true

var green_zones: Array = []

var energy: float = 100.0
var rate: float = 1.0
var strength: float = 30.0
var capture: float = 0.0

var fish: String
var difficulty: int
var bar_speed: float
var bar_size: int
var fish_info: FishInfo

var catch_popup: PackedScene = preload("res://core/ui/popup/CatchPopUp.tscn")
var escape_popup: PackedScene = preload("res://core/ui/popup/EscapePopUp.tscn")

func _process(delta: float) -> void:
	_process_energy(delta)

func _process_energy(delta: float) -> void:
	if !is_moving: return
	energy -= rate * delta
	energy = clampf(energy, 0.0, 100.0)
	capture = clampf(capture, 0.0, 100.0)
	energy_bar.value = energy
	capture_bar.value = capture
	if energy <= 0:
		escape()
	if capture >= 100:
		catch()

func _ready() -> void:
	fish = get_random_fish()
	var url: String = "res://resources/fishesInfo/"+fish+".tres"
	fish_info = load(url)
	difficulty = fish_info.get_difficulty()
	bar_size = fish_info.get_bar_size()
	bar_speed = fish_info.get_bar_speed()
	add_green_zone()
	start_movement()

func get_random_fish() -> String:
	if randi() % 2 == 0:
		return "test1"
	else:
		return "test2"

func catch() -> void:
	_clear_green_zone()
	stop_movement()
	var instance: CatchPopUp = catch_popup.instantiate()
	instance.fish_info = fish_info
	add_child(instance)

func escape() -> void:
	_clear_green_zone()
	stop_movement()
	var instance: EscapePopUp = escape_popup.instantiate()
	add_child(instance)

func add_green_zone() -> void:
	if difficulty == 1:
		add_sym_green_zone()
	if difficulty == 2:
		add_random_green_zone()

func add_sym_green_zone() -> void:
	var pos1: int = randi_range(0, 250 - bar_size)
	var pos2: int = 500 - bar_size - pos1
	_add_green_zone_to_slider(pos1)
	_add_green_zone_to_slider(pos2)

func add_random_green_zone() -> void:
	var pos: int = randi_range(0, 500 - bar_size)
	_add_green_zone_to_slider(pos)

func _add_green_zone_to_slider(pos: int) -> void:
	green_zones.append({"pos": pos, "size": bar_size})
	var color_rect: ColorRect = ColorRect.new()
	color_rect.color = Color.WEB_GREEN
	color_rect.size = Vector2(30, bar_size)
	color_rect.position = Vector2(1000, 74 + pos)
	green.add_child(color_rect)

func _clear_green_zone() -> void:
	green_zones = []
	for zone in green.get_children():
		green.remove_child(zone)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed:
			if is_moving:
				stop_movement()
				check_slider()

func check_slider() -> void:
	for zone: Dictionary in green_zones:
		if slider.position.y > zone["pos"] && slider.position.y < zone["pos"]+zone["size"]:
			success()
			return
	fail()

func success() -> void:
	energy += 25
	capture += strength
	await get_tree().create_timer(0.25).timeout
	_clear_green_zone()
	add_green_zone()
	await get_tree().create_timer(0.25).timeout
	start_movement()

func fail() -> void:
	energy -= 25
	await get_tree().create_timer(0.25).timeout
	_clear_green_zone()
	add_green_zone()
	await get_tree().create_timer(0.25).timeout
	start_movement()

func start_movement() -> void:
	if tween and tween.is_valid():
		tween.kill()

	is_moving = true
	tween = create_tween()
	tween.set_loops(0)

	var target: Vector2 = up_target if moving_up else down_target
	var full_distance: float = up_target.distance_to(down_target)
	var current_distance: float = slider.position.distance_to(target)
	var move_duration: float = bar_speed * (current_distance / full_distance)

	tween.tween_property(slider, "position", target, move_duration)
	tween.tween_callback(_switch_direction)
	tween.tween_callback(start_movement)

func _switch_direction() -> void:
	moving_up = !moving_up

func stop_movement() -> void:
	is_moving = false
	if tween and tween.is_running():
		tween.pause()
