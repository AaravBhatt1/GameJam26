extends Area2D

enum Direction {UP, DOWN, LEFT, RIGHT }

var facingDirection : Direction

@onready var ray: RayCast2D = $RayCast2D

func _onTick():
	fire(facingDirection)

@export var max_distance := 1000.0
func resolveDirection():
	match facingDirection:
		Direction.UP:
			return Vector2.UP
		Direction.DOWN:
			return Vector2.DOWN
		Direction.LEFT:
			return Vector2.LEFT
		Direction.RIGHT:
			return Vector2.RIGHT
		_:
			return Vector2.ZERO
		
		
		
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
