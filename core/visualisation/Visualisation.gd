extends Node2D
class_name Visualisation

@export var fishesIn: Dictionary = {}
@export var width: float = 1152.0
@export var height: float = 658.0

@onready var shoals: Node2D = $Shoals
@onready var hud: TankHUD = $TankHud

var shoal: PackedScene = preload("res://core/shoal/Shoal.tscn")
var fish: PackedScene = preload("res://core/fish/Fish.tscn")
var tankInventory: PackedScene = preload("res://core/ui/inventory/TankInventory.tscn")
var id: String

var offset: float = 100.0

var aquariumUrl: String = "res://core/aquarium/Aquarium.tscn"

func _ready() -> void:
	id = Context.tankId
	reload_fishes()

func reload_fishes() -> void:
	clear()
	fishesIn = Save.getFishesInAquarium(id)
	for fishType: String in fishesIn:
		var data: Dictionary = Infos.get_fishes_info(fishType)
		var n: int = fishesIn[fishType]
		var maxFishes: int = data["max_in_shoals"]
		var shoalsNumber: int = ceil(float(n) / maxFishes)
		for s: int in range(shoalsNumber):
			var current_soal: Shoal = create_shoal(fishType)
			for i: int in range( min(maxFishes, n) ):
				create_fish(current_soal, fishType)
			n -= maxFishes

func clear() -> void:
	for child in shoals.get_children():
		shoals.remove_child(child)

func create_shoal(fish_type: String) -> Shoal:
	var shoal_instance: Shoal = shoal.instantiate()
	var x: float = randf_range(offset, width - offset)
	var y: float = randf_range(offset, height - offset)
	shoal_instance.global_position = Vector2(x, y)
	shoal_instance.fishType = fish_type
	shoals.add_child(shoal_instance)
	shoal_instance.init(fish_type, width, height)
	return shoal_instance

func create_fish(currennt_shoal: Shoal, fish_type: String) -> void:
	var fish_instance: Fish = fish.instantiate()
	currennt_shoal.add_child(fish_instance)
	fish_instance.init(fish_type)

func quit() -> void:
	Context.tankId = ""
	get_tree().change_scene_to_file(aquariumUrl)

func _on_tank_hud_add_fish() -> void:
	var inventoryInstance: TankInventory = tankInventory.instantiate()
	inventoryInstance.id = id
	add_child(inventoryInstance)
	inventoryInstance.reload_fishes.connect(reload_fishes)


func _on_tank_hud_delete_tank() -> void:
	var data: Dictionary = Save.getFishesInAquarium(id)
	if data.is_empty():
		Save.removeAquirium(id)
		Save.saveData()
		quit()
	else:
		hud.errorPopup("L'aquarium n'est pas vide, il ne peut pas être supprimer.")
