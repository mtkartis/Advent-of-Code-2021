extends Node

const FILE_NAME = "res://PuzzleInput.txt"

var puzzle_data:Array = []

var low_points:Array = []

var nines:Array = []


func _ready()->void:
	if file_exists():
		puzzle_data = get_puzzle_input()
		get_lowest_points()
		get_nines()

func file_exists()->bool: #works
	var file = File.new()
	if file.file_exists(FILE_NAME):
		return true
	else:
		return false

func get_puzzle_input()->Array: #works
	var puzzle:Array = []
	var file = File.new()
	file.open(FILE_NAME,File.READ)
	for y in 100:
		puzzle.append([])
		var line = file.get_line()
		for x in line:
			puzzle[y].append(x)
	return puzzle

func get_lowest_points()->void: #works
	for y in puzzle_data.size():
		for x in puzzle_data[y].size():
			var neighbours = get_adjacent_points(Vector2(x,y))
			for i in neighbours.size():
#				print(puzzle_data[y][x])
#				print(neighbours[i])
#				print(puzzle_data[neighbours[i].y][neighbours[i].x])
				if puzzle_data[y][x] >= puzzle_data[neighbours[i].y][neighbours[i].x]:
#					print("HIGHER")
					break
				if i == neighbours.size()-1:
#					print("LOWER")
					low_points.append(Vector2(x,y))

func get_adjacent_points(target:Vector2)->Array: #works
	var adjacent_points:Array = [] #[top,left,right,bottom]
	var up:Vector2 = target + Vector2(0,-1)
	var left:Vector2 = target + Vector2(-1,0)
	var right:Vector2 = target + Vector2(1,0)
	var down:Vector2 = target + Vector2(0,1)
	if up.x > -1 and up.x < 100 and up.y > -1 and up.y < 100:
		adjacent_points.append(up)
	if left.x > -1 and left.x < 100 and left.y > -1 and left.y < 100:
		adjacent_points.append(left)
	if right.x > -1 and right.x < 100 and right.y > -1 and right.y < 100:
		adjacent_points.append(right)
	if down.x > -1 and down.x < 100 and down.y > -1 and down.y < 100:
		adjacent_points.append(down)
	return adjacent_points

func sum_all_lowest_points()->int: #works
	var sum:int = 0
	for i in low_points:
		sum += int(puzzle_data[i.y][i.x])+1
	return sum

func get_nines()->void:
	for y in puzzle_data.size():
		for x in puzzle_data[y].size():
			if int(puzzle_data[y][x]) == 9:
				nines.append(Vector2(x,y))

func get_spacing():
	pass
