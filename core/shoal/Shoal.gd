extends Node2D
class_name Shoal

@export var speed: float = 50.0
@export var aquarium_width: float = 1152
@export var aquarium_height: float = 658
@export var max_offset:float = 50.0

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	direction = direction.rotated(randf_range(-PI, PI))

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	check_bound()

	if randf() < 0.025:
		var rotation_angle: float = randf_range(-PI/6, PI/6)
		direction = direction.rotated(rotation_angle)

	for node in get_children():
		if node is Fish:
			var fish : Fish = node
			fish.update_fish(delta, global_position, direction)

func check_bound() -> void:
	var new_direction: Vector2 = direction
	
	if global_position.x < 0 + max_offset:
		new_direction = new_direction.bounce(Vector2.RIGHT)
		global_position.x = 0 + max_offset
	elif global_position.x > aquarium_width - max_offset:
		new_direction = new_direction.bounce(Vector2.LEFT)
		global_position.x = aquarium_width - max_offset
	
	if global_position.y < 0 + max_offset:
		new_direction = new_direction.bounce(Vector2.DOWN)
		global_position.y = 0 + max_offset
	elif global_position.y > aquarium_height - max_offset:
		new_direction = new_direction.bounce(Vector2.UP)
		global_position.y = aquarium_height - max_offset

	direction = new_direction.normalized()

func init(fish: String, width: float, height: float) -> void:
	aquarium_width = width
	aquarium_height = height
	max_offset = Infos.get_max_offset(fish) + 25
	speed = Infos.get_fishes_info(fish)["speed"]
