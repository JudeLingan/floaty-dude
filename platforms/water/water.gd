extends Area2D

@export var current: float = 0.0
var players: Array[Player]

func _ready():
	connect_signals()

func connect_signals() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)


func _physics_process(delta: float) -> void:
	move_players(delta)

func move_players(delta: float) -> void:
	for i in players:
		i.apply_force(-transform.x.normalized()*current*delta)

func _on_body_entered(body: Node2D) -> void:
	print("bodyyyy")
	if (body is Player):
		players.append(body)
		body.is_in_water = true;

func _on_body_exited(body: Node2D) -> void:
	print("no the bodyyy")
	if (body is Player):
		body.is_in_water = false;

		#remove player
		for i in range(players.size()):
			if players[i] == body:
				players.remove_at(i)
