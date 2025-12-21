class_name Visitor
extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed: float = 250.0
var things_to_visit: int

var targets: Array[Node]
var is_waiting: bool = false

func _ready() -> void:
	things_to_visit = randi_range(5, 10)
	var speed_scale: float = randf_range(0.5, 1.5)
	speed *= speed_scale
	animation_player.speed_scale = speed_scale
	set_new_target()

func set_new_target() -> void:
	if targets.is_empty():
		return
	var random_target: Tank = targets.pick_random()
	nav_agent.target_position = random_target.global_position

func _physics_process(_delta: float) -> void:
	if is_waiting:
		return

	if nav_agent.is_navigation_finished():
		start_admiring_fish()
		return

	var current_pos: Vector2 = global_position
	var next_path_pos: Vector2 = nav_agent.get_next_path_position()
	var direction: Vector2 = current_pos.direction_to(next_path_pos)	
	velocity = direction * speed
	move_and_slide()

func start_admiring_fish() -> void:
	is_waiting = true
	animation_player.play("RESET")
	velocity = Vector2.ZERO
	things_to_visit -= 1

	var wait_time: float = randf_range(2.0, 4.0)
	await get_tree().create_timer(wait_time).timeout

	is_waiting = false
	animation_player.play("move")
	if things_to_visit > 0:
		set_new_target()
	else:
		kill()

func kill() -> void:
	queue_free()
