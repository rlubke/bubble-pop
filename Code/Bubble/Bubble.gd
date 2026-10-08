extends Area2D
class_name Bubble

const TRANS_LEFT: int = 0
const TRANS_RIGHT: int = 1
const SPEED: int = 100
const ABS_MAX_HT: int = 50
const ABS_MIN_HT: int = 20

@onready
var sprite: Sprite2D = $Sprite2D

@onready
var audio_system: AudioStreamPlayer2D

var max_horizontal_translation: int
var translation_direction: int
var original_x_pos: float;

func on_clicked(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pop();

		
func pop():
	audio_system.position = position
	audio_system.play()
	queue_free();

	
func setup_horizontal_translation():
	max_horizontal_translation = randi_range(ABS_MIN_HT, ABS_MAX_HT)

	if randi_range(1, 2) % 2 == 0:
		translation_direction = TRANS_LEFT
	else:
		translation_direction = TRANS_RIGHT

		
func setup_initial_position(bubble_scale: float):
	original_x_pos = randf_range(0, get_viewport().size.x)
	position.x = original_x_pos
	
	# There's a probably a better way to do this
	# put bubble's initial y position to be just below
	# the viewport based on the scaled size of the image.
	position.y = get_viewport().size.y + (sprite.get_rect().size.y * bubble_scale)
	

func process_horizontal_translation():
	var curX: float = position.x;
	if translation_direction == TRANS_LEFT:
		if curX - 1 >= original_x_pos - max_horizontal_translation:
			position.x = curX - 1;
		else:
			translation_direction = TRANS_RIGHT
			position.x = curX + 1;

	if translation_direction == TRANS_RIGHT:
		if curX + 1 <= original_x_pos + max_horizontal_translation:
			position.x = curX + 1;
		else:
			translation_direction = TRANS_LEFT
			position.x = curX - 1;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(on_clicked)

	# set scale
	var s: float = randf_range(0.1, .7)
	set_scale(Vector2(s, s))

	# set coordinates
	setup_initial_position(s)
	
	setup_horizontal_translation()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= SPEED * delta # pixes / frame
	
	# If the bubble has reached the top, 'pop' to free memory,
	# otherwise continue with horizontal translation processing.
	if (position.y < 0):
		pop()
	else:
		process_horizontal_translation()
	