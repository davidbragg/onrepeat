extends Control

var rect_min_size: Vector2 = Vector2(1132, 20)
var double_row: bool = false

func _ready() -> void:
	# populate the header
	var header_rect = ColorRect.new()
	header_rect.color = Color.NAVY_BLUE
	header_rect.custom_minimum_size = rect_min_size

	var header_hbox = HabitHBox.new({"title": Globals.header_date})
	header_hbox.populate_header()
	header_rect.add_child(header_hbox)
	$VBoxContainer.add_child(header_rect)

	DataManager.load_all_habits()

	# populate habits
	for habit in Globals.all_habits_data["active"]:
		var habit_data = DataManager.load_habit_data(habit)

		var row_rect = ColorRect.new()
		if double_row:
			row_rect.color = Color.DARK_SLATE_GRAY
		else:
			row_rect.color = Color.DIM_GRAY
		double_row = !double_row
		row_rect.custom_minimum_size = rect_min_size

		var habit_hbox = HabitHBox.new(habit_data)
		habit_hbox.populate_habit()

		row_rect.add_child(habit_hbox)
		$VBoxContainer.add_child(row_rect)
