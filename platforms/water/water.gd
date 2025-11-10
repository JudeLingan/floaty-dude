extends Area2D

@export var current: float = 0.0
var player: Player

func move_player() -> void:
	if (player != null):
		player.apply_force(transform.origin*current)
