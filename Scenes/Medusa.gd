extends CharacterBody2D


@export var TILE_SIZE = 16
@export var MAX_DISTANCE := 1000.0
signal LevelFailed
@onready var ray: RayCast2D = $RayCast2D

var last_facing_dir = Vector2.DOWN
var moving : bool = false

func _ready() -> void:
	GameTick.tick.connect(_onTick)

func _onTick(dir: Vector2) -> void:
	if dir != Vector2.ZERO:
		last_facing_dir = dir
		ChangeSprite(dir)
		playSound()
		try_move(dir * TILE_SIZE)
	else:
		fireRay()
		
func playSound():
	var choice = randf()
	if (choice < 0.25):
		$MedusaSoundEffects/GrassWalk1.play()
	elif (choice < 0.5):
		$MedusaSoundEffects/GrassWalk2.play()
	elif (choice < 0.75):
		$MedusaSoundEffects/GrassWalk3.play()
	else:
		$MedusaSoundEffects/GrassWalk4.play()

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
	tween.tween_property(self, "position", position + move_vector, 0.3).set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(
		func():
			moving = false
			fireRay()
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

func fireRay():
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	
	for start_dir in directions:
		var is_facing_this_way = (start_dir == last_facing_dir)
		var current_dir = start_dir
		var current_origin = global_position 
		var hits_remaining = 100 
		while hits_remaining > 0:
			ray.global_position = current_origin
			ray.target_position = current_dir * MAX_DISTANCE
			ray.force_raycast_update()
			if not ray.is_colliding():
				break
			var collider = ray.get_collider()
			var hit_point = ray.get_collision_point()
			if collider.is_in_group("Enemy"):
				if "CurrentDirection" in collider:
					# Enemy faces the incoming ray
					if collider.CurrentDirection.is_equal_approx(-current_dir):
						if collider.has_method("turnedStone"):
							collider.turnedStone()
				break 
			elif collider.is_in_group("Mirror"):
				var next_dir = collider.reflectray(-current_dir)
				if next_dir == null:
					break
				current_dir = next_dir
				current_origin = collider.global_position + (current_dir * 8)
				hits_remaining -= 1
			elif collider.is_in_group("Medusa"):
				if is_facing_this_way:
					print("Died - Saw own reflection")
					LevelFailed.emit()
				break
			else:
				break
			
	ray.position = Vector2.ZERO
