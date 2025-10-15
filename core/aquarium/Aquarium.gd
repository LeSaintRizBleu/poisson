extends Node2D
class_name Aquarium

var tank_ghost: PackedScene = preload("res://core/tank/TankGhost.tscn")
var tank: PackedScene = preload("res://core/tank/Tank.tscn")

@onready var ghosts: Node2D = $Ghosts
@onready var structures: Node2D = $Structures
@onready var hud: AquariumHUD = $AquariumHud

func _ready() -> void:
	init()

func init() -> void:
	var data: Dictionary = Save.get_aquariums()
	for id: String in data.keys():
		var aquarium: Dictionary = data[id]
		if !aquarium.is_empty():
			var instance: Tank = tank.instantiate()
			var x: float = aquarium["x"]
			var y: float = aquarium["y"]
			var pos: Vector2 = Vector2(x, y)
			instance.type = aquarium["type"]
			instance.global_position = pos
			instance.id = id
			structures.add_child(instance)

func create_tank_ghost(type: String) -> void:
	if Save.get_money() < 100: #TODO fix  mettre prix reel de l'aquarium
		add_error_popup("Vous n'avez pas assez d'argent, l'aquarium coute 100 $")
	elif ghosts.get_child_count() == 0:
		var instance: TankGhost = tank_ghost.instantiate()
		instance.type = type
		ghosts.add_child(instance)
		instance.create_tank.connect(create_tank)
		instance.error.connect(add_error_popup)

func create_tank(pos: Vector2, type: String) -> void:
	var id: String = Save.add_aquirium(pos, type)
	Save.save_data()
	var instance: Tank = tank.instantiate()
	instance.id = id
	instance.global_position = pos
	instance.type = type
	structures.add_child(instance)

func _on_aquarium_hud_create_tank(type: String) -> void:
	create_tank_ghost(type)

func add_error_popup(content: String) -> void:
	hud.add_error_popup(content)
