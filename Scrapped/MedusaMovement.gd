extends CharacterBody2D # Switched from Area2D

@export var TILE_SIZE = 16
@export var ANIMATION_SPEED = 4.0

var moving : bool = false

func _process(_delta: float) -> void:
	if not moving:
		get_input()

func get_input():
	var dir = Vector2.ZERO
	if Input.is_action_just_pressed("MoveUp"):    
		dir = Vector2.UP
		ChangeSprite("res://Assets/MedusaSprites/MedusaSpriteUp.png")
	elif Input.is_action_just_pressed("MoveDown"): 
		dir = Vector2.DOWN
		ChangeSprite("res://Assets/MedusaSprites/MedusaSpriteDown.png")
	elif Input.is_action_just_pressed("MoveLeft"): 
		dir = Vector2.LEFT
		ChangeSprite("res://Assets/MedusaSprites/MedusaSpriteLeft.png")
	elif Input.is_action_just_pressed("MoveRight"): 
		dir = Vector2.RIGHT
		ChangeSprite("res://Assets/MedusaSprites/MedusaSpriteRight.png")
	
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
	
func ChangeSprite(SpritePath : String):
	print("Runninga")
	$PlayerSprite.texture = load("res://Assets/MedusaSprites/MedusaSpriteLeft.png")
