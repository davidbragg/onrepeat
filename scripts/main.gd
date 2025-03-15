extends Control

var rect_min_size: Vector2 = Vector2(1132, 20)
var double_row: bool = false
var data_manager: Node = DataManager.new()

func _ready() -> void:
	# populate the header
	var header_rect = ColorRect.new()
	header_rect.color = Color.NAVY_BLUE
	header_rect.custom_minimum_size = rect_min_size
	var header_hbox = HabitHBox.new({"title": "march 2025"})
	header_hbox.populate_header()
	header_rect.add_child(header_hbox)
	$VBoxContainer.add_child(header_rect)

	data_manager.load_all_habits()
	print(Globals.all_habits_data)

	# populate habits
	for habit in Globals.all_habits_data["active"]:
		# take the habit name and load the relevant file
		var habit_data = data_manager.load_habit_data(habit)
		print(habit_data)
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