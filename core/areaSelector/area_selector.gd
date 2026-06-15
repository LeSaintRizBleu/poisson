extends CanvasLayer

@export var areas: Array[Area]

@onready var container: GridContainer = $MarginContainer/GridContainer

var areaButtonUrl: PackedScene = load("res://core/areaSelector/AreaButton.tscn")

func _ready() -> void:
	for area: Area in areas:
		var instance: AreaButton = areaButtonUrl.instantiate()
		instance.area = area
		container.add_child(instance)
