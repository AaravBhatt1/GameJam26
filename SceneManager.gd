extends Node2D

@export var LevelToLoad : String
var LevelFailed = false;

func _ready():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.LevelWon.connect(LoadLevel)
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.LevelFailed.connect(ReloadLevel)

func LoadLevel():
	$Control/FadeIn.show()
	$Control/FadeIn.fadeIn()
	
func ReloadLevel():
	LevelFailed = true
	$Control/FadeIn.show()
	$Control/FadeIn.fadeIn()





func _on_fade_in_fade_finished() -> void:
	if LevelFailed:
		var tree = get_tree()
		if tree:
			tree.reload_current_scene()
		else:
			Engine.get_main_loop().reload_current_scene()
	else:
		var tree = get_tree()
		if tree:
			tree.change_scene_to_file(LevelToLoad)
		else:
			Engine.get_main_loop().change_scene_to_file(LevelToLoad)
