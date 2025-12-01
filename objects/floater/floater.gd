extends CharacterBody2D

class_name Floater

@export var buoyancy: float = 1.0
@export var impact_divisor: float = 2.0
var is_in_water: bool = false

var parent_body: CharacterBody2D = null

func _ready():
	if get_parent() is CharacterBody2D:
		parent_body = get_parent()

func _physics_process(delta: float) -> void:
	if is_in_water:
		if parent_body:
			parent_body.velocity.y -= buoyancy*delta
		else:
			velocity.y -= buoyancy*delta

	move_and_slide()

func impact() -> void:
	if parent_body:
		parent_body.velocity.y /= impact_divisor
	else:
		velocity.y /= impact_divisor

func apply_force(force: Vector2) -> void:
	if parent_body:
		get_parent().apply_force(force)
	else:
		velocity += force
