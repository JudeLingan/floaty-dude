extends CharacterBody2D

class_name Player

@export var speed: float = 300.0
@export var accel_time: float = 1.0
@export var decel_time: float = 1.0

@export_group("Jumping")
@export var jump_velocity: float = 400.0
@export var boost: float = 10.0
@export var jump_time: float = 1.0
@export var max_air:int = 100

@export_group("Water Physics")
@export var accel_time_water: float = 1.0
@export var decel_time_water: float = 1.0

@export_group("Polish")
@export var coyote_time: float = 1.0
@export var buffer_time: float = 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var accel = speed/accel_time
@onready var decel = speed/decel_time

@onready var air: float = max_air

# timers
var coyote_timer: Timer
var buffer_timer: Timer
var jump_timer: Timer

# vertical movement states
enum VertStates { FALLING, GROUNDED, JUMPING }

var current_vert_state: VertStates = VertStates.FALLING


func _init() -> void:
	#initialize timers
	coyote_timer = Timer.new()
	coyote_timer.one_shot = true
	self.add_child(coyote_timer)

	buffer_timer = Timer.new()
	buffer_timer.one_shot = true
	self.add_child(buffer_timer)

	jump_timer = Timer.new()
	jump_timer.one_shot = true
	self.add_child(jump_timer)
	jump_timer.timeout.connect(_on_jump_timeout)


func _ready() -> void:
	sprite.play()

	# set timer times
	coyote_timer.wait_time = coyote_time
	buffer_timer.wait_time = buffer_time
	jump_timer.wait_time = jump_time

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !(is_on_floor()):
		velocity += get_gravity() * delta

	# Vertical movement state machine
	match(current_vert_state):
		VertStates.GROUNDED:
			if (Input.is_action_just_pressed("jump")):
				try_jump()
		VertStates.JUMPING:
			if (Input.is_action_pressed("jump")):
				apply_force(boost*Vector2.UP)
			else:
				enter_state(VertStates.FALLING)

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	walk(direction, delta)

	move_and_slide()

func try_jump() -> void:
	if (current_vert_state == VertStates.GROUNDED):
		enter_state(VertStates.JUMPING)
	else:
		buffer_timer.start()

# Enter state and do any state-specific
func enter_state(state: VertStates) -> void:
	match (state):
		VertStates.JUMPING:
			velocity = max(jump_velocity, -velocity.y + jump_velocity)*Vector2.UP + velocity*Vector2.RIGHT
			jump_timer.start()

	assert(state <= VertStates.size())
	current_vert_state = state

func apply_force(force: Vector2) -> void:
	velocity += force

func apply_force_clamp(force: Vector2, limit: Vector2) -> void:
	# make it so that force is no greater than clamp
	force.clamp(-abs(limit), abs(limit));
	apply_force(force)

func walk(direction: float, delta: float) -> void:
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

	if (!is_on_floor() || velocity.y < 0):
		animation = "jump"

	toggle_animation(animation)

func toggle_animation(animation: String) -> void:
	if (sprite.animation != animation):
		sprite.animation = animation
		sprite.play()

# SIGNAL WRAPPER FUNCTIONS
func _on_jump_timeout() -> void:
	print("timeout")
	if (current_vert_state == VertStates.JUMPING):
		enter_state(VertStates.FALLING)
