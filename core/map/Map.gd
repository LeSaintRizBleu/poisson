extends CanvasLayer
class_name Map

var inventory_url: String = "res://core/ui/inventory/Inventory.tscn"
var aquarium_url: String = "res://core/aquarium/Aquarium.tscn"
var fishing_url: String = "res://core/fishing/Fishing.tscn"

func _on_inventory_pressed() -> void:
	get_tree().change_scene_to_file(inventory_url)

func _on_aquarium_pressed() -> void:
	get_tree().change_scene_to_file(aquarium_url)

func _on_fishing_pressed() -> void:
	get_tree().change_scene_to_file(fishing_url)

func _on_upgrade_pressed() -> void:
	print("TODO")

func _on_treasure_pressed() -> void:
	print("TODO")

func _on_boat_pressed() -> void:
	print("TODO")
