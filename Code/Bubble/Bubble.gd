extends Area2D
class_name Bubble

var speed: int = 60;

func on_clicked(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pop();
		
func pop():
	queue_free();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(on_clicked)

	# set scale
	var s: float = randf_range(0.1, .7)
	scale = Vector2(s, s)

	# set coordinates
	position.x = randi_range(100, 1100)
	# position.y = get_viewport().size.y + 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= speed * delta # pixes / frame
	
