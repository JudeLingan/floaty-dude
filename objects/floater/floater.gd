extends CharacterBody2D

class_name Floater

@export var boyancy: float = 1.0
var is_in_water: bool = false

func _ready():
	print(get_parent())

func _physics_process(delta: float) -> void:
	if is_in_water:
		if get_parent() is CharacterBody2D:
			get_parent().velocity.y -= boyancy*delta
		else:
			velocity.y -= boyancy*delta

	move_and_slide()

func impact() -> void:
	if get_parent() is CharacterBody2D:
		get_parent().velocity.y /= 20
	else:
		velocity.y /= 2

func apply_force(force: Vector2) -> void:
	if get_parent() is CharacterBody2D:
		get_parent().velocity += force
	else:
		velocity += force
