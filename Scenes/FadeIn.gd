extends ColorRect

signal fadeFinished

func fadeIn():
	$AnimationPlayer.play("FadeInAnim")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	emit_signal("fadeFinished")


func _on_lore_fade_in() -> void:
	$AnimationPlayer.play("FadeInAnim")


func _on_settings_menu_fade_in() -> void:
	$AnimationPlayer.play("FadeInAnim")
