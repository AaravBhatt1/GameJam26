extends Button

@export var SceneToLoad : String;


func _on_button_down() -> void:
	$AudioStreamPlayer.play()
