extends Area2D

class_name Checkpoint

@export var respawn_point: Node2D
@export var initial_velocity: Vector2 = Vector2.ZERO
@export var animation_speed: float = 10.0

var player: Player = null
var ogposition: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Rainbow/AnimatedSprite2D.play("default")
	if !respawn_point:
		respawn_point = self
	for i in get_children():
		if i is CanvasItem && i != %Rainbow:
			i.visible = false

func build_level() -> void:
	if %Rainbow: %Rainbow.queue_free()
	for i in get_children():
		if i is CanvasItem:
			i.visible = true

func _on_body_entered(body: Node2D):
	if body is Player:
		collision_mask = 0
		if body.checkpoint: body.checkpoint.queue_free()
		body.checkpoint = self
		body.enter_state(Player.VertStates.ANIMATION)
		player = body
		build_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player:
		player.position += player.position.direction_to(respawn_point.position)*min(2, player.position.distance_to(respawn_point.position))
		if (player.position == respawn_point.position):
			player.velocity = initial_velocity
			player.enter_state(Player.VertStates.FALLING)
			player = null
