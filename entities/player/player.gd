extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var accel_time: float = 1.0
@export var accel_time_water: float = 1.0
@export var decel_time: float = 1.0
@export var decel_time_water: float = 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var accel = speed/accel_time
var decel = speed/decel_time

func _ready() -> void:
	sprite.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	var jump: bool = false
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	walk(direction, jump, delta)

	move_and_slide()

func walk(direction: float, jump: bool, delta: float) -> void:
	var animation = "idle"
	if (direction):
		sprite.flip_h = direction < 0
		animation = "walk"
		velocity.x = sign(direction)*max(
			move_toward(velocity.x*direction, speed, accel*delta),
			decelleration(delta)*direction)
	
	else:
		velocity.x = decelleration(delta)
		animation = "idle"
	
	if (jump):
		velocity.y = min(velocity.y, jump_velocity)
	
	if (!is_on_floor() || velocity.y < 0):
		animation = "jump"

	toggle_animation(animation)

func toggle_animation(animation: String) -> void:
	if (sprite.animation != animation):
		sprite.animation = animation
		sprite.play()
	
func decelleration(delta: float) -> float:
	return move_toward(velocity.x, 0, (speed)/decel_time*delta)
