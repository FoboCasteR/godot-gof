extends Camera2D


const ZOOM = [1, 2, 4]

export var SPEED := 500

var default_position := Vector2.ZERO
var zoom_level := 0 setget set_zoom_level


func _process(delta: float) -> void:
	var direction = Vector2(
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
		int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	)

	position += (direction.normalized() * SPEED * delta).round()


func _unhandled_input(event: InputEvent) -> void:
	var motion_event := event as InputEventMouseMotion
	var gesture_event := event as InputEventPanGesture

	if motion_event and motion_event.button_mask == BUTTON_MASK_MIDDLE:
		position -= motion_event.relative

	if gesture_event:
		position += gesture_event.delta * 10

	if event.is_action_pressed("ui_select"):
		reset_position()

	if event.is_action_pressed("zoom_out"):
		self.zoom_level += 1

	if event.is_action_pressed("zoom_in"):
		self.zoom_level -= 1


func set_zoom_level(value: int) -> void:
	zoom_level = clamp(value, 0, len(ZOOM) - 1) as int
	zoom = Vector2(ZOOM[zoom_level], ZOOM[zoom_level])


func reset_position() -> void:
	position = default_position
	zoom = Vector2.ONE
