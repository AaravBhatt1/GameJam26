extends Node2D

# true is top left to bottom right of the cell
@export var direction:bool = true

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
	
