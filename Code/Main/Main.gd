extends Node
class_name Main

var bubbles

const BUBBLE: PackedScene = preload("res://Bubble/Bubble.tscn")

func _ready() -> void:
	for i in range(1000):
		var bubble: Bubble = BUBBLE.instantiate()
		add_child(bubble)
		await get_tree().create_timer(randf_range(.5, 2)).timeout
