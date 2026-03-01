extends CharacterBody2D


@export var TILE_SIZE = 16
@export var MAX_DISTANCE := 1000.0
signal LevelFailed
@onready var ray: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D
var active_ray_path: Array = []

var draw_progress: float = 0.0
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
	if move_vector == Vector2(16, 0):
		$AnimatedSprite2D.play("walk-right")
	if move_vector == Vector2(-16, 0):
		$AnimatedSprite2D.play("walk-left")
	if move_vector == Vector2(0, -16):
		$AnimatedSprite2D.play("walk-up")
	if move_vector == Vector2(0, 16):
		$AnimatedSprite2D.play("walk-down")
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
		Vector2.RIGHT:
			tex = load("res://Assets/MedusaSprites/MedusaSpriteRight.png")
	#$PlayerSprite.texture = tex
	return

func fireRay():
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	line_2d.clear_points() 
	
	for start_dir in directions:
		var current_dir = start_dir
		var current_origin = global_position 
		var is_facing_this_way = (start_dir == last_facing_dir)
		
		var ray_path = [to_local(current_origin)] 
		var hits_remaining = 100 
		var should_draw_this_ray = false

		while hits_remaining > 0:
			#print(hits_remaining)
			ray.global_position = current_origin
			ray.target_position = current_dir * MAX_DISTANCE
			ray.force_raycast_update()

			if not ray.is_colliding():
				ray_path.append(to_local(current_origin + (current_dir * MAX_DISTANCE)))
				break

			var collider = ray.get_collider()
			var hit_point = ray.get_collision_point() + (current_dir *33)
			ray_path.append(to_local(hit_point))

			if collider.is_in_group("Enemy"):
				# SAFETY CHECK: Only check direction if the property actually exists
				if "CurrentDirection" in collider:
					if collider.has_method("checkStatus") and collider.checkStatus():
						if collider.CurrentDirection.is_equal_approx(-current_dir):
							if collider.has_method("turnedStone"):
								collider.turnedStone()
							should_draw_this_ray = true
					
					# Alternative check if status is false but direction matches
					elif collider.CurrentDirection.is_equal_approx(-current_dir):
						if collider.has_method("turnedStone"):
							collider.turnedStone()
				break 

			elif collider.is_in_group("Mirror"):
				var next_dir = collider.reflectray(-current_dir)
				if next_dir == null: break
				current_dir = next_dir
				current_origin = collider.global_position + (current_dir * 8) 
				hits_remaining -= 1
			
			elif collider.is_in_group("Medusa"):
				print("Medus")
				if is_facing_this_way:
					should_draw_this_ray = true
					var target = get_tree().current_scene.find_child("TickManager")
					target.blocked = true
					print("Died - Saw own reflection")
					LevelFailed.emit()
				break
			else:
				break
		
		if should_draw_this_ray:
			ray_path.reverse()
			active_ray_path = ray_path
			animateRay()
			break

func animateRay():
	draw_progress = 0.0
	var tween = create_tween()
	tween.tween_property(self, "draw_progress", 1.0, 1.0).set_trans(Tween.TRANS_LINEAR)

func _process(_delta):
	if draw_progress > 0 and not active_ray_path.is_empty():
		update_line_drawing(active_ray_path)

func update_line_drawing(full_path: Array):
	line_2d.clear_points()
	var total_points = full_path.size()
	
	var progress_scaled = draw_progress * (total_points - 1)
	var points_to_show = int(progress_scaled)
	
	for i in range(points_to_show + 1):
		line_2d.add_point(full_path[i])
	
	if points_to_show < total_points - 1:
		var start = full_path[points_to_show]
		var end = full_path[points_to_show + 1]
		var segment_progress = progress_scaled - points_to_show
		var current_pos = start.lerp(end, segment_progress)
		line_2d.add_point(current_pos)
