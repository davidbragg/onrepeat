extends HBoxContainer
class_name HabitHBox

var _habit_name: String
var _current_day: int
var _last_day: int

func _init(habit_name: String, current_day: int, last_day: int) -> void:
	_habit_name = habit_name
	_current_day = current_day
	_last_day = last_day

func populate() -> void:
	var label = Label.new()
	var f = load("res://assets/Stacked pixel.ttf")
	label.add_theme_font_override("font", f)
	label.add_theme_font_size_override("font_size", 20)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.text = _habit_name
	label.custom_minimum_size = Vector2(150, 20)

	add_child(label)

	# TODO: Replace this with a custom(ized?) checkbox
	# supports loading custom Texture2D objects
	var cbox = []
	for i in _last_day:
		cbox.push_back(CheckBox.new())
		add_child(cbox[i])
