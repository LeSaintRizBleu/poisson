extends FishingMinigame
class_name TargetGame

var target: PackedScene = preload("res://core/fishing/target/Target.tscn")
var can_add_target: bool = true

var size: Vector2 = Vector2(1112.0, 483.0)
var offset: int = 30

@onready var target_container: Control = $Targets

var current_target: Target

func start() -> void:
	add_target()

func stop() -> void:
	can_add_target = false
	current_target.stop()

func add_target() -> void:
	if !can_add_target: return
	var x: float = randf_range(0.0, size.x - 2*offset)
	var y: float = randf_range(0.0, size.y - 2*offset)
	var pos: Vector2 = Vector2(x, y) + Vector2(offset, offset)
	var instance: Target = target.instantiate()
	instance.position = pos
	instance.click.connect(_process_click)
	target_container.add_child(instance)
	current_target = instance

func _process_click(is_in: bool) -> void:
	if is_in:
		success.emit()
		add_target()
	else:
		fail.emit()
