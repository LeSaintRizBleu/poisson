extends CanvasLayer
class_name Map

var inventortUrl: String = "res://core/ui/inventory/Inventory.tscn"
var aquariumUrl: String = "res://core/aquarium/Aquarium.tscn"
var fishingUrl: String = "res://core/fishing/Fishing.tscn"

func _on_inventory_pressed() -> void:
	get_tree().change_scene_to_file(inventortUrl)


func _on_aquarium_pressed() -> void:
		get_tree().change_scene_to_file(aquariumUrl)

func _on_fishing_pressed() -> void:
		get_tree().change_scene_to_file(fishingUrl)

func _on_upgrade_pressed() -> void:
	print("TODO")


func _on_treasure_pressed() -> void:
	print("TODO")


func _on_boat_pressed() -> void:
	print("TODO")
