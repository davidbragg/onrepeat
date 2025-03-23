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

# Theme Colours
var almost_black = Color.hex(0x191919ff)
var greyish_brown = Color.hex(0x615e4bff)
var cerise = Color.hex(0xf3005fff)
var darkish_pink = Color.hex(0xf3488bff)
var purpley = Color.hex(0x9c64feff)
var greyish = Color.hex(0xc4c4b5ff)
var egg_shell = Color.hex(0xf0ebafff)
var twilight = Color.hex(0x3a255fff)

var background_color: Color = almost_black
var header_color: Color = greyish_brown
var header_text: Color = darkish_pink
var odd_row_color: Color = greyish
var odd_row_text: Color = twilight
var even_row_color: Color = greyish_brown
var even_row_text: Color = egg_shell


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
