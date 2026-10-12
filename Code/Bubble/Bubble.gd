extends Area2D
class_name Bubble

# translating left
const TRANS_LEFT := 0

# translating right
const TRANS_RIGHT := 1

# max # of pixes a bubble may move left/right of its original x position
const ABS_MAX_HT := 100

# min # of pixes a bubble may move left/right of its original x position
const ABS_MIN_HT := 20

@onready
var sprite: Sprite2D = $Sprite2D

var audio_system: AudioStreamPlayer2D;

var stream: AudioStream
var main: Main

var max_horizontal_translation: int
var translation_direction: int
var original_x_pos: float;
var sprite_half_length: float;
var speed: int;

# Left mouse button will pop bubbles.
func on_clicked(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pop(true);


# Pops the bubble.  If scored is 'true', the score will be increased,
# otherwise the score remains unchanged.
func pop(scored: bool):
	audio_system.position = position
	audio_system.stream = stream
	audio_system.pitch_scale = randf_range(.8, 1.2)
	audio_system.play()
	
	if scored:
		main.change_score(1)
	else:
		main.change_score(-1)

	queue_free();


# calculates max horizontal translation length.
func update_max_horizontal_translation(factor: int = 1):
	max_horizontal_translation = randi_range(ABS_MIN_HT * factor, ABS_MAX_HT * factor)


# setup variables for horizontal translation
func setup_horizontal_translation():
	update_max_horizontal_translation()

	if randi_range(1, 2) % 2 == 0:
		translation_direction = TRANS_LEFT
	else:
		translation_direction = TRANS_RIGHT


# initialize initial position of the bubble.
func setup_initial_position(bubble_scale: float):
	original_x_pos = randf_range(0, get_viewport().size.x)
	position.x = original_x_pos
	sprite_half_length = (sprite.get_rect().size.x / 2) * bubble_scale
	
	if position.x - sprite_half_length < 0:
		position.x = sprite_half_length;
	elif position.x + sprite_half_length > get_viewport().size.x:
		position.x = get_viewport().size.x - sprite_half_length
	
	position.y = (get_viewport().size.y + ((sprite.get_rect().size.y * bubble_scale)) / 2)

# moves the bubbles left/right as they move up the viewport.
func process_horizontal_translation():
	var curX: float = position.x;
	if translation_direction == TRANS_LEFT:
		if curX - sprite_half_length - 1 <= 0:
			translation_direction = TRANS_RIGHT
			# on direction change, vary max translation
			update_max_horizontal_translation(3)
			position.x = curX + 1;
		elif curX - 1 >= original_x_pos - max_horizontal_translation:
			position.x = curX - 1;
		else:
			translation_direction = TRANS_RIGHT
			# on direction change, vary max translation
			update_max_horizontal_translation()
			position.x = curX + 1;

	elif translation_direction == TRANS_RIGHT:
		if curX + sprite_half_length + 1 >= get_viewport().size.x:
			translation_direction = TRANS_LEFT
			# on direction change, vary max translation
			update_max_horizontal_translation(3)
			position.x = curX - 1;
		if curX + 1 <= original_x_pos + max_horizontal_translation:
			position.x = curX + 1;
		else:
			translation_direction = TRANS_LEFT
			# on direction change, vary max translation
			update_max_horizontal_translation()
			position.x = curX - 1;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(on_clicked)

	# set scale
	var s: float = randf_range(0.1, .8)
	set_scale(Vector2(s, s))
	
	# set random speed
	speed = randi_range(75, 200)

	# set coordinates
	setup_initial_position(s)

	setup_horizontal_translation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= speed * delta # pixes / frame

	# If the bubble has reached the top, 'pop' to free memory,
	# otherwise continue with horizontal translation processing.
	if (position.y < 0):
		pop(false)
	else:
		process_horizontal_translation()
