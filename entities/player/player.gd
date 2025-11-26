extends CharacterBody2D

class_name Player

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var boyancy: float = 10.0
@export var accel_time: float = 1.0
@export var accel_time_water: float = 1.0
@export var decel_time: float = 1.0
@export var decel_time_water: float = 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var accel = speed/accel_time
@onready var decel = speed/decel_time

func _ready() -> void:
	sprite.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !(is_on_floor()):
		velocity += get_gravity() * delta

	# Handle jump.
	var jump: bool = false
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump = true

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	walk(direction, jump, delta)

	move_and_slide()

func apply_force(force: Vector2) -> void:
	velocity += force

func apply_force_clamp(force: Vector2, limit: Vector2) -> void:
	# make it so that force is no greater than clamp
	force.clamp(-abs(limit), abs(limit));
	apply_force(force)

func walk(direction: float, jump: bool, delta: float) -> void:
	var animation = "idle"
	if (direction):
		sprite.flip_h = direction < 0
		animation = "walk"
		var max_force: Vector2 = Vector2(speed - velocity.x*direction, 0)
		var force: Vector2 = Vector2(accel*delta, 0)

		force.x = min(force.x, max_force.x)
		apply_force(direction*force)
	
	else:
		animation = "idle"
		apply_force_clamp(Vector2(-sign(velocity.x)*decel*delta, 0), Vector2(velocity.x, 0))
	
	if (jump):
		apply_force(Vector2(0, min(jump_velocity - velocity.y, 0)));
	
	if (!is_on_floor() || velocity.y < 0):
		animation = "jump"

	toggle_animation(animation)

func toggle_animation(animation: String) -> void:
	if (sprite.animation != animation):
		sprite.animation = animation
		sprite.play()
