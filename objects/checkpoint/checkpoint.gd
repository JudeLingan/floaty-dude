extends Area2D

class_name Checkpoint

@export var respawn_point: Node2D

var player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !respawn_point:
		respawn_point = self
	for i in get_children():
		if i is CanvasItem:
			i.visible = false

func build_level() -> void:
	for i in get_children():
		if i is CanvasItem:
			i.visible = false

func _on_body_entered(body: Node2D):
	if body is Player:
		if body.checkpoint: body.checkpoint.queue_free()
		body.ckeckpoint = self
		body.enter_state(Player.VertStates.ANIMATION)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player:
		player.position = player.position.move_toward(respawn_point.position, delta)
