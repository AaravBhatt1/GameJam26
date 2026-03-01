class_name Enemy

extends CharacterBody2D
@export var CurrentDirection = Vector2.DOWN
enum EnemyState {Target, Civillian, Henchmen}
@export var EnemyStatus : EnemyState
@onready var sprite = $AnimatedSprite2D

signal LevelWon
signal LevelFailed

func _ready():
	SetSprite()


func SetSprite():
	#var tex;
	match CurrentDirection:
		Vector2.UP:
			match EnemyStatus:
				EnemyState.Target:
					sprite.play("up-civ")
					#tex = load("res://Assets/EnemySprites/TargetSpriteUp.png")
				EnemyState.Henchmen:
					sprite.play("up-hench")
					
					#tex = load("res://Assets/EnemySprites/EnemySpriteUp.png")
				_: sprite.play("up-civ")
					#tex = load("res://Assets/EnemySprites/CivillianSpriteUp.png")
		Vector2.DOWN:
			match EnemyStatus:
				EnemyState.Target: sprite.play("down-civ")
					#tex = load("res://Assets/EnemySprites/TargetSpriteDown.png")
				EnemyState.Henchmen: sprite.play("down-hench")
					#tex = load("res://Assets/EnemySprites/EnemySpriteDown.png")
				_: sprite.play("down-civ")
					#tex = load("res://Assets/EnemySprites/CivillianSpriteDown.png")
		Vector2.LEFT:
			match EnemyStatus:
				EnemyState.Target: pass
					#tex = load("res://Assets/EnemySprites/TargetSpriteLeft.png")
				EnemyState.Henchmen: 
					sprite.play("left-hench")
					#tex = load("res://Assets/EnemySprites/EnemySpriteLeft.png")
				_:	
					sprite.play("left-civ")
					print("a")
					#tex = load("res://Assets/EnemySprites/CivillianSpriteLeft.png")
		Vector2.RIGHT:
			match EnemyStatus:
				EnemyState.Target: pass
					#tex = load("res://Assets/EnemySprites/TargetSpriteRight.png")
				EnemyState.Henchmen:
					
					sprite.play("right-hench")
					#tex = load("res://Assets/EnemySprites/EnemySpriteRight.png")
				_: sprite.play("right-civ")
					#tex = load("res://Assets/EnemySprites/CivillianSpriteRight.png")
	#$Sprite2D.texture = tex
	
func checkStatus():
	return EnemyStatus != EnemyState.Henchmen
	
func turnedStone():
	match EnemyStatus:
		EnemyState.Target:
			var target = get_tree().current_scene.find_child("TickManager")
			target.blocked = true
			ReplaceWithBox()
		EnemyState.Civillian:
			var a
			match CurrentDirection:
				Vector2.UP:
					a = "up-civ-death"
				Vector2.DOWN:
					a = "down-civ-death"
				Vector2.LEFT:
					a = "left-civ-death"
				Vector2.RIGHT:
					a = "right-civ-death"
			var target = get_tree().current_scene.find_child("TickManager")
			target.blocked = true
			$AnimatedSprite2D.play(a)
			$AnimatedSprite2D.animation_finished.connect(ReplaceWithBox)
			
		_:
			var a
			match CurrentDirection:
				Vector2.UP:
					a = "up-guard-death"
				Vector2.DOWN:
					a = "down-guard-death"
				Vector2.LEFT:
					a = "left-guard-death"
				Vector2.RIGHT:
					a = "right-guard-death"
			var target = get_tree().current_scene.find_child("TickManager")
			target.blocked = true
			$AnimatedSprite2D.play(a)
			$AnimatedSprite2D.animation_finished.connect(func ():
				target.blocked = false
				ReplaceWithBox()
				)
			
func ReplaceWithBox():
	var box_scene = load("res://Scenes/pushable.tscn")
	var box = box_scene.instantiate()
	match EnemyStatus:
		EnemyState.Target:
			pass
		EnemyState.Civillian:
			var a
			match CurrentDirection:
				Vector2.UP:
					box.sprite_texture = preload("res://Assets/civiliansToStone/stone-civ-back.png")
				Vector2.DOWN:
					box.sprite_texture = preload("res://Assets/civiliansToStone/stone-civ-front.png")
				Vector2.LEFT:
					box.sprite_texture = preload("res://Assets/civiliansToStone/stone-civ-left.png")
				Vector2.RIGHT:
					box.sprite_texture = preload("res://Assets/civiliansToStone/stone-civ-right.png")
			
		_:
			var a
			match CurrentDirection:
				Vector2.UP:
					box.sprite_texture = preload("res://Assets/henchmanToStone/stone-guard-down.png")
				Vector2.DOWN:
					box.sprite_texture = preload("res://Assets/henchmanToStone/stone-guard-front.png")
				Vector2.LEFT:
					box.sprite_texture = preload("res://Assets/henchmanToStone/stone-guard-left.png")
				Vector2.RIGHT:
					box.sprite_texture = preload("res://Assets/henchmanToStone/stone-guard-right.png")
			
	# Set asset BEFORE or immediately after instantiation
	

	add_sibling(box)
	box.global_position = global_position

	if EnemyStatus == EnemyState.Target:
		LevelWon.emit()
	elif EnemyStatus == EnemyState.Henchmen:
		var target = get_tree().current_scene.find_child("WinManager")
		target.guardDeath()
	elif EnemyStatus == EnemyState.Civillian:
		LevelFailed.emit()

	queue_free()
	
