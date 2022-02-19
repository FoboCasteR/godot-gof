extends Camera2D

export var SPEED : = 500
var default_position : = Vector2.ZERO

func _process(delta: float) -> void:
	var move_by : Vector2

	if Input.is_action_pressed("ui_up"):
		move_by = Vector2.UP * SPEED * delta

	if Input.is_action_pressed("ui_down"):
		move_by = Vector2.DOWN * SPEED * delta

	if Input.is_action_pressed("ui_right"):
		move_by = Vector2.RIGHT * SPEED * delta

	if Input.is_action_pressed("ui_left"):
		move_by = Vector2.LEFT * SPEED * delta

	position += move_by.round()

func _unhandled_input(event: InputEvent) -> void:
	var motion_event := event as InputEventMouseMotion

	if motion_event and motion_event.button_mask == BUTTON_MASK_MIDDLE:
		position -= motion_event.relative

	if event.is_action_pressed("ui_select"):
		reset_position()

func reset_position() -> void:
	position = default_position
