extends Node2D
class_name Aquarium

var tank_ghost: PackedScene = preload("res://core/tank/TankGhost.tscn")
var tank: PackedScene = preload("res://core/tank/Tank.tscn")

@onready var ghosts: Node2D = $Ghosts
@onready var structures: Node2D = $Structures
@onready var hud: AquariumHUD = $AquariumHud
@onready var grid: Sprite2D = $Grid

func _ready() -> void:
	init()

func _process(_delta: float) -> void:
	var show_grid: bool = Context.ghost_on
	var shader_material: ShaderMaterial = grid.material as ShaderMaterial
	shader_material.set_shader_parameter("show_sprite", show_grid)
	if show_grid:
		shader_material.set_shader_parameter("mouse_position", get_global_mouse_position())

func init() -> void:
	var data: Dictionary = Save.get_aquariums()
	for id: String in data.keys():
		var aquarium: Dictionary = data[id]
		if !aquarium.is_empty():
			var instance: Tank = tank.instantiate()
			var x: float = aquarium["x"]
			var y: float = aquarium["y"]
			var pos: Vector2 = Vector2(x, y)
			var url: String = "res://resources/aquariumTypes/"+aquarium["type"]+".tres"
			instance.type = load(url)
			instance.global_position = pos
			instance.id = id
			structures.add_child(instance)

func create_tank_ghost(type: AquariumType) -> void:
	if Save.get_money() < type.get_price():
		add_error_popup("Vous n'avez pas assez d'argent, l'aquarium coute 100 $")
	elif ghosts.get_child_count() == 0:
		var instance: TankGhost = tank_ghost.instantiate()
		instance.type = type
		ghosts.add_child(instance)
		instance.create_tank.connect(create_tank)
		instance.error.connect(add_error_popup)

func create_tank(pos: Vector2, type: AquariumType) -> void:
	var id: String = Save.add_aquirium(pos, type.get_id())
	Save.save_data()
	var instance: Tank = tank.instantiate()
	instance.id = id
	instance.global_position = pos
	instance.type = type
	structures.add_child(instance)

func _on_aquarium_hud_create_tank(type: AquariumType) -> void:
	create_tank_ghost(type)

func add_error_popup(content: String) -> void:
	hud.add_error_popup(content)
