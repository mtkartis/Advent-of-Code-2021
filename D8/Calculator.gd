extends Node

const FILE_NAME = "res://PuzzleInput.txt"
const ZERO = 6
const ONE = 2
const TWO = 5
const THREE = 5
const FOUR = 4
const FIVE = 5
const SIX = 6
const SEVEN = 3
const EIGHT = 7
const NINE = 6

var segment_dictionary:Dictionary = {
	"top":"",
	"top_left":"",
	"top_right":"",
	"middle":"",
	"bottom_left":"",
	"bottom_right":"",
	"bottom":"",
}

var dependent_number_structures:Array = []

var count_1478:int = 0
var total:int = 0

var puzzle_input:Array = [] #[line][segment][digits] #segment 0 has 10 digits, segment 1 has 4 digits

func _ready():
	if puzzle_exists():
		puzzle_input = get_puzzle_input()
#		print(puzzle_input[-1][1])
#		count_1478 += get_all_of_digit(ONE)
#		count_1478 += get_all_of_digit(FOUR)
#		count_1478 += get_all_of_digit(SEVEN)
#		count_1478 += get_all_of_digit(EIGHT)
#		print(count_1478)
		for x in puzzle_input.size():
			get_segment_wiring_diagram(puzzle_input[x][0])
			dependent_number_structures = get_dependent_numbers_from_diagram()
#			print(get_dependent_numbers_from_diagram())
			var line_block:String = ""
			for i in puzzle_input[x][1].size():
				
				for d in dependent_number_structures.size():
					if is_matching_digit(puzzle_input[x][1][i],dependent_number_structures[d]):
						line_block = line_block + String(d)
						break
			print(line_block)
			total += int(line_block)
			clear_segment_dict()
			dependent_number_structures = []
		print(total)

func is_matching_digit(digit:String,map:String)->bool:
	if digit.length() == map.length():
		for x in digit:
	#		print(x)
			if map.find(x) > -1:
				continue
			else:
				return false
		return true
	else:
		return false
	

func puzzle_exists()->bool: #works
	var file = File.new()
	if file.file_exists(FILE_NAME):
		return true
	else:
		return false

func get_puzzle_input()->Array: #works
	var file = File.new()
	file.open(FILE_NAME,File.READ)
	var clean_line_array:Array = []
	while file.get_position() < file.get_len():
		var raw:Array = (file.get_csv_line("|"))
		var digit_map:Array = []
		var display_digits:Array = []
		var refined_section:Array = []
		var chunk:String = ""
		for x in raw.size():
			match x:
				0:
					for i in raw[x]:
						match i:
							" ":
								digit_map.append(chunk)
								chunk = ""
							_:
								chunk += i
#					digit_map.append(chunk)
#					chunk = ""
				1:
					for i in raw[x]:
						match i:
							" ":
								display_digits.append(chunk)
								chunk = ""
							_:
								chunk += i
					display_digits.append(chunk)
					chunk = ""
					
		refined_section.append(digit_map)
		refined_section.append(display_digits)
		clean_line_array.append(refined_section)
	return clean_line_array

func get_all_of_digit(segment_n:int)->int: #works
	var n:int = 0
	for x in puzzle_input.size():
		for i in puzzle_input[x][1]:
			if i.length() == segment_n:
				n += 1
	return n

func get_segment_wiring_diagram(segments:Array)->void:
	var one:String = ""
	var four:String = ""
	var seven:String = ""
	var eight:String = ""
	var six_segments:Array = [] #two slots
	var five_segments:Array = [] #three slots
	for x in segments.size():
		match segments[x].length():
			ONE:
				one = segments[x]
			FOUR:
				four = segments[x]
			SEVEN:
				seven = segments[x]
			EIGHT:
				eight = segments[x]
			FIVE:
				five_segments.append(segments[x])
			SIX:
				six_segments.append(segments[x])
#	print(one)
#	print(four)
#	print(seven)
	var top:Array = [] #one slot
	var r_side:Array = [] #two slots
	var mid_top_l:Array = [] #two slots
	var bottom_bot_l:Array = [] #two slots
	for i in seven:
		if one.find(i) == -1:
			top.append(i)
		else:
			r_side.append(i)
	for i in four:
		if i == r_side[0] or i == r_side[1]:
			continue
		else:
			mid_top_l.append(i)
	for i in eight:
		if i == top[0] or i == r_side[0] or i == r_side[1] or i == mid_top_l[0] or i == mid_top_l[1]:
			continue
		else:
			bottom_bot_l.append(i)
