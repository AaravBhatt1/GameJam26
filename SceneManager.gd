extends Node2D

@export var LevelToLoad : String
@export var LevelSong: String = "res://Assets/SoundEffects/Main_theme.wav" 
var LevelFailed = false;

func _ready():
	var target = get_tree().current_scene.find_child("WinManager")
	target.LevelWon.connect(LoadLevel)
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.LevelFailed.connect(ReloadLevel)
	for medusa in get_tree().get_nodes_in_group("Medusa"):
		medusa.LevelFailed.connect(ReloadLevel)
	$AudioStreamPlayer3.stream = load(LevelSong)
	$AudioStreamPlayer3.play()

func LoadLevel():
	if !LevelFailed:
		$AudioStreamPlayer2.play()
	
func ReloadLevel():
	LevelFailed = true
	$AudioStreamPlayer.play()





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


func _on_audio_stream_player_finished() -> void:
	$Control/FadeIn.show()
	$Control/FadeIn.fadeIn()


func _on_audio_stream_player_2_finished() -> void:
		$Control/FadeIn.show()
		$Control/FadeIn.fadeIn()
