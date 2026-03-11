extends Sprite2D

var fall_speed = 3

func _ready() -> void:
	add_to_group("notes")

func _process(delta: float) -> void:
	position += Vector2(0, fall_speed)
	
	# delete when out of screen
	if position.y > 1100: 
		queue_free()
		print("NATURAL MISS")
