extends Node
const FILE_NAME = "res://PuzzleInput.txt"

var submarine_array:Array = []
var median:int = 0
var fuel:int = 0


func _ready()->void:
	if check_data_exists():
		submarine_array = get_input_data()
#		median = get_alignment_position()
		fuel = manual_check()
#		print(submarine_array)
#		print(median)
		print(fuel)

func manual_check()->int:
	var cheapest_route_fuel:Array = []
	for x in submarine_array.size():
		var a = get_fuel_usage(x)
#		print(a)
		cheapest_route_fuel.append(a)
	print(cheapest_route_fuel.find(94813675))
	cheapest_route_fuel.sort()
	return cheapest_route_fuel[0]


func standard_deviation(input:Array)->float: #works
	var n = input.size()
	var standard_dev:float = 0.0
	var mean:float = 0.0
	var numerator:float = 0
	
	for x in input:
		mean += x
	mean = mean/n
	print(mean)
	
	for x in n:
		numerator += pow((input[x]-mean),2)
	standard_dev = sqrt(numerator/n)
	
	print(standard_dev)
	return standard_dev

func get_alignment_position()->int: #works
	submarine_array.sort()
	var x:int = 0
	x = round(standard_deviation(submarine_array))
	return x

func get_fuel_usage(alignment_pos:int)->int:
	var total_fuel:int = 0
	for x in submarine_array.size():
		var sub_distance:int = 0
		sub_distance = abs(alignment_pos - submarine_array[x])
		if sub_distance > 0:
			var fuel_trip:int = 0
			for a in sub_distance:
				fuel_trip += a+1
			total_fuel += fuel_trip
	return total_fuel

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
	var digits:Array = []
	var whole_number:int = 0
	for x in raw_data:
		if x == ",":
			for n in digits.size(): #works
				whole_number += (digits[n]*pow(10,digits.size()-n)/10)
			data_array.append(whole_number)
			digits = []
			whole_number = 0
			continue
		else:
			digits.append(int(x))
	for n in digits.size(): #works
		whole_number += (digits[n]*pow(10,digits.size()-n)/10)
	data_array.append(whole_number)
	digits = []
	whole_number = 0
	return data_array
