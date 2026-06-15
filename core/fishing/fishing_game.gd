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

var fish: FishInfo
var is_pause: bool = false

var catch_popup: PackedScene = preload("res://core/ui/popup/CatchPopUp.tscn")
var escape_popup: PackedScene = preload("res://core/ui/popup/EscapePopUp.tscn")

@export var minigames: Array[PackedScene]

var minigame: FishingMinigame

func _ready() -> void:
	fish = Context.area.get_random_fish()
	var game: PackedScene = minigames.pick_random()
	minigame = game.instantiate()
	minigame.success.connect(_on_success)
	minigame.fail.connect(_on_fail)
	game_container.add_child(minigame)
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

func catch() -> void:
	minigame.stop()
	is_pause = true
	var instance: CatchPopUp = catch_popup.instantiate()
	instance.fish_info = fish
	instance.rarity = Context.area.rarity
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
