@tool
extends StaticBody2D

@export var flip_h: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (flip_h):
		$Parallax2D.scale.x = -1
		$CollisionShape2D.scale.x = -1
