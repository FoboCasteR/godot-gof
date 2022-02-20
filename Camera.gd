extends Camera2D


const ZOOM = [1, 2, 4]

export var SPEED : = 500
var default_position : = Vector2.ZERO
var zoom_level : = 0


func _process(delta: float) -> void:
	var direction := Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		direction += Vector2.UP

	if Input.is_action_pressed("move_down"):
		direction += Vector2.DOWN

	if Input.is_action_pressed("move_right"):
		direction += Vector2.RIGHT

	if Input.is_action_pressed("move_left"):
		direction += Vector2.LEFT

	position += (direction.normalized() * SPEED * delta).round()


func _unhandled_input(event: InputEvent) -> void:
	var motion_event := event as InputEventMouseMotion

	if motion_event and motion_event.button_mask == BUTTON_MASK_MIDDLE:
		position -= motion_event.relative

	if event.is_action_pressed("ui_select"):
		reset_position()

	if event.is_action_pressed("zoom_out"):
		zoom_level += 1

	if event.is_action_pressed("zoom_in"):
		zoom_level -= 1

	zoom_level = clamp(zoom_level, 0, len(ZOOM) - 1)
	zoom = Vector2(ZOOM[zoom_level], ZOOM[zoom_level])


func reset_position() -> void:
	position = default_position
	zoom = Vector2.ONE
