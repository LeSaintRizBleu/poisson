extends Node2D
class_name Aquarium

var tank_ghost: PackedScene = preload("res://core/structures/tank/TankGhost.tscn")
var wall_ghost: PackedScene = preload("res://core/structures/wall/MainWallGhost.tscn")
var tank: PackedScene = preload("res://core/structures/tank/Tank.tscn")
var visitor: PackedScene = preload("res://core/visitor/Visitor.tscn")

@onready var ghosts: Node2D = $Ghosts
@onready var aquariums: Node2D = $NavigationRegion2D/Aquariums
@onready var visitors: Node2D = $NavigationRegion2D/Visitors
@onready var hud: AquariumHUD = $AquariumHud
@onready var grid: Sprite2D = $Grid
@onready var navigation_region: NavigationRegion2D = $NavigationRegion2D

func _ready() -> void:
	init()
	for i in range (20):
		add_visitor()

func _process(_delta: float) -> void:
	var show_grid: bool = Context.ghost_on
	var shader_material: ShaderMaterial = grid.material as ShaderMaterial
	shader_material.set_shader_parameter("show_sprite", show_grid)
	if show_grid:
		var ghost: Node2D = ghosts.get_child(0)
		shader_material.set_shader_parameter("mouse_position", ghost.global_position)

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
			aquariums.add_child(instance)
	rebake()

func create_tank_ghost(type: Structure) -> void:
	if Save.get_money() < type.get_price():
		add_error_popup("Vous n'avez pas assez d'argent, l'aquarium coute %s " + str(type.get_price()) + " $")
	elif ghosts.get_child_count() == 0:
		var instance: TankGhost = tank_ghost.instantiate()
		instance.type = type
		ghosts.add_child(instance)
		instance.create_tank.connect(create_tank)
		instance.error.connect(add_error_popup)

func rebake() -> void:
	if !navigation_region.is_baking():
		navigation_region.bake_navigation_polygon()

func add_visitor() -> void:
	var instance: Visitor = visitor.instantiate()
	instance.targets = aquariums.get_children()
	visitors.add_child(instance)

func create_tank(pos: Vector2, type: AquariumType) -> void:
	var id: String = Save.add_aquirium(pos, type.get_id())
	Save.save_data()
	var instance: Tank = tank.instantiate()
	instance.id = id
	instance.global_position = pos
	instance.type = type
	aquariums.add_child(instance)
	rebake()

func add_error_popup(content: String) -> void:
	hud.add_error_popup(content)

func create_wall_ghost(type: Structure) -> void:
	if Save.get_money() < type.get_price():
		add_error_popup("Vous n'avez pas assez d'argent, l'aquarium coute %s " + str(type.get_price()) + " $")
	elif ghosts.get_child_count() == 0:
		var instance: MainWallGhost = wall_ghost.instantiate()
		instance.type = type
		ghosts.add_child(instance)
		instance.create_tank.connect(create_tank)
		instance.error.connect(add_error_popup)

func _on_aquarium_hud_create_structure(type: Structure) -> void:
	if type.is_tank():
		create_tank_ghost(type)
	else:
		create_wall_ghost(type)
