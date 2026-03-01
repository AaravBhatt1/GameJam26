extends Control

@onready var music_slider: HSlider = $VBoxContainer/MusicSlider
@onready var scream_check: CheckBox = $VBoxContainer/ScreamCheck
#@onready var tile_spin: SpinBox = $VBoxContainer/TileSizeSpin

func _ready():
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
