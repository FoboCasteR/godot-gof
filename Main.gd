extends Node2D


var thread: Thread
var semaphore: Semaphore
var exit_thread := false


func _ready() -> void:
	randomize()

	$GameOfLife.generate_soup()
	$Board.draw_board($GameOfLife.boards[0])
	$Camera.default_position = $Board.get_used_rect().size * $Board.cell_size / 2
	$Camera.reset_position()

	thread = Thread.new()
	semaphore = Semaphore.new()
	# warning-ignore:return_value_discarded
	thread.start(self, "tick", null, Thread.PRIORITY_LOW)

func _exit_tree():
	exit_thread = true
	# warning-ignore:return_value_discarded
	semaphore.post()
	thread.wait_to_finish()


func _on_Timer_timeout():
	# warning-ignore:return_value_discarded
	semaphore.post()
	$Board.draw_board($GameOfLife.boards[0])

func tick(_userdata):
	while !exit_thread:
		# warning-ignore:return_value_discarded
		semaphore.wait()
		$GameOfLife.next_generation()
