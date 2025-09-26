extends Node2D
class_name Aquarium

var tankGhost: PackedScene = preload("res://core/tank/TankGhost.tscn")
var tank: PackedScene = preload("res://core/tank/Tank.tscn")

@onready var ghosts: Node2D = $Ghosts
@onready var structures: Node2D = $Structures
@onready var hud: AquariumHUD = $AquariumHud

func _ready() -> void:
	init()

func init() -> void:
	var data: Dictionary = Save.getAquariums()
	for id: String in data.keys():
		var aquarium: Dictionary = data[id]
		if !aquarium.is_empty():
			var instance: Tank = tank.instantiate()
			var x: float = aquarium["x"]
			var y: float = aquarium["y"]
			var pos: Vector2 = Vector2(x, y)
			instance.global_position = pos
			instance.id = id
			structures.add_child(instance)

func createTankGhost() -> void:
	if Save.getMoney() < 100:
		errorPopup("Vous n'avez pas assez d'argent, l'aquarium coute 100 $")
	elif ghosts.get_child_count() == 0:
		var instance: TankGhost = tankGhost.instantiate()
		ghosts.add_child(instance)
		instance.createTank.connect(createTank)
		instance.error.connect(errorPopup)

func createTank(pos: Vector2) -> void:
	hud.update()
	var id: String = Save.addAquirium(pos)
	Save.saveData()
	var instance: Tank = tank.instantiate()
	instance.id = id
	instance.global_position = pos
	structures.add_child(instance)

func _on_aquarium_hud_create_tank() -> void:
	createTankGhost()

func errorPopup(content: String) -> void:
	hud.errorPopup(content)
