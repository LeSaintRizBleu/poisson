class_name ShopScreen extends Control

var shop_item_displayer_scene : PackedScene = preload("res://core/shop/shop_item_displayer.tscn")

@export var inventory : ShopInventory

@onready var item_grid : GridContainer = $GridContainer

func _ready() -> void:
	if inventory:
		for item:ShopItem in inventory.contents:
			create_shop_item(item)

func create_shop_item(item : ShopItem) -> void:
	var new_item_displayer : ShopItemDisplayer = shop_item_displayer_scene.instantiate()
	new_item_displayer.item = item
	new_item_displayer.clicked.connect(_click_item)
	item_grid.add_child(new_item_displayer)

func _click_item(displayer : ShopItemDisplayer) -> void:
	if Save.spendMoney(displayer.item.price):
		displayer.queue_free()
	
	
