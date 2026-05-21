extends CanvasLayer
class_name FishingContainer

@onready var capture_bar: ProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/CaptureBar
@onready var energy_bar: ProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/EnergyBar
@onready var game_container: MarginContainer = $MarginContainer/VBoxContainer/GameContainer

var energy: float = 100.0
var capture: float = 0.0

var rate: float = 1.0
var strength: float = 30.0
var escape_rate: float = 10.0

var fish_info: FishInfo
var is_pause: bool = false

var catch_popup: PackedScene = preload("res://core/ui/popup/CatchPopUp.tscn")
var escape_popup: PackedScene = preload("res://core/ui/popup/EscapePopUp.tscn")

var minigames: Array = ["res://core/fishing/slider/SliderGame.tscn"]
var minigame: FishingMinigame

func _ready() -> void:
	var game_url: String = minigames.pick_random()
	var temp: PackedScene = load(game_url)
	minigame = temp.instantiate()
	minigame.success.connect(_on_success)
	minigame.fail.connect(_on_fail)
	game_container.add_child(minigame)

	var fish: String = get_random_fish()
	var url: String = "res://resources/fishesInfo/" + fish + ".tres"
	fish_info = load(url)

	minigame.start()

func _process(delta: float) -> void:
	_process_energy(delta)

func _process_energy(delta: float) -> void:
	if is_pause: return
	energy -= rate * delta
	energy = clampf(energy, 0.0, 100.0)
	capture = clampf(capture, 0.0, 200.0)
	capture -= escape_rate * delta
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
	minigame.stop()
	is_pause = true
	var instance: CatchPopUp = catch_popup.instantiate()
	instance.fish_info = fish_info
	add_child(instance)

func escape() -> void:
	minigame.stop()
	is_pause = true
	var instance: EscapePopUp = escape_popup.instantiate()
	add_child(instance)

func _on_fail() -> void:
	energy -= escape_rate

func _on_success() -> void:
	capture += strength
