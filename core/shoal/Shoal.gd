extends Node2D
class_name Shoal

var speed: float
var aquarium_width: float
var aquarium_height: float

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
	
	if global_position.x < 0:
		new_direction = new_direction.bounce(Vector2.RIGHT)
		global_position.x = 0
	elif global_position.x > aquarium_width:
		new_direction = new_direction.bounce(Vector2.LEFT)
		global_position.x = aquarium_width
	
	if global_position.y < 0:
		new_direction = new_direction.bounce(Vector2.DOWN)
		global_position.y = 0
	elif global_position.y > aquarium_height:
		new_direction = new_direction.bounce(Vector2.UP)
		global_position.y = aquarium_height

	direction = new_direction.normalized()

func init(fish_info: FishInfo, width: float, height: float) -> void:
	aquarium_width = width
	aquarium_height = height
	speed = fish_info.get_speed()
