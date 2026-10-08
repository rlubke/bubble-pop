extends Node
class_name Main

var bubbles

const BUBBLE: PackedScene = preload("res://Bubble/Bubble.tscn")

@onready
var audio_system = $AudioSystem

func blow_bubble():
	var bubble: Bubble = BUBBLE.instantiate();
	bubble.audio_suystem = audio_system
	add_child(BUBBLE.instantiate())

func _ready() -> void:
	for i in range(1000):
		blow_bubble()
		
		# create a random timer that will pause the loop at random intervals
		await get_tree().create_timer(randf_range(.5, 2)).timeout
