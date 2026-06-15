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

var rarity: String

func get_random_fish() -> FishInfo:
	var r: float = randf()
	if r <= 0.6:
		rarity = "Common"
		if common_fishes.is_empty(): return get_random_fish()
		return common_fishes.pick_random()
	if r <= 0.9:
		rarity = "Uncommon"
		if uncommon_fishes.is_empty(): return get_random_fish()
		return uncommon_fishes.pick_random()
	rarity = "Rare"
	if rare_fishes.is_empty(): return get_random_fish()
	return rare_fishes.pick_random()

func is_empty() -> bool:
	return common_fishes.is_empty() && uncommon_fishes.is_empty() && rare_fishes.is_empty()

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
