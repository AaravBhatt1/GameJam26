extends CharacterBody2D

@export var sprite_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if sprite_texture:
		sprite.texture = sprite_texture
	if Settingstore.scream_on:
		var screamNum= randf()
		if screamNum <0.45:
			$AudioStreamPlayer3.play()
		elif screamNum <0.95:
			$AudioStreamPlayer5.play()
		else:
			$AudioStreamPlayer4.play()


func PlaySound():
	$AudioStreamPlayer.play()

func try_push(direction: Vector2) -> bool:
	PlaySound()
	var move_vector = direction
	# 1. Check if the space is clear
	var collision = move_and_collide(move_vector, true)
	if collision == null: 
		animate_move(move_vector)
		return true
	else:
		var target = collision.get_collider()
		if target.has_method("try_push"):
			if target.try_push(move_vector):
				animate_move(move_vector)
				return true
	
	return false

func animate_move(move_vec):
	var target_pos = position + move_vec
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, 0.3).set_trans(Tween.TRANS_LINEAR)


func _on_audio_stream_player_3_finished() -> void:
	$AudioStreamPlayer2.play()


func _on_audio_stream_player_4_finished() -> void:
	$AudioStreamPlayer2.play()


func _on_audio_stream_player_5_finished() -> void:
	$AudioStreamPlayer2.play()
