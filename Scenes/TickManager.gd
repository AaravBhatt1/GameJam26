extends Node

@onready var timer = $Timer
@export var TICK_DURATION = 0.5

func _process(_delta):
	if not timer.is_stopped():
		return

	var dir = Vector2i.ZERO
	
	if Input.is_action_pressed("MoveUp"):    dir = Vector2i.UP
	elif Input.is_action_pressed("MoveDown"):  dir = Vector2i.DOWN
	elif Input.is_action_pressed("MoveLeft"):  dir = Vector2i.LEFT
	elif Input.is_action_pressed("MoveRight"): dir = Vector2i.RIGHT
	elif Input.is_action_pressed("Wait"):      dir = Vector2i.ZERO
	else:
		return

	timer.start(TICK_DURATION)
	GameTick.tick.emit(dir)
	
