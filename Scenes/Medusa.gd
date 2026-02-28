extends CharacterBody2D # Switched from Area2D


@export var TILE_SIZE = 16
@export var ANIMATION_SPEED = 4.0
@export var MAX_DISTANCE := 1000.0

@onready var ray: RayCast2D = $RayCast2D


var moving : bool = false

func _ready() -> void:
	GameTick.tick.connect(_onTick)

func _onTick(dir: Vector2) -> void:
	fireRay(dir)
	if dir != Vector2.ZERO:
		try_move(dir * TILE_SIZE)
		ChangeSprite(dir)

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
	if facingDirection == Vector2.ZERO:
		return
		
	# Rotate laser to face direction
	ray.global_rotation = facingDirection.angle()
	
 

	# Set ray length
	ray.target_position = Vector2(MAX_DISTANCE, 0)
	ray.force_raycast_update()
	
	#Returns collider overlapped with
	if ray.is_colliding():
		var collider = ray.get_collider()

		print("Hit:", collider)
