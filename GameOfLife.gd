extends Node


export(int, 3, 100) var width := 10
export(int, 3, 100) var height := 10
export(String) var rulestring := "B3/S23" setget set_rulestring

signal next_generation(board)

var boards := []
var birth_number_list := 0b0_0000_1000
var survive_number_list := 0b0_0000_1100
var neighbourhood: MooreNeighbourhood = MooreNeighbourhood.new()


class MooreNeighbourhood:
	const OFFSETS = [
		Vector2(-1, -1),
		Vector2(-1, 0),
		Vector2(-1, 1),
		Vector2(0, -1),
		Vector2(0, 1),
		Vector2(1, -1),
		Vector2(1, 0),
		Vector2(1, 1),
	]

	func count(board: Array, coords: Vector2, borders: Vector2) -> int:
		var count := 0

		for offset in OFFSETS:
			var new_coords = coords + offset

			if new_coords.y < 0 or new_coords.y >= borders.y:
				continue

			if new_coords.x < 0 or new_coords.x >= borders.x:
				continue

			if board[new_coords.y][new_coords.x]:
				count += 1

		return count


func _ready():
	create_boards()


func set_rulestring(value: String) -> void:
	var regex = RegEx.new()
	regex.compile("B(?<birth>.*)\/S(?<survive>.*)")

	var regex_match = regex.search(value)

	if regex_match:
		birth_number_list = 0
		survive_number_list = 0
		rulestring = value

		for digit in regex_match.get_string("birth"):
			birth_number_list |= 1 << int(digit)

		for digit in regex_match.get_string("survive"):
			survive_number_list |= 1 << int(digit)
	else:
		printerr('Invalid rulestring')


func create_boards() -> void:
	for i in 2:
		var board := []

		for j in height:
			var row := []
			row.resize(width)
			board.append(row)

		boards.append(board)


func next_generation():
	var front_board := boards[0] as Array
	var back_board := boards[1] as Array
	var borders := Vector2(width, height)

	for y in height:
		var row := front_board[y] as Array

		for x in width:
			var neighbor_count := neighbourhood.count(front_board, Vector2(x, y), borders)

			if row[x]:
				back_board[y][x] = survive_number_list & 1 << neighbor_count
			else:
				back_board[y][x] = birth_number_list & 1 << neighbor_count

	boards.invert()

	emit_signal("next_generation", front_board)


func generate_soup():
	var h_boundary = range(floor(width * 0.33), ceil(width * 0.67))
	var v_boundary = range(floor(height * 0.33), ceil(height * 0.67))
	var front_board := boards[0] as Array

	for y in h_boundary:
		var row := front_board[y] as Array

		for x in v_boundary:
			if int(randf() > 0.8):
				row[x] = true
