extends HBoxContainer
class_name HabitHBox

var _habit_name: String
var _current_day: int
var _last_day: int
var _year_string: String
var _month_string: String

var checkboxes: Array[HabitCheckBox]
var cbox_min_size: Vector2 = Vector2(25, 20)

func _init(habit_name: String, current_day: int, current_date: Dictionary, last_day: int) -> void:
	_habit_name = habit_name
	_current_day = current_day
	_year_string = str(current_date["year"])
	_month_string = str(current_date["month"])
	_last_day = last_day


func _ready() -> void:
	SignalBus.box_toggle.connect(get_checks)
	# connect this to saving habit data

func populate_checkboxes() -> void:
	var habit_label = HabitLabel.new(_habit_name)
	habit_label.populate()
	add_child(habit_label)

	for i in _last_day:
		checkboxes.push_back(HabitCheckBox.new())
		checkboxes[i].custom_minimum_size = cbox_min_size
		if i >= _current_day:
			checkboxes[i].disabled = true
		add_child(checkboxes[i])

func populate_der_habit(habit_data: Dictionary) -> void:
	var habit_label = HabitLabel.new(_habit_name)
	habit_label.populate()
	add_child(habit_label)

	for i in _last_day:
		checkboxes.push_back(HabitCheckBox.new())
		checkboxes[i].custom_minimum_size = cbox_min_size
		checkboxes[i].button_pressed = habit_data[_year_string][_month_string][i]
		if i >= _current_day:
			checkboxes[i].disabled = true
		add_child(checkboxes[i])

func populate_header() -> void:
	var habit_label = HabitLabel.new(_habit_name)
	habit_label.populate()
	add_child(habit_label)

	for i in _last_day:
		var day_label = DayLabel.new(str(i + 1))
		day_label.populate()
		if i  == _current_day - 1:
			day_label.self_modulate = Color(55,0,0,1)
		add_child(day_label)

func get_checks(parent):
	if self == parent:
		var this_month: Array
		for cbox in checkboxes:
			if cbox.button_pressed:
				this_month.push_back(1)
			else:
				this_month.push_back(0)
		print(this_month)
