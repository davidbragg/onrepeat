extends Node

# Date Values
var today: Dictionary
var end_of_month: int
var header_date: String
var month_name: Dictionary = { 1: "january", 2: "february", 3: "march", 4: "april", 5: "may", 6: "june", 7: "july", 8: "august", 9: "september", 10: "october", 11: "november", 12: "december" }

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

	header_date = str(month_name[today["month"]], " ", today["year"])
