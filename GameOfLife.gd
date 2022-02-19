extends Node

export(int, 3, 100) var width : = 10
export(int, 3, 100) var height : = 10
export(String) var rulestring := "B3/S23" setget set_rulestring

signal next_generation(board)

var boards: Array = []
var birth_number_list: Array = [3]
var survive_number_list: Array = [2, 3]
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
	
	func count(board: BitMap, coords: Vector2) -> int:
		var border := board.get_size()
		var count := 0

		for offset in OFFSETS:
			var new_coords = coords + offset

			if new_coords.y < 0 or new_coords.y >= border.y:
				continue

			if new_coords.x < 0 or new_coords.x >= border.x:
				continue

			if board.get_bit(new_coords):
				count += 1

		return count


func _ready():
	create_boards()

func set_rulestring(value: String) -> void:
	var regex = RegEx.new()
	regex.compile("B(?<birth>.*)\/S(?<survive>.*)")

	var regex_match = regex.search(value)

	if regex_match:
		birth_number_list = []
		survive_number_list = []
		rulestring = value

		for digit in regex_match.get_string("birth"):
			birth_number_list.append(int(digit))

		for digit in regex_match.get_string("survive"):
			survive_number_list.append(int(digit))

	else:
		printerr('Invalid rulestring')

func create_boards() -> void:
	for i in 2:
		var bitmap = BitMap.new()
		bitmap.create(Vector2(width, height))
		boards.append(bitmap)

func next_generation():
	for row in height:
		for col in width:
			var coords = Vector2(col, row)
			boards[1].set_bit(coords, next_cell_state(coords))
	boards.invert()
	emit_signal("next_generation", boards[0])

func next_cell_state(coords: Vector2) -> bool:
	var neighbor_count := neighbourhood.count(boards[0], coords)

	if boards[0].get_bit(coords):
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
