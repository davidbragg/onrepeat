extends HBoxContainer
class_name HabitHBox

var _habit_data: Dictionary
var _current_day: int
var _year_string: String
var _month_string: String

var checkboxes: Array[HabitCheckBox]
var cbox_min_size: Vector2 = Vector2(25, 20)

func _init(habit_data: Dictionary) -> void:
	_habit_data = habit_data
	_current_day = Globals.today["day"]
	_year_string = str(Globals.today["year"])
	_month_string = str(Globals.today["month"])


func _ready() -> void:
	SignalBus.box_toggle.connect(get_checks)
	# connect this to saving habit data

func populate_habit() -> void:
	var habit_label = HabitLabel.new(_habit_data["title"])
	habit_label.populate()
	add_child(habit_label)

	for i in Globals.end_of_month:
		checkboxes.push_back(HabitCheckBox.new())
		checkboxes[i].custom_minimum_size = cbox_min_size
		checkboxes[i].button_pressed = _habit_data[_year_string][_month_string][i]
		if i >= _current_day:
			checkboxes[i].disabled = true
		add_child(checkboxes[i])


func populate_header() -> void:
	var habit_label = HabitLabel.new(_habit_data["title"])
	habit_label.populate()
	add_child(habit_label)

	for i in Globals.end_of_month:
		var day_label = DayLabel.new(str(i + 1))
		day_label.populate()
		if i  == _current_day - 1:
			day_label.self_modulate = Color(55,0,0,1)
		add_child(day_label)

# DEBUG
# this is just a debug method to output an array of checkbox
# states while I'm continuing to test - it will be updated
# to run the habit save behaviour when that is implemented
func get_checks(parent):
	if self == parent:
		var this_month: Array
		for cbox in checkboxes:
			if cbox.button_pressed:
				this_month.push_back(1)
			else:
				this_month.push_back(0)
		print(this_month)
