extends Object

class_name resource

@export var capacity: float = 1
var amount: float = capacity

func use(n: float) -> bool:
	if (amount < n):
		return false

	amount = amount - n
	return true

func replenish(n: float) -> void:
	amount = min(amount + n, capacity)

func fill() -> void:
	amount = capacity
