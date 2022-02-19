extends Node

export(int, 3, 1000) var width : = 10
export(int, 3, 1000) var height : = 10
export(String) var rulestring := "B3/S23" setget set_rulestring

signal next_generation(board)

var boards: Array = []
var birth_number_list: Array = [3]
var survive_number_list: Array = [2, 3]

func _ready():
	create_boards()

func set_rulestring(value: String) -> void:
	var regex = RegEx.new()
	regex.compile("B(?<birth>.*)\/S(?<survive>.*)")

	var regex_match = regex.search(value)

	birth_number_list = []
	survive_number_list = []

	if regex_match:
		for digit in regex_match.get_string("birth"):
			birth_number_list.append(int(digit))

		for digit in regex_match.get_string("survive"):
			survive_number_list.append(int(digit))

func create_boards() -> void:
	for i in 2:
		var bitmap = BitMap.new()
		bitmap.create(Vector2(width, height))
		boards.append(bitmap)

func count_neighbours(row: int, col: int) -> int:
	var count := 0

	for row_offset in [-1, 0, 1]:
		for col_offset in [-1, 0, 1]:
			if row_offset == 0 and col_offset == 0:
				continue

			var new_row := row + row_offset as int
			if new_row < 0 or new_row >= height:
				continue

			var new_col := col + col_offset as int
			if new_col < 0 or new_col >= width:
				continue

			if boards[0].get_bit(Vector2(new_col, new_row)):
				count += 1

	return count

func next_generation():
	for row in height:
		for col in width:
			boards[1].set_bit(Vector2(col, row), next_cell_state(row, col))
	boards.invert()
	emit_signal("next_generation", boards[0])

func next_cell_state(row: int, col: int) -> bool:
	var neighbor_count := count_neighbours(row, col)

	if boards[0].get_bit(Vector2(col, row)):
		return survive_number_list.has(neighbor_count)
	else:
		return birth_number_list.has(neighbor_count)

func generate_soup():
#	# Glider:
#	for v in [Vector2(1, 0), Vector2(2, 1), Vector2(0, 2), Vector2(1, 2), Vector2(2, 2)]:
#		boards[0].set_bit(v, true)

	var h_boundary = range(floor(width * 0.33), ceil(width * 0.67))
	var v_boundary = range(floor(height * 0.33), ceil(height * 0.67))

	for row in h_boundary:
		for col in v_boundary:
			if int(randf() > 0.8):
				boards[0].set_bit(Vector2(col, row), true)
