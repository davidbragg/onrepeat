extends HBoxContainer
class_name HabitHBox

var _habit_data: Dictionary
var _current_day: int
var _year_string: String
var _month_string: String

var habit_label: HabitLabel
var checkboxes: Array[HabitCheckBox]
var cbox_min_size: Vector2 = Vector2(25, 20)

func _init(habit_data: Dictionary) -> void:
	_habit_data = habit_data
	_current_day = Globals.today["day"]
	_year_string = str(Globals.today["year"])
	_month_string = str(Globals.today["month"])

func _ready() -> void:
	SignalBus.box_toggle.connect(get_checks)

func populate_habit() -> void:
	habit_label = HabitLabel.new(_habit_data["title"])
	habit_label.populate()
	add_child(habit_label)

	# create new if missing habit data for the current month
	if !_habit_data[_year_string].has(_month_string):
		var this_month: Array[int]
		for i in Globals.end_of_month:
			this_month.push_back(0)
		_habit_data[_year_string][_month_string] = this_month
		DataManager.save_habit_data(_habit_data)

	for i in Globals.end_of_month:
		checkboxes.push_back(HabitCheckBox.new())
		checkboxes[i].custom_minimum_size = cbox_min_size
		checkboxes[i].button_pressed = _habit_data[_year_string][_month_string][i]
		if i >= _current_day:
			checkboxes[i].disabled = true
		add_child(checkboxes[i])

func update_habit_title(title: String) -> void:
	_habit_data["title"] = title
	habit_label.text = title
	DataManager.save_habit_data(_habit_data)

func populate_header() -> void:
	habit_label = HabitLabel.new(_habit_data["title"])
	habit_label.populate()
	add_child(habit_label)

	for i in Globals.end_of_month:
		var day_label = DayLabel.new(str(i + 1))
		day_label.populate()
		if i  == _current_day - 1:
			day_label.self_modulate = Color(55,0,0,1)
		add_child(day_label)

# Convert checked boxes to an array of true/false bits and save
func get_checks(parent):
	if self == parent:
		var this_month: Array
		for cbox in checkboxes:
			if cbox.button_pressed:
				this_month.push_back(1)
			else:
				this_month.push_back(0)

		_habit_data[_year_string][_month_string] = this_month
		DataManager.save_habit_data(_habit_data)
