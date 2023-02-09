extends Node
const FILE_NAME = "res://PuzzleInput.txt"
const NEW_FISH_TIMER = 8
const PARENT_FISH_TIMER = 6
const CYCLES = 256

var fish_array:Array = []
var fish_array_2:Array = [0,0,0,0,0,0,0,0,0]

#-------------------------------------------------------------------------------
func _ready()->void:
	if check_data_exists():
		fish_array = get_input_data()
		sort_data(fish_array,fish_array_2)
		for x in CYCLES:
			var parent_fish_count = fish_array_2[0]
			deplete_fish_data_2()
			fish_array_2[8] = parent_fish_count
			fish_array_2[6] += parent_fish_count
		var total_count = get_count(fish_array_2)
		print(total_count)
			
#		for x in CYCLES:
#			var parent_indices:Array = get_birth_indices(fish_array)
#			reduce_fish(fish_array)
#			if parent_indices != []:
#				set_parent_fish_timers(parent_indices)
#				add_baby_fish(parent_indices)
#		print(fish_array.size())

func get_count(data:Array)->int:
	var total:int = 0
	for x in data.size():
		total += data[x]
	return total

func sort_data(origin_data:Array,bin_array:Array)->void:
	for x in origin_data.size():
		bin_array[origin_data[x]] += 1
		
func deplete_fish_data_2()->void:
	var copy = fish_array_2.duplicate(true)
	for x in fish_array_2.size()-1:
		fish_array_2[x] = copy[x+1]


func check_data_exists()->bool: #this works
	var file = File.new()
	if file.file_exists(FILE_NAME):
		print("located puzzle input...")
		return true
	else:
		print("ERROR: no puzzle input located...")
		return false

func get_input_data()->Array: #this works
	var file = File.new()
	file.open(FILE_NAME,File.READ)
	var raw_data:String = file.get_line()
	var data_array:Array = []
	for x in raw_data:
		if x == ",":
			continue
		data_array.append(int(x))
	return data_array

func get_birth_indices(data:Array)->Array: #seems to work
	var indices:Array = []
	for x in data.size():
		if data[x] == 0:
			indices.append(x)
	return indices

func set_parent_fish_timers(indices:Array)->void: #all zeros,good; turn them all into 6
	for x in indices:
#		print(fish_array[x])
		fish_array[x] = PARENT_FISH_TIMER
#		print(fish_array[x])

func add_baby_fish(parent_array:Array)->void:
	for x in parent_array.size():
#		print(parent_array.size())
		fish_array.append(NEW_FISH_TIMER)

func reduce_fish(fish:Array)->void: #this seems to be working
	for x in fish.size():
#		print(fish[x])
		fish[x] -= 1
#		print(fish[x])
