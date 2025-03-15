extends Control

@onready var curr_date: Dictionary = Time.get_date_dict_from_system()
var end_of_month: int
var min_size: Vector2 = Vector2(1132, 20)
var double_row: bool = false


func _ready() -> void:
	calc_last_day_of_month()

	# populate the header
	var header_rect = ColorRect.new()
	header_rect.color = Color.NAVY_BLUE
	header_rect.custom_minimum_size = min_size
	var header_hbox = HabitHBox.new("march 2025", curr_date["day"], curr_date, end_of_month)
	header_hbox.populate_header()
	header_rect.add_child(header_hbox)
	$VBoxContainer.add_child(header_rect)

	# populate habits
	var habits = load_habit()
	for habit in habits:
		var row_rect = ColorRect.new()
		row_rect.color = Color.DARK_SLATE_GRAY
		row_rect.custom_minimum_size = min_size
		var habit_hbox = HabitHBox.new(habit["title"], curr_date["day"], curr_date, end_of_month)
		habit_hbox.populate_der_habit(habit)
		row_rect.add_child(habit_hbox)
		$VBoxContainer.add_child(row_rect)

func calc_last_day_of_month() -> void:
	var eom: Dictionary = curr_date.duplicate()
	eom["month"] += 1
	eom["day"] = 1
	var eomUnix = (Time.get_unix_time_from_datetime_dict(eom)) - 1000
	end_of_month = (Time.get_date_dict_from_unix_time(eomUnix))["day"]

func load_habit() -> Array:
	if not FileAccess.file_exists("res://onrepeat"):
		push_error("whoopsie. made an oopsie.")
		return []

	var file = FileAccess.open("res://onrepeat", FileAccess.READ)
	var habit_data: String = file.get_as_text()
	var json = JSON.new()
	json.parse(habit_data)
	var habit_dict = json.data
	return(habit_dict)
