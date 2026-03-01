extends Control
signal fadeIn

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Select"):
		fadeIn.emit()
	

func _on_fade_in_fade_finished() -> void:
	Engine.get_main_loop().change_scene_to_file("res://Scenes/level1.tscn")
