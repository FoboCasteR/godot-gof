extends Node


var thread: Thread
var semaphore: Semaphore
var exit_thread := false

onready var Board = $Board
onready var Game = $GameOfLife
onready var MainCamera = $Camera


func _ready() -> void:
	randomize()

	Game.generate_soup()
	Board.draw_board(Game.boards[0])
	MainCamera.default_position = Board.map_to_world(Game.get_size() / 2)
	MainCamera.reset_position()

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
	Board.draw_board(Game.boards[0])


func tick(_userdata):
	while !exit_thread:
		# warning-ignore:return_value_discarded
		semaphore.wait()
		Game.next_generation()
