extends Control
signal fadeIn
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/HBoxContainer/MusicSlider
@onready var scream_check: CheckBox = $MarginContainer/VBoxContainer/HBoxContainer2/ScreamCheck
#@onready var tile_spin: SpinBox = $VBoxContainer/TileSizeSpin

func _ready():
	print(Settingstore.musicVol)
	print(Settingstore.scream_on)
	if not Settingstore.musicVol == null:
		music_slider.value = Settingstore.musicVol * 100.0
	scream_check.button_pressed = Settingstore.scream_on
	#tile_spin.value = Settingstore.TILE_SIZE


func _on_MusicSlider_value_changed(value: float):
	Settingstore.musicVol = value / 100.0

func _on_ScreamCheck_toggled(toggled: bool):
	Settingstore.scream_on = toggled

func _on_TileSizeSpin_value_changed(value: float):
	Settingstore.TILE_SIZE = int(value)


func _on_music_slider_value_changed(value: float) -> void:
	Settingstore.musicVol = value / 100.0


func _on_scream_check_toggled(toggled_on: bool) -> void:
	Settingstore.scream_on = toggled_on


func _on_start_game_button_pressed() -> void:
	$FadeIn.visible = true;
	fadeIn.emit()


func _on_fade_in_fade_finished() -> void:
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://Scenes/MainMenu.tscn")
	else:
		Engine.get_main_loop().change_scene_to_file("res://Scenes/MainMenu.tscn")
