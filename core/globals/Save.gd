extends Node

const SAVE_FILE_PATH: String = "user://saveFile.save"
var data: Dictionary = {
	"inventory": {},
	"aquariums": {},
	"money": 0
}

func _ready() -> void:
	loadData()
	clear()

func getAquariums() -> Dictionary:
	var aquariums: Dictionary = data["aquariums"]
	return aquariums.duplicate(true)

func addAquirium(pos: Vector2) -> String:
	var aquariums: Dictionary = data["aquariums"]
	var aquariumId: String = "aquarium_%s" % aquariums.size()
	aquariums[aquariumId] = {
		"x": pos.x,
		"y": pos.y,
		"fishes": {},
		"size": 50
	}
	return aquariumId

func removeAquirium(id: String) -> void:
	var aquariums: Dictionary = data["aquariums"]
	if not aquariums.has(id):
		print("Aquarium ID not found: " + id)
		return
	data["aquariums"][id] = {}



func addFishToAquarium(id: String, fish: String) -> void:
	var aquariums: Dictionary = data["aquariums"]
	if not aquariums.has(id):
		print("Aquarium ID not found: " + id)
		return
	var fishes: Dictionary = data["aquariums"][id]["fishes"]
	fishes[fish] = fishes.get(fish, 0) + 1

func removeFishFromAquarium(id: String, fish: String) -> void:
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

func getFishesInAquarium(id: String) -> Dictionary:
	var aquariums: Dictionary = data["aquariums"]
	var aquarium: Dictionary = aquariums.get(id, {})
	var fishes: Dictionary = aquarium.get("fishes", {})
	return fishes.duplicate(true)

func getAquarium(id: String) -> Dictionary:
	var aquariums: Dictionary = data["aquariums"]
	var aquarium: Dictionary = aquariums.get(id, {})
	return aquarium.duplicate(true)


func getInventory() -> Dictionary:
	var inventory: Dictionary = data["inventory"]
	return inventory.duplicate(true)

func addFishToInventory(fish: String) -> void:
	var inventory: Dictionary = data["inventory"]
	inventory[fish] = inventory.get(fish, 0) + 1

func removeFishFromInventory(fish: String) -> void:
	var inventory: Dictionary = data["inventory"]
	if not inventory.has(fish):
		print("Fish not found: " + fish)
		return
	inventory[fish] -= 1
	if inventory[fish] <= 0:
		inventory.erase(fish)



func loadData() -> void:
	var saveFIle: FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if saveFIle:
		var json: JSON = JSON.new()
		var parseError: Error = json.parse(saveFIle.get_as_text())
		if parseError == OK:
			data = json.get_data()
		saveFIle.close()
	else:
		print("Missing save file")

func saveData() -> void:
	var saveFile: FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if saveFile:
		saveFile.store_string(JSON.stringify(data))
		saveFile.close()
	else:
		print("Error saving data")

func clear() -> void:
	var currentId: int = 0
	var newAquarium: Dictionary
	var aquariums: Dictionary = data["aquariums"]
	for aquarium: Dictionary in aquariums.values():
		if aquarium != {}:
			var aquariumId: String = "aquarium_%s" % currentId
			newAquarium[aquariumId] = aquarium 
			currentId += 1
	data["aquariums"] = newAquarium


func getMoney() -> int:
	return data["money"]

func addMoney(amount: int) -> void:
	data["money"] += amount
	saveData()

func subMoney(amount: int) -> void:
	data["money"] -= amount
	saveData()
