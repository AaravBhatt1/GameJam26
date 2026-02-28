class_name Enemy

extends CharacterBody2D

@export var CurrentDirection = Vector2.DOWN

func _ready():
	SetSprite()


func SetSprite():
	var tex;
	match CurrentDirection:
		Vector2.UP:
			tex = load("res://Assets/EnemySprites/EnemySpriteUp.png")
		Vector2.DOWN:
			tex = load("res://Assets/EnemySprites/EnemySpriteDown.png")
		Vector2.LEFT:
			tex = load("res://Assets/EnemySprites/EnemySpriteLeft.png")
		Vector2.RIGHT:
			tex = load("res://Assets/EnemySprites/EnemySpriteRight.png")
	$Sprite2D.texture = tex
