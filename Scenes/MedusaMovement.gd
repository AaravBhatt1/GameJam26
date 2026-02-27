extends Area2D

enum Direction {UP, DOWN, LEFT, RIGHT }

var facingDirection : Direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	getInput()


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
	pass
