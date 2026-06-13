class_name Area
extends Resource

enum WATER_TYPE {SALT, FRESH, BRACKISH, ABYSSAL}
enum WATER_TEMPERATURE {WARM, TEMPERATE, COLD, GLACIAL, ABYSSAL}


@export var name: String
@export var water_type: WATER_TYPE
@export var water_temperature: WATER_TEMPERATURE

@export var common_fishes: Array[FishInfo]
@export var uncommon_fishes: Array[FishInfo]
@export var rare_fishes: Array[FishInfo]


func get_random_fish() -> FishInfo:
	var r: float = randf()
	if r <= 0.6:
		return common_fishes.pick_random()
	if r <= 0.9:
		return uncommon_fishes.pick_random()
	return rare_fishes.pick_random()


func get_label() -> String:
	return name

func get_water_type() -> WATER_TYPE:
	return water_type

func get_water_temperature() -> WATER_TEMPERATURE:
	return water_temperature

func get_common_fishes() -> Array:
	return common_fishes

func get_uncommon_fishes() -> Array:
	return uncommon_fishes
	
func get_rare_fishes() -> Array:
	return rare_fishes
