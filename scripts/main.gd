extends Control

const uuid_util = preload('res://addons/uuid/uuid.gd')

var rect_min_size: Vector2 = Vector2(1132, 20)
var double_row: bool = false
var habit_rows: Array[ColorRect]

@onready var new_button: Button = $ParentBox/HabitsHBox/ControlsHBox/NewButton

func _ready() -> void:
	SignalBus.pop_rename_habit.connect(pop_rename_habit)
	SignalBus.pop_manage_habit.connect(pop_remove_habit)

	SignalBus.new_habit.connect(new_habit)
	SignalBus.rename_habit.connect(rename_habit)
	SignalBus.disable_habit.connect(disable_habit)
	SignalBus.delete_habit.connect(delete_habit)

	populate_header()

	DataManager.load_all_habits()
	for habit in Globals.all_habits_data["active"]:
		populate_habit(habit)

	apply_font()
	new_button_check()

# Manage Habits
func rename_habit(title: String, parent: Object) -> void:
	hide_pop_up($RenameHabitPopUp)
	if title != "":
		parent.update_habit_title(title)

func new_habit(habit: String) -> void:
	hide_pop_up($NewHabitPopUp)

	if habit != "":
		var new_id = uuid_util.v4()
		DataManager.new_habit_data(new_id, habit)
		populate_habit(new_id)

	new_button_check()
	# apply_theme()

func disable_habit(row: Object) -> void:
	hide_pop_up($RemoveHabitPopUp)

	if row == null:
		return

	var index = habit_rows.find(row)
	var hbox = habit_rows[index].get_child(0)
	var habit_id = hbox._habit_data["id"]
	Globals.all_habits_data["inactive"].push_back(habit_id)
	Globals.all_habits_data["active"].erase(habit_id)
	DataManager.save_all_habits()
	habit_rows[index].queue_free()

	new_button_check()
	# apply_theme()

func delete_habit(row: Object) -> void:
	hide_pop_up($RemoveHabitPopUp)

	var index = habit_rows.find(row)
	var hbox = habit_rows[index].get_child(0)
	var habit_id = hbox._habit_data["id"]
	Globals.all_habits_data["active"].erase(habit_id)
	DataManager.save_all_habits()
	DataManager.delete_habit_data(habit_id)
	habit_rows[index].queue_free()
	habit_rows.remove_at(index)
	new_button_check()
	# apply_theme()



# Populate UI
func populate_habit(habit_id: String) -> void:
	var habit_data = DataManager.load_habit_data(habit_id)

	var row_rect = ColorRect.new()
	habit_rows.push_back(row_rect)

	# to be superseded by apply_theme()
	if double_row:
		row_rect.color = Color.DARK_SLATE_GRAY
	else:
		row_rect.color = Color.DIM_GRAY
	double_row = !double_row
	row_rect.custom_minimum_size = rect_min_size

	var habit_hbox = HabitHBox.new(habit_data)
	habit_hbox.populate_habit()

	row_rect.add_child(habit_hbox)
	%HabitsHBox.add_child(row_rect)
	apply_font()

	# apply_theme()

func populate_header() -> void:
	var header_rect = ColorRect.new()
	header_rect.color = Color.NAVY_BLUE
	header_rect.custom_minimum_size = rect_min_size

	var header_hbox = HabitHBox.new({"title": Globals.header_date})
	header_hbox.populate_header()
	header_rect.add_child(header_hbox)
	%HabitsHBox.add_child(header_rect)


# Manage UI
func apply_font() -> void:
	var text_objects = get_tree().get_nodes_in_group("TextObjects")
	for obj in text_objects:
		obj.add_theme_font_override("font", Globals.font)
		obj.add_theme_font_size_override("font_size", 20)

func new_button_check() -> void:
	if Globals.all_habits_data["active"].size() < 6:
		$ParentBox/HabitsHBox/ControlsHBox/NewButton.disabled = false
		$ParentBox/HabitsHBox/ControlsHBox/NewButton.visible = true
	else:
		$ParentBox/HabitsHBox/ControlsHBox/NewButton.disabled = true
		$ParentBox/HabitsHBox/ControlsHBox/NewButton.visible = false

# func apply_theme() -> void:
	# iterate through the habit_rows
	# reset current group
	# get_groups() -> remove_from_group() -> add_to_group()
	# alternate assigning to RowOne/RowTwo
	# apply colours to groups

func pop_rename_habit(title: String, parent: Object) -> void:
	$ParentBox.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	$RenameHabitPopUp.visible = true
	$RenameHabitPopUp.populate(title, parent)

func pop_remove_habit(title:String, parent: Object) -> void:
	$ParentBox.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	$RemoveHabitPopUp.visible = true
	$RemoveHabitPopUp.populate(title, parent)

func _on_new_button_pressed() -> void:
	$ParentBox.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	$NewHabitPopUp.visible = true

func hide_pop_up(pop_up: Object) -> void:
	pop_up.visible = false
	$ParentBox.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_PASS])
