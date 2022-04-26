extends Node2D

func _ready() -> void:
	randomize()

	$GameOfLife.generate_soup()
	$Board.draw_board($GameOfLife.boards[0])
	$Camera.default_position = $Board.get_used_rect().size * $Board.cell_size / 2
	$Camera.reset_position()
	$Timer.start()
