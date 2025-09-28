class_name GoldShopItem extends ShopItem

@export var price : int = 10

func buy() -> bool:
	if Save.spendMoney(price):
		_buy_effect()
		return true
	return false
