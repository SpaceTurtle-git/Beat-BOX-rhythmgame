extends Node2D

@export var falling_key_scene = preload("res://scenes/falling_key.tscn")
@onready var midi_player = $MidiPlayer 
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var lane_map = {
	0: 490, # Lane 0 (Left)
	1: 590, # Lane 1 (Down)
	2: 690, # Lane 2 (Up)
	3: 790  # Lane 3 (Right)
}

func _ready() -> void:
	var distance = 650 - (-100)
	var temp_note = falling_key_scene.instantiate()
	var speed = temp_note.fall_speed
	temp_note.queue_free() # Clean up the dummy
	var timing_offset = (distance / speed) / Engine.physics_ticks_per_second
	midi_player.play()
	await get_tree().create_timer(timing_offset).timeout
	audio_player.play()

func spawn_note_at_lane(pitch: int):
	var lane_index = pitch % 4 
	var target_x = lane_map[lane_index]
	var note = falling_key_scene.instantiate()
	
	# Set position and add to scene
	note.global_position = Vector2(target_x, -100)
	add_child(note)
	
	# Assign the correct Sprite Frame (0, 1, or 2) based on the pitch
	if note is Sprite2D:
		match lane_index:
			0: note.frame = 4 # First arrow type
			1: note.frame = 5 # Second arrow type
			2: note.frame = 6 # Third arrow type
			3: note.frame = 7 # Wrap back or use a 4th if you expand Vframes

func _on_midi_player_midi_event(_channel: Variant, event: Variant) -> void:
	# Using 144 as confirmed for Note On events
	if _channel.number == 0:
		if event.type == 144:
			if event.velocity > 0:
				spawn_note_at_lane(event.note)
