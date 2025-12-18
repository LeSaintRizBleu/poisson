extends Node2D

@onready var line: Line2D = $Line2D
@onready var tip: Marker2D = $Tip
@onready var hook: Marker2D = $Hook

@export var slack_amount: float = 300.0
@export var resolution: int = 10
@export var physics_speed: float = 2.0 

var current_control_point: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	hook.global_position = get_global_mouse_position()
	draw_curved_line(delta)

func draw_curved_line(delta: float) -> void:
	line.clear_points()

	var start_pos: Vector2 = tip.global_position
	var end_pos: Vector2 = hook.global_position
	var mid_point: Vector2 = (start_pos + end_pos) / 2.0

	var dist: float = start_pos.distance_to(end_pos)
	var current_slack: float = max(0, slack_amount - (dist * 0.1)) 
	var target_control_point: Vector2 = mid_point + Vector2(0, current_slack)
	
	if current_control_point == Vector2.ZERO:
		current_control_point = target_control_point
	current_control_point = current_control_point.lerp(target_control_point, physics_speed * delta)
	
	for i in range(resolution + 1):
		var t: float = i / float(resolution)
		var p: Vector2 = _quadratic_bezier(start_pos, current_control_point, end_pos, t)
		line.add_point(line.to_local(p))

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var q0: Vector2 = p0.lerp(p1, t)
	var q1: Vector2 = p1.lerp(p2, t)
	return q0.lerp(q1, t)
