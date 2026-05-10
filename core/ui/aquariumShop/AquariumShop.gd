extends Control
class_name AquariumShop

signal create_structure_from_shop

@onready var height: float = size.y
var current_tween: Tween

func open() -> void:
	await _wait_for_current_animation()
	position.y += height
	show()
	await _create_move_tween(position.y - height)

func close() -> void:
	await _wait_for_current_animation()
	await _create_move_tween(position.y + height)
	hide()
	position.y -= height

func _create_move_tween(target: float) -> void:
	current_tween = create_tween()
	current_tween.tween_property(self, "position:y", target, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await current_tween.finished

func _on_aquarium_shop_button_shop_button_pressed(type: Structure) -> void:
	create_structure_from_shop.emit(type)

func _wait_for_current_animation() -> void:
	if current_tween and current_tween.is_running():
		await current_tween.finished
