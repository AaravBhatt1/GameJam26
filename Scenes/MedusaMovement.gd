extends Area2D

var TILE_SIZE = 32
var ANIMATION_SPEED = 3

enum Direction {UP, DOWN, LEFT, RIGHT }

var facingDirection : Direction
var moving : bool = false
@onready var ray = $PlayerMovementRaycast

func getInput():
	if (Input.is_action_just_pressed("MoveUp")):
		facingDirection = Direction.UP
		Move()
	elif (Input.is_action_just_pressed("MoveDown")):
		facingDirection = Direction.DOWN#
		Move()
	elif (Input.is_action_just_pressed("MoveLeft")):
		facingDirection = Direction.LEFT
		Move()
	elif (Input.is_action_just_pressed("MoveRight")):
		facingDirection = Direction.RIGHT
		Move()

func Move():
	if !moving:
		match facingDirection:
			Direction.UP:
				TryMove(Vector2(0,-TILE_SIZE))
			Direction.DOWN:
				TryMove(Vector2(0,TILE_SIZE))
			Direction.LEFT:
				TryMove(Vector2(-TILE_SIZE, 0))
			Direction.RIGHT:
				TryMove(Vector2(TILE_SIZE,0))

func TryMove(MoveVector : Vector2):
	ray.target_position = MoveVector
	ray.force_raycast_update()
	if !ray.is_colliding():
		var tween = create_tween()
		tween.tween_property(self, "position", 
		position + MoveVector, 1.0/ANIMATION_SPEED).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
