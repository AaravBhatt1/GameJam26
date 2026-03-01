extends Control

var ScenePathToLoad

func _on_SettingsButton_pressed():
	var settings_scene = preload("res://control.tscn")
	var settings_instance = settings_scene.instantiate()
	add_child(settings_instance)
	
func _ready() -> void:
	for button in $MarginContainer/Menu/Columns/Buttons.get_children():
		button.pressed.connect(_on_Button_pressed.bind(button.SceneToLoad))

func _on_Button_pressed(SceneToLoad):
	if SceneToLoad == "Quit":
		get_tree().quit()
	else:
		ScenePathToLoad = SceneToLoad
		$FadeIn.show()
		$FadeIn.fadeIn()

func _on_fade_in_fade_finished() -> void:
	get_tree().change_scene_to_file(ScenePathToLoad)
