class_name Area
extends Resource

enum WATER_TYPE {SALT, FRESH, BRACKISH, ABYSSAL}
enum WATER_TEMPERATURE {WARM, TEMPERATE, COLD, GLACIAL, ABYSSAL}


@export var name: String
@export var water_type: WATER_TYPE
@export var water_temperature: WATER_TEMPERATURE
@export var fishes: Array[FishInfo]

func get_label() -> String:
	return name

func get_water_type() -> WATER_TYPE:
	return water_type

func get_water_temperature() -> WATER_TEMPERATURE:
	return water_temperature

func get_fishes() -> Array:
	return fishes