#	print(top)
#	print(r_side)
#	print(mid_top_l)
#	print(bottom_bot_l)
	
	var middle:Array = []
	var a:Array = []
	for x in five_segments.size():
		for i in five_segments[x]:
			if i == top[0] or i == r_side[0] or i == r_side[1] or i == bottom_bot_l[0] or i == bottom_bot_l[1]:
				continue
			else:
				a.append(i)
		if a.size() < 2:
			middle.append(a[0])
			break
		else:
			a = []
#	print(middle)
	
	var top_l:Array = []
	for x in five_segments.size():
		for i in five_segments[x]:
			if i == top[0] or i == r_side[0] or i == r_side[1] or i == bottom_bot_l[0] or i == bottom_bot_l[1] or i == middle[0]:
				continue
			else:
				top_l.append(i)
#	print(top_l)
	
	var bottom:Array = [] #idk about this one
	for x in six_segments.size():
		for i in six_segments[x]:
			if i == top[0] or i == r_side[0] or i == r_side[1] or i == middle[0] or i == top_l[0] :
				continue
			else:
				bottom.append(i)
		if bottom.size() < 2:
			break
		else:
			bottom = []
#	print(bottom)
	
	var bot_l:Array = []
	for x in five_segments.size():
		for i in five_segments[x]:
			if i == top[0] or i == r_side[0] or i == r_side[1] or i == middle[0] or i == top_l[0] or i == bottom[0]:
				continue
			else:
				bot_l.append(i)
#	print(bot_l)
	
	var top_r:Array = []
	for x in five_segments.size():
#		print("A")
#		print(five_segments[x].find(top[0]))
		if five_segments[x].find(top[0]) > -1:
#			print("B")
#			print(five_segments[x].find(middle[0]))
			if five_segments[x].find(middle[0]) > -1:
#				print("C")
#				print(five_segments[x].find(bot_l[0]))
				if five_segments[x].find(bot_l[0]) > -1:
#					print("D")
#					print(five_segments[x].find(bottom[0]))
					if five_segments[x].find(bottom[0]) > -1:
#						print("E")
#						print("TWO: ",five_segments[x])
						for i in five_segments[x]:
							if i == top[0] or i == middle[0] or i == bot_l[0] or i == bottom[0]:
								continue
							else:
								top_r.append(i)
								break
#	print(top_r)
	
	var bot_r:Array = []
	for x in one:
		if x == top_r[0]:
			continue
		else:
			bot_r.append(x)
#	print(bot_r)
	
	segment_dictionary["top"] = top[0]
	segment_dictionary["top_left"] = top_l[0]
	segment_dictionary["top_right"] = top_r[0]
	segment_dictionary["middle"] = middle[0]
	segment_dictionary["bottom_left"] = bot_l[0]
	segment_dictionary["bottom_right"] = bot_r[0]
	segment_dictionary["bottom"] = bottom[0]
#	print(segment_dictionary)

func get_dependent_numbers_from_diagram()->Array:
	var zero
	var one
	var two
	var three
	var four
	var five
	var six
	var seven
	var eight
	var nine
	var clean_array
	
	zero = segment_dictionary.top + segment_dictionary.top_left + segment_dictionary.top_right + segment_dictionary.bottom_left + segment_dictionary.bottom_right + segment_dictionary.bottom
	one = segment_dictionary.top_right + segment_dictionary.bottom_right
	two = segment_dictionary.top + segment_dictionary.top_right + segment_dictionary.middle + segment_dictionary.bottom_left + segment_dictionary.bottom
	three = segment_dictionary.top + segment_dictionary.top_right + segment_dictionary.middle + segment_dictionary.bottom_right + segment_dictionary.bottom
	four = segment_dictionary.top_left + segment_dictionary.middle + segment_dictionary.top_right + segment_dictionary.bottom_right
	five = segment_dictionary.top + segment_dictionary.top_left + segment_dictionary.middle + segment_dictionary.bottom_right + segment_dictionary.bottom
	six = segment_dictionary.top + segment_dictionary.top_left + segment_dictionary.middle + segment_dictionary.bottom_left + segment_dictionary.bottom_right + segment_dictionary.bottom
	seven = segment_dictionary.top + segment_dictionary.top_right + segment_dictionary.bottom_right
	eight = segment_dictionary.top + segment_dictionary.top_left + segment_dictionary.top_right + segment_dictionary.middle + segment_dictionary.bottom_left + segment_dictionary.bottom_right + segment_dictionary.bottom
	nine = segment_dictionary.top + segment_dictionary.top_left + segment_dictionary.top_right + segment_dictionary.middle + segment_dictionary.bottom_right + segment_dictionary.bottom
	clean_array = [zero,one,two,three,four,five,six,seven,eight,nine]
	return clean_array

func clear_segment_dict()->void:
	segment_dictionary= {
	"top":"",
	"top_left":"",
	"top_right":"",
	"middle":"",
	"bottom_left":"",
	"bottom_right":"",
	"bottom":"",
}
