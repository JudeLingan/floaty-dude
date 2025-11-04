extends CharacterBody2D


@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var decel_time: float = 1.0
@export var decel_time_water: float = 1.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	move(direction, delta)

	move_and_slide()

func move(direction: float, delta):
	velocity.x = move_toward(velocity.x, direction*speed, speed*delta)
