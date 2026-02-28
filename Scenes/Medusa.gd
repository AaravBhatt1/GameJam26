extends CharacterBody2D


@export var TILE_SIZE = 16
@export var MAX_DISTANCE := 1000.0

@onready var ray: RayCast2D = $RayCast2D


var moving : bool = false

func _ready() -> void:
	GameTick.tick.connect(_onTick)

func _onTick(dir: Vector2) -> void:
	if dir != Vector2.ZERO:
		ChangeSprite(dir)
		try_move(dir * TILE_SIZE)
	else:
		fireRay()

func try_move(move_vector: Vector2):

	var collision = move_and_collide(move_vector, true)
	if collision == null:
		animate_move(move_vector)
		return true
	else:
		var target = collision.get_collider()
		if target.has_method("try_push"):
			if target.try_push(move_vector):
				animate_move(move_vector)
				return true

func animate_move(move_vector: Vector2):
	moving = true
	$AnimatedSprite2D.play("walk-sideways")
	var tween = create_tween()
	tween.tween_property(self, "position", position + move_vector, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(
		func():
			moving = false
			fireRay(move_vector)
			$AnimatedSprite2D.stop()
	)

#Changes sprite to one facing in the correct direction
func ChangeSprite(dir : Vector2):
	var tex;
	match dir:
		Vector2.UP:
			tex = load("res://Assets/MedusaSprites/MedusaSpriteUp.png")
		Vector2.DOWN:
			tex = load("res://Assets/MedusaSprites/MedusaSpriteDown.png")
		Vector2.LEFT:
			tex = load("res://Assets/MedusaSprites/MedusaSpriteLeft.png")
			$AnimatedSprite2D.flip_h = true
		Vector2.RIGHT:
			$AnimatedSprite2D.flip_h = false
			tex = load("res://Assets/MedusaSprites/MedusaSpriteRight.png")
	#$PlayerSprite.texture = tex
	return

#Fires a ray and checks for collisions
func fireRay():
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

	for dir in directions:
		ray.target_position = dir * MAX_DISTANCE
		ray.force_raycast_update()

		#Checks if enemy has seen you
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider.is_in_group("Enemy"):
				if "CurrentDirection" in collider:
					var PlayerLine = (global_position - collider.global_position).normalized()
					if collider.CurrentDirection == PlayerLine:
						if collider.has_method("turnedStone"):
							collider.turnedStone()
			if collider.is_in_group("Mirror"):
				var player_line = (ray.global_position - collider.global_position).normalized()
				var new_dir = collider.reflectray(player_line)
				var hit_point = ray.get_collision_point()
				# Move ray origin slightly along reflection direction
				ray.global_position = hit_point + new_dir * 0.01
				ray.target_position = new_dir * MAX_DISTANCE
				ray.force_raycast_update()
