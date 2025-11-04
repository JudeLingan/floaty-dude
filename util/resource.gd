extends Object

@export var capacity: float = 1;
var amount: float = capacity;

func use(n: float) -> void:
	amount = min(amount - n, 0);

func replenish(n: float) -> void:
	amount = max(amount + n, capacity);
