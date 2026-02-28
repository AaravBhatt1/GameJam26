extends Node2D

# true is top left to bottom right of the cell
@export var direction:bool = true
@export var backwards:bool = false

func reflectray(playerLine:Vector2):
	match playerLine:
		Vector2.UP:
			if direction:
				return Vector2.RIGHT
			return Vector2.LEFT
		Vector2.DOWN:
			if direction:
				return Vector2.LEFT
			return Vector2.RIGHT
		Vector2.LEFT:
			if direction:
				return Vector2.DOWN
			return Vector2.UP
		Vector2.RIGHT:
			if direction:
				return Vector2.UP
			return Vector2.DOWN
	

func _ready() -> void:
	var tex;
	if direction:
		if backwards:
			tex = load("res://Assets/MirrorSprites/MirrorTLBR2.png")
		else:
			tex = load("res://Assets/MirrorSprites/MirrorTLBR.png")
	else:
		if backwards:
			tex = load("res://Assets/MirrorSprites/MirrorBLTR2.png")
		else:
			tex = load("res://Assets/MirrorSprites/MirrorBLTR.png")
	$Sprite2D.texture = tex;
