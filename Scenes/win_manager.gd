extends Node

@export var numGuards = 1

signal LevelWon

func guardDeath():
	numGuards -= 1
	if numGuards == 0:
		var target = get_tree().current_scene.find_child("TickManager")
		target.blocked = true
		LevelWon.emit()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
