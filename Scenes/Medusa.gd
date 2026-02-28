extends CharacterBody2D


@export var TILE_SIZE = 16
@export var ANIMATION_SPEED = 6.0
@export var MAX_DISTANCE := 1000.0

@onready var ray: RayCast2D = $RayCast2D


var moving : bool = false

func _ready() -> void:
	GameTick.tick.connect(_onTick)

func _onTick(dir: Vector2) -> void:
	if dir != Vector2.ZERO:
		ChangeSprite(dir)
		await try_move(dir * TILE_SIZE)
		
	fireRay(dir)

func try_move(move_vector: Vector2):
	# test_move() checks if we hit a wall using CharacterBody2D
	if not test_move(global_transform, move_vector):
		await animate_move(move_vector)

func animate_move(move_vector: Vector2):
	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + move_vector, 1.0 / ANIMATION_SPEED).set_trans(Tween.TRANS_SINE)
	
	await tween.finished
	moving = false
	
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
	$PlayerSprite.texture = tex
	
#Fires a ray and checks for collisions
func fireRay(facingDirection: Vector2):
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
						print("Enemy turned to stone")
