extends Node2D
class_name Visualisation

@export var width: float = 1152.0
@export var height: float = 658.0

@onready var shoals: Node2D = $Shoals
@onready var hud: TankHUD = $TankHud

var fishes_in: Dictionary = {}

var shoal: PackedScene = preload("res://core/shoal/Shoal.tscn")
var fish: PackedScene = preload("res://core/fish/Fish.tscn")
var tank_inventory: PackedScene = preload("res://core/ui/inventory/TankInventory.tscn")

var id: String
var type: AquariumType

var offset: float = 100.0

var aquarium_url: String = "res://core/aquarium/Aquarium.tscn"

func _ready() -> void:
	id = Context.tank_id
	type = Context.type
	reload_fishes()

func reload_fishes() -> void:
	clear()
	fishes_in = Save.get_fishes_in_aquarium(id)
	for fish_type: String in fishes_in:
		var url: String = "res://resources/fishesInfo/"+fish_type+".tres"
		var fish_info: FishInfo = load(url)
		var n: int = fishes_in[fish_type]
		var max_fishes: int = fish_info.get_max_in_shoal()
		var shoals_number: int = ceil(float(n) / max_fishes)
		for s: int in range(shoals_number):
			var current_soal: Shoal = create_shoal(fish_info)
			for i: int in range( min(max_fishes, n) ):
				create_fish(current_soal, fish_info)
			n -= max_fishes

func clear() -> void:
	for child in shoals.get_children():
		shoals.remove_child(child)

func create_shoal(fish_info: FishInfo) -> Shoal:
	var shoal_instance: Shoal = shoal.instantiate()
	var x: float = randf_range(offset, width - offset)
	var y: float = randf_range(offset, height - offset)
	shoal_instance.global_position = Vector2(x, y)
	shoals.add_child(shoal_instance)
	shoal_instance.init(fish_info, width, height)
	return shoal_instance

func create_fish(currennt_shoal: Shoal, fish_info: FishInfo) -> void:
	var fish_instance: Fish = fish.instantiate()
	currennt_shoal.add_child(fish_instance)
	fish_instance.init(fish_info)

func quit() -> void:
	Context.tank_id = ""
	get_tree().change_scene_to_file(aquarium_url)

func _on_tank_hud_add_fish() -> void:
	var inventoryInstance: TankInventory = tank_inventory.instantiate()
	inventoryInstance.id = id
	inventoryInstance.type = type
	add_child(inventoryInstance)
	inventoryInstance.reload_fishes.connect(reload_fishes)


func _on_tank_hud_delete_tank() -> void:
	var data: Dictionary = Save.get_fishes_in_aquarium(id)
	if data.is_empty():
		Save.remove_aquirium(id)
		Save.save_data()
		quit()
	else:
		hud.add_error_popup("L'aquarium n'est pas vide, il ne peut pas être supprimer.")
