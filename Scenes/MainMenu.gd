extends Control

func _ready() -> void:
	for button in $MarginContainer/Menu/Columns/Buttons.get_children():
		button.pressed.connect(_on_Button_pressed.bind(button.SceneToLoad))

func _on_Button_pressed(SceneToLoad):
	if SceneToLoad == "Quit":
		get_tree().quit()
	else:
		get_tree().change_scene_to_file(SceneToLoad)
