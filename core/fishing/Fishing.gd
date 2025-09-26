extends Node2D
class_name Fishing

@onready var slider: Node2D = $Bar/Slider
@onready var green: Node2D = $Green
@onready var energyBar: ProgressBar = $EnergyBar
@onready var captureBar: ProgressBar = $CaptureBar

var downTarget: Vector2 = Vector2(15, 495)
var upTarget: Vector2 = Vector2(15, 5)

var tween: Tween
var isMoving: bool = false
var moving_up: bool = true

var greenZones: Array = []

var energy: float = 100.0
var rate: float = 1.0
var strength: float = 30.0
var capture: float = 0.0

var fish: String
var duration: float
var difficulty: int
var size: int

var catchPopUp: PackedScene = preload("res://core/ui/popup/CatchPopUp.tscn")
var escapePopUp: PackedScene = preload("res://core/ui/popup/EscapePopUp.tscn")

func _process(delta: float) -> void:
	processEnergy(delta)

func processEnergy(delta: float) -> void:
	if !isMoving: return
	energy -= rate * delta
	energy = clampf(energy, 0.0, 100.0)
	capture = clampf(capture, 0.0, 100.0)
	energyBar.value = energy
	captureBar.value = capture
	if energy <= 0:
		escape()
	if capture >= 100:
		catch()

func _ready() -> void:
	fish = Context.fish
	difficulty = Infos.get_fishes_info(fish)["difficulty"]
	size = Infos.get_fishes_info(fish)["size"]
	duration = Infos.get_fishes_info(fish)["duration"]
	addGreenZone()
	startMovement()

func catch() -> void:
	clearGreenZone()
	stopMovement()
	var instance: CatchPopUp = catchPopUp.instantiate()
	instance.fish = fish
	add_child(instance)

func escape() -> void:
	clearGreenZone()
	stopMovement()
	var instance: EscapePopUp = escapePopUp.instantiate()
	add_child(instance)

func addGreenZone() -> void:
	if difficulty == 1:
		addSymGreenZone()
	if difficulty == 2:
		addRandomGreenZone()

func addSymGreenZone() -> void:
	var pos1: int = randi_range(0, 250 - size)
	var pos2: int = 500 - size - pos1
	addGreenZoneToSlider(pos1)
	addGreenZoneToSlider(pos2)

func addRandomGreenZone() -> void:
	var pos: int = randi_range(0, 500 - size)
	addGreenZoneToSlider(pos)

func addGreenZoneToSlider(pos: int) -> void:
	greenZones.append({"pos": pos, "size": size})
	var color_rect: ColorRect = ColorRect.new()
	color_rect.color = Color.WEB_GREEN
	color_rect.size = Vector2(30, size)
	color_rect.position = Vector2(1000, 74 + pos)
	green.add_child(color_rect)

func clearGreenZone() -> void:
	greenZones = []
	for zone in green.get_children():
		green.remove_child(zone)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed && isMoving:
			stopMovement()
			checkSlider()

func checkSlider() -> void:
	for zone: Dictionary in greenZones:
		if slider.position.y > zone["pos"] && slider.position.y < zone["pos"]+zone["size"]:
			success()
			return
	fail()

func success() -> void:
	energy += 25
	capture += strength
	await get_tree().create_timer(0.25).timeout
	clearGreenZone()
	addGreenZone()
	await get_tree().create_timer(0.25).timeout
	startMovement()

func fail() -> void:
	energy -= 25
	await get_tree().create_timer(0.25).timeout
	clearGreenZone()
	addGreenZone()
	await get_tree().create_timer(0.25).timeout
	startMovement()

func startMovement() -> void:
	if tween and tween.is_valid():
		tween.kill()

	isMoving = true
	tween = create_tween()
	tween.set_loops(0)

	var target: Vector2 = upTarget if moving_up else downTarget
	var full_distance: float = upTarget.distance_to(downTarget)
	var current_distance: float = slider.position.distance_to(target)
	var move_duration: float = duration * (current_distance / full_distance)

	tween.tween_property(slider, "position", target, move_duration)
	tween.tween_callback(switch_direction)
	tween.tween_callback(startMovement)

func switch_direction() -> void:
	moving_up = !moving_up

func stopMovement() -> void:
	isMoving = false
	if tween and tween.is_running():
		tween.pause()
