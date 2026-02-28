class_name Enemy

extends CharacterBody2D

@export var CurrentDirection = Vector2.DOWN
enum EnemyState {Target, Civillian, Henchmen}
@export var EnemyStatus : EnemyState

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
		Vector2.RIGHT, _:
			tex = load("res://Assets/EnemySprites/EnemySpriteRight.png")
	$Sprite2D.texture = tex
	
func turnedStone():
	match EnemyStatus:
		EnemyState.Target:
			print("Round won")
		EnemyState.Civillian:
			print("Round failed")
		_:
			ReplaceWithBox()
			
func ReplaceWithBox():
	var box_scene = load("res://Scenes/PushableBox.tscn")
	var box = box_scene.instantiate()

	box.global_position = self.global_position
	get_parent().add_child(box)
	queue_free()
