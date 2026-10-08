extends Area2D
class_name Bubble

const TRANS_LEFT: int = 0
const TRANS_RIGHT: int = 1
const SPEED: int = 100
const ABS_MAX_HT: int = 50
const ABS_MIN_HT: int = 20
var maxHorizontalTranslation: int
var translationDirection: int
var originalXPos;

@onready
var sprite: Sprite2D = $Sprite2D

func on_clicked(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pop();

		
func pop():
	queue_free();

	
func setup_horizontal_translation():
	maxHorizontalTranslation = randi_range(ABS_MIN_HT, ABS_MAX_HT)
	print(maxHorizontalTranslation)
	if randi_range(1, 2) % 2 == 0:
		translationDirection = TRANS_LEFT
	else:
		translationDirection = TRANS_RIGHT

		
func setup_initial_position(bubble_scale: float):
	originalXPos = randi_range(100, 1100)
	position.x = originalXPos
	position.y = get_viewport().size.y + (sprite.get_rect().size.y * bubble_scale)
	
func process_horizontal_translation():
	var curX: float = position.x;
	if translationDirection == TRANS_LEFT:
		if curX - 1 >= originalXPos - maxHorizontalTranslation:
			position.x = curX - 1;
		else:
			translationDirection = TRANS_RIGHT
			position.x = curX + 1;

	if translationDirection == TRANS_RIGHT:
		if curX + 1 <= originalXPos + maxHorizontalTranslation:
			position.x = curX + 1;
		else:
			translationDirection = TRANS_LEFT
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
	process_horizontal_translation()
	