extends Area2D

enum Direction {UP, DOWN, LEFT, RIGHT }

var facingDirection : Direction

# Called when the node enters the scene tree for the first time.

@onready var ray: RayCast2D = $RayCast2D

func _onTick():
	fire(facingDirection)

@export var max_distance := 1000.0
func resolveDirection():
	match facingDirection:
		Direction.UP:
			return Vector2(0, 1)
		Direction.DOWN:
			return Vector2(0, -1)
		Direction.LEFT:
			return Vector2(1, 0)
		Direction.RIGHT:
			return Vector2(0, 1)
		_:
			return Vector2(0, 0)
		
		
		
func fire(facintDirection: Direction):
	var direction = resolveDirection()

	if direction == Vector2.ZERO:
		return

	# Rotate laser to face direction
	global_rotation = direction.angle()

	# Set ray length
	ray.target_position = Vector2(max_distance, 0)
	ray.force_raycast_update()

	if ray.is_colliding():
		var collider = ray.get_collider()

		print("Hit:", collider)
