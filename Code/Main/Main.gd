extends Node
class_name Main

const BUBBLE = preload("res://Bubble/Bubble.tscn")

# list of all pop sounds.
var pop_sounds: Array[Resource]

# score tracking
var score := 0;

@onready
var audio_system: AudioStreamPlayer2D = $AudioSystem

@onready
var label: Label = $UI/Label

# ESC key handling.
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			get_tree().quit()


# Increase and displays score.
func increase_score():
	score += 1
	label.text = str(score)


# Decrease and displays score.
func decrease_score():
	score -= 1
	label.text = str(score)


# Preload all pop way files.
func preload_audio_files():
	pop_sounds = []
	# there's probably a better way to do this, but it's good enough
	# for now.
	for i in range(0, 12):
		var path: String = "res://Sfx/"

		if i < 10:
			path += ("pop_0" + str(i))
		else:
			path += ("pop_" + str(i))
			
		path += ".wav"
		
		pop_sounds.append(load(path))


# "blows" a bubble.
func blow_bubble():
	var bubble: Bubble = BUBBLE.instantiate();

	# pass on references to the audio_system and assign a random
	# pop wav to stream
	bubble.audio_system = audio_system
	bubble.stream = pop_sounds[randi_range(0, 11)]
	
	# forward reference of main
	bubble.main = self;

	add_child(bubble)


func _ready() -> void:
	preload_audio_files()
	
	# another find on the Godot forums - handles the z-index
	# for the bubbles, so the mouse click is handled by the top
	# bubble only.  
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true

	while true:
		blow_bubble()
		
		# create a random timer that will pause the loop at random intervals
		await get_tree().create_timer(randf_range(.2, .6)).timeout
