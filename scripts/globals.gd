extends Node

# Date Values
var today: Dictionary
var end_of_month: int

# Resources
var font: Resource = load("res://assets/Stacked pixel.ttf")

# App Data
var user_dir: String = "res://user-data/"
var all_habits_data: Dictionary


func _init() -> void:
	# get today's date and calculate the last day of the month
	today = Time.get_date_dict_from_system()
	var eom: Dictionary = today.duplicate()

	if eom["month"] == 12:
		eom["year"] += 1
		eom["month"] = 1
	else:
		eom["month"] += 1

	eom["day"] = 1

	var eom_unix = (Time.get_unix_time_from_datetime_dict(eom)) - 1000
	end_of_month = (Time.get_date_dict_from_unix_time(eom_unix))["day"]
