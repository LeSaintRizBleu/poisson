class_name ShopItemDisplayer extends VBoxContainer

@export var item : ShopItem

@onready var image : TextureRect = $TextureRect
@onready var label : Label = $Label

signal clicked(source : ShopItemDisplayer)

func _ready() -> void:
	if item:
		image.texture = item.icon
		label.text = item.name
		
func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("gui_mouse_left_click"):
		clicked.emit(self)
		
