extends Sprite2D

@export var key_name: String = ""
@onready var hitzone = $Area2D

const PERFECT_DIST = 10.0
const GREAT_DIST = 25.0
const GOOD_DIST = 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(key_name):
		var overlapping_area = hitzone.get_overlapping_areas()
		if overlapping_area.size() > 0:
			var note = overlapping_area[0].get_parent()
			calculate_grade(note)
		else:
			print("Miss: ",key_name)
		#debug
		#print(key_name)
		

func calculate_grade(note: Node2D):
	# Measure vertical distance between the note and this listener
	var distance = abs(note.global_position.y - global_position.y)
	
	if distance <= PERFECT_DIST:
		print("PERFECT!")
	elif distance <= GREAT_DIST:
		print("GREAT")
	elif distance <= GOOD_DIST:
		print("GOOD")
	else:
		print("MEH/LATE")
	
	# Remove the note after it is hit
	note.queue_free()

#func spawn_note():
	#var note = falling_key.instantiate()
	#note.global_position = Vector2(global_position.x, -100)
	#owner.add_child(note)
