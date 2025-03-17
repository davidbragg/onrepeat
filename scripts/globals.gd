extends Node

# Date Values
var today: Dictionary
var end_of_month: int
var header_date: String
var month_name: Dictionary = {
	1: "jan",
	2: "feb",
	3: "mar",
	4: "apr",
	5: "may",
	6: "jun",
	7: "jul",
	8: "aug",
	9: "sep",
	10: "oct",
	11: "nov",
	12: "dec"
}

# Resources
var font: Resource = load("res://assets/Stacked pixel.ttf")
var font_size: int = 20

# App Data
var user_dir: String = "user://"
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

	header_date = str(month_name[today["month"]], " ", today["year"])
