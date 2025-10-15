extends Node

const SAVE_FILE_PATH: String = "user://saveFile.save"
var data: Dictionary = {
	"inventory": {},
	"aquariums": {},
	"money": 0
}

signal update_gold

func _ready() -> void:
	load_data()
	clear()

func get_aquariums() -> Dictionary:
	var aquariums: Dictionary = data["aquariums"]
	return aquariums.duplicate(true)

func add_aquirium(pos: Vector2, type: String) -> String:
	var aquariums: Dictionary = data["aquariums"]
	var aquarium_id: String = "aquarium_%s" % aquariums.size()
	aquariums[aquarium_id] = {
		"x": pos.x,
		"y": pos.y,
		"fishes": {},
		"type": type
	}
	return aquarium_id

func remove_aquirium(id: String) -> void:
	var aquariums: Dictionary = data["aquariums"]
	if not aquariums.has(id):
		print("Aquarium ID not found: " + id)
		return
	data["aquariums"][id] = {}



func add_fish_to_aquarium(id: String, fish: String) -> void:
	var aquariums: Dictionary = data["aquariums"]
	if not aquariums.has(id):
		print("Aquarium ID not found: " + id)
		return
	var fishes: Dictionary = data["aquariums"][id]["fishes"]
	fishes[fish] = fishes.get(fish, 0) + 1

func remove_fish_from_aquarium(id: String, fish: String) -> void:
	var aquariums: Dictionary = data["aquariums"]
	if not aquariums.has(id):
		print("Aquarium ID not found: " + id)
		return
	var fishes: Dictionary = data["aquariums"][id]["fishes"]
	if not fishes.has(fish):
		print("Fish not found: " + fish)
		return
	fishes[fish] -= 1
	if fishes[fish] <= 0:
		fishes.erase(fish)

func get_fishes_in_aquarium(id: String) -> Dictionary:
	var aquariums: Dictionary = data["aquariums"]
	var aquarium: Dictionary = aquariums.get(id, {})
	var fishes: Dictionary = aquarium.get("fishes", {})
	return fishes.duplicate(true)

func get_aquarium(id: String) -> Dictionary:
	var aquariums: Dictionary = data["aquariums"]
	var aquarium: Dictionary = aquariums.get(id, {})
	return aquarium.duplicate(true)


func get_inventory() -> Dictionary:
	var inventory: Dictionary = data["inventory"]
	return inventory.duplicate(true)

func add_fish_to_inventory(fish: String) -> void:
	var inventory: Dictionary = data["inventory"]
	inventory[fish] = inventory.get(fish, 0) + 1

func remove_fish_from_inventory(fish: String) -> void:
	var inventory: Dictionary = data["inventory"]
	if not inventory.has(fish):
		print("Fish not found: " + fish)
		return
	inventory[fish] -= 1
	if inventory[fish] <= 0:
		inventory.erase(fish)



func load_data() -> void:
	var save_file: FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if save_file:
		var json: JSON = JSON.new()
		var parse_error: Error = json.parse(save_file.get_as_text())
		if parse_error == OK:
			data = json.get_data()
		save_file.close()
	else:
		print("Missing save file")

func save_data() -> void:
	var save_file: FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if save_file:
		save_file.store_string(JSON.stringify(data))
		save_file.close()
	else:
		print("Error saving data")

func clear() -> void:
	var current_id: int = 0
	var new_aquarium: Dictionary
	var aquariums: Dictionary = data["aquariums"]
	for aquarium: Dictionary in aquariums.values():
		if aquarium != {}:
			var aquarium_id: String = "aquarium_%s" % current_id
			new_aquarium[aquarium_id] = aquarium 
			current_id += 1
	data["aquariums"] = new_aquarium


func get_money() -> int:
	return data["money"]

func add_money(amount: int) -> void:
	data["money"] += amount
	update_gold.emit()
	save_data()

func sub_money(amount: int) -> void:
	data["money"] -= amount
	update_gold.emit()
	save_data()
	
func check_money(amount: int) -> bool:
	return data["money"] >= amount
	
func spend_money(amount: int) -> bool:
	if data["money"] < amount:
		return false
	data["money"] -= amount
	update_gold.emit()
	save_data()
	return true
