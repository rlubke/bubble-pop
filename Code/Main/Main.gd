extends Node
class_name Main

var bubbles

const BUBBLE: PackedScene = preload("res://Bubble/Bubble.tscn")

var pop_sounds

@onready
var audio_system: AudioStreamPlayer2D = $AudioSystem

func preload_audio_files():
	pop_sounds = []
	for i in range(0, 12):
		var path: String = "res://Sfx/"

		if i < 10:
			path += ("pop_0" + str(i))
		else:
			path += ("pop_" + str(i))
			
		path += ".wav"
		
		pop_sounds.append(load(path))
		print(pop_sounds)
		

func blow_bubble():
	var bubble: Bubble = BUBBLE.instantiate();

	# pass on references to the audio_system and assign a random
	# pop wav to stream
	bubble.audio_system = audio_system
	bubble.stream = pop_sounds[randi_range(0, 11)]

	add_child(bubble)


func _ready() -> void:
	preload_audio_files()
	print(pop_sounds)
	for i in range(1000):
		blow_bubble()
		
		# create a random timer that will pause the loop at random intervals
		await get_tree().create_timer(randf_range(.5, 2)).timeout
