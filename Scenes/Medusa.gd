extends CharacterBody2D # Switched from Area2D

@export var TILE_SIZE = 16
@export var ANIMATION_SPEED = 4.0

var moving : bool = false

func _ready() -> void:
	GameTick.tick.connect(_onTick)

func _onTick(dir: Vector2) -> void:

	if dir != Vector2.ZERO:
		try_move(dir * TILE_SIZE)

func try_move(move_vector: Vector2):
	# test_move() checks if we hit a wall using CharacterBody2D
	if not test_move(global_transform, move_vector):
		animate_move(move_vector)

func animate_move(move_vector: Vector2):
	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + move_vector, 1.0 / ANIMATION_SPEED).set_trans(Tween.TRANS_SINE)
	
	await tween.finished
	moving = false
