@tool
extends Area2D

class_name Water

@export var current: float = 0.0
var impact = 2
var floaters: Array[Floater]

func _ready():
	connect_signals()

func connect_signals() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	move_floaters(delta)

func move_floaters(delta: float) -> void:
	for i in floaters:
		i.apply_force(-transform.x.normalized()*current*delta)

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.enter_state(Player.VertStates.GROUNDED)

	if (body is Floater):
		floaters.append(body)
		body.is_in_water = true
		body.impact()

func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		if (body.current_vert_state != Player.VertStates.JUMPING):
			body.coyote_timer.start()
	if (body is Floater):
		body.is_in_water = false
		#remove floater from array
		for i in range(floaters.size()):
			if floaters[i] == body:
				floaters.remove_at(i)
