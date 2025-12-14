extends CanvasLayer
class_name Fishing

@onready var energy_bar: ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/EnergyBar
@onready var capture_bar: ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/CaptureBar
@onready var fishing_bar: FishingBar = $MarginContainer/HBoxContainer/FishingBar

var green_zones: Array = []
var is_moving: bool = true

var energy: float = 100.0
var rate: float = 1.0
var strength: float = 30.0
var capture: float = 0.0

var fish_info: FishInfo

var catch_popup: PackedScene = preload("res://core/ui/popup/CatchPopUp.tscn")
var escape_popup: PackedScene = preload("res://core/ui/popup/EscapePopUp.tscn")

func _ready() -> void:
	var fish: String = get_random_fish()
	var url: String = "res://resources/fishesInfo/" + fish + ".tres"
	fish_info = load(url)
	fishing_bar.init(fish_info)

func _process(delta: float) -> void:
	is_moving = fishing_bar.slider.is_moving
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

func get_random_fish() -> String:
	if randi() % 2 == 0:
		return "test1"
	else:
		return "test2"

func catch() -> void:
	fishing_bar.stop()
	var instance: CatchPopUp = catch_popup.instantiate()
	instance.fish_info = fish_info
	add_child(instance)

func escape() -> void:
	fishing_bar.stop()
	var instance: EscapePopUp = escape_popup.instantiate()
	add_child(instance)


func _on_fishing_bar_fail() -> void:
	energy -= 25

func _on_fishing_bar_success() -> void:
	energy += 25
	capture += strength
