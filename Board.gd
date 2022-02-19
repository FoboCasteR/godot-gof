extends TileMap

export(int) var alive_tile_id = 1
export(int) var dead_tile_id = 0

func draw_board(board: BitMap):
	var size = board.get_size()

	for row in size.y:
		for col in size.x:
			if board.get_bit(Vector2(col, row)):
				set_cell(col, row, alive_tile_id)
			else:
				set_cell(col, row, dead_tile_id)
