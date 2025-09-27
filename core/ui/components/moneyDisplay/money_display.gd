class_name MoneyDisplay extends Label

func _ready() -> void:
	Save.update_gold.connect(update_value)
	update_value()	
	
func update_value() -> void:
	text = str(Save.getMoney()) + "$"
	
