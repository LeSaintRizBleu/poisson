class_name FishingBar
extends MarginContainer

@onready var green_zones: Control = $GreenZones
@onready var slider: FishingSlider = $Slider

var green_zones_list: Array = []

var fish_info: FishInfo
var difficulty: int
var bar_size: int
var bar_speed: float

signal success
signal fail

func init(fish_info_init: FishInfo) -> void:
	fish_info = fish_info_init
	difficulty = fish_info.get_difficulty()
	bar_size = fish_info.get_bar_size()
	bar_speed = fish_info.get_bar_speed()
	add_green_zone()
	slider.set_speed(bar_speed)
	slider.start_movement()

func add_green_zone() -> void:
	if difficulty == 1:
		_add_sym_green_zone()
	if difficulty == 2:
		_add_random_green_zone()

func _add_sym_green_zone() -> void:
	var pos1: int = randi_range(0, 250 - bar_size)
	var pos2: int = 500 - bar_size - pos1
	_add_green_zone_to_slider(pos1)
	_add_green_zone_to_slider(pos2)

func _add_random_green_zone() -> void:
	var pos: int = randi_range(0, 500 - bar_size)
	_add_green_zone_to_slider(pos)

func _add_green_zone_to_slider(pos: int) -> void:
	green_zones_list.append({"pos": pos, "size": bar_size})
	var color_rect: ColorRect = ColorRect.new()
	color_rect.color = Color.WEB_GREEN
	color_rect.size = Vector2(30, bar_size)
	color_rect.position = Vector2(0, pos)
	green_zones.add_child(color_rect)

func clear_green_zone() -> void:
	green_zones_list = []
	for node in green_zones.get_children():
		green_zones.remove_child(node)

func reload() -> void:
	clear_green_zone()
	add_green_zone()

func _on_slider_bar_stop(slider_position: float) -> void:
	check_slider_position(slider_position)

func check_slider_position(slider_position: float) -> void:
	for zone: Dictionary in green_zones_list:
		if slider_position > zone["pos"] && slider_position < zone["pos"]+zone["size"]:
			success_bar()
			return
	fail_bar()

func success_bar() -> void:
	success.emit()
	await get_tree().create_timer(0.25).timeout
	reload()

func fail_bar() -> void:
	fail.emit()
	await get_tree().create_timer(0.25).timeout
	reload()

func stop() -> void:
	slider.stop()
