extends TileMap


func draw_board(board: Array):
	var height := board.size()
	var width := (board[0] as Array).size()

	for y in height:
		var row := board[y] as Array

		for x in width:
			if row[x]:
				set_cell(x, y, 0)
			else:
				set_cell(x, y, -1)
