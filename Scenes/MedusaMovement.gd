extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	getInput()


func getInput():
	if (Input.is_action_just_pressed("MoveUp")):
		pass
	elif (Input.is_action_just_pressed("MoveDown")):
		pass
	elif (Input.is_action_just_pressed("MoveLeft")):
		pass
	elif (Input.is_action_just_pressed("MoveRight")):
		pass
