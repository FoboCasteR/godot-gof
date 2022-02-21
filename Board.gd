extends TileMap

export(int) var alive_tile_id = 1
export(int) var dead_tile_id = 0

func draw_board(board: Array):
	var height := board.size()
	var width := (board[0] as Array).size()

	for y in height:
		var row := board[y] as Array

		for x in width:
			if row[x]:
				set_cell(x, y, alive_tile_id)
			else:
				set_cell(x, y, dead_tile_id)
