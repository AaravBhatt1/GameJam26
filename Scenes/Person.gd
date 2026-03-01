class_name Enemy

extends CharacterBody2D
signal LevelWon
signal LevelFailed
@export var CurrentDirection = Vector2.DOWN
enum EnemyState {Target, Civillian, Henchmen}
@export var EnemyStatus : EnemyState

func _ready():
	SetSprite()


func SetSprite():
	var tex;
	match CurrentDirection:
		Vector2.UP:
			match EnemyStatus:
				EnemyState.Target:
					tex = load("res://Assets/EnemySprites/TargetSpriteUp.png")
				EnemyState.Henchmen:
					tex = load("res://Assets/EnemySprites/EnemySpriteUp.png")
				_:
					tex = load("res://Assets/EnemySprites/CivillianSpriteUp.png")
		Vector2.DOWN:
			match EnemyStatus:
				EnemyState.Target:
					tex = load("res://Assets/EnemySprites/TargetSpriteDown.png")
				EnemyState.Henchmen:
					tex = load("res://Assets/EnemySprites/EnemySpriteDown.png")
				_:
					tex = load("res://Assets/EnemySprites/CivillianSpriteDown.png")
		Vector2.LEFT:
			match EnemyStatus:
				EnemyState.Target:
					tex = load("res://Assets/EnemySprites/TargetSpriteLeft.png")
				EnemyState.Henchmen:
					tex = load("res://Assets/EnemySprites/EnemySpriteLeft.png")
				_:
					tex = load("res://Assets/EnemySprites/CivillianSpriteLeft.png")
		Vector2.RIGHT, _:
			match EnemyStatus:
				EnemyState.Target:
					tex = load("res://Assets/EnemySprites/TargetSpriteRight.png")
				EnemyState.Henchmen:
					tex = load("res://Assets/EnemySprites/EnemySpriteRight.png")
				_:
					tex = load("res://Assets/EnemySprites/CivillianSpriteRight.png")
	$Sprite2D.texture = tex
	
func checkStatus():
	return EnemyStatus != EnemyState.Henchmen
	
func turnedStone():
	match EnemyStatus:
		EnemyState.Target:
			var target = get_tree().current_scene.find_child("TickManager")
			target.blocked = true
			ReplaceWithBox()
		EnemyState.Civillian:
			var target = get_tree().current_scene.find_child("TickManager")
			target.blocked = true
			ReplaceWithBox()
		_:
			ReplaceWithBox()
			
func ReplaceWithBox():
	var box_scene = load("res://Scenes/pushable.tscn")
	var box = box_scene.instantiate()
	add_sibling(box)
	box.global_position = self.global_position
	if  EnemyStatus == EnemyState.Target:
		LevelWon.emit()
	elif EnemyStatus == EnemyState.Civillian:
		LevelFailed.emit()

	queue_free()
	
