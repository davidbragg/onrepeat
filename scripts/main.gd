extends Control

const uuid_util = preload('res://addons/uuid/uuid.gd')

var header_row: HabitRow
var habit_rows: Array[HabitRow]

@onready var new_button: Button = $ParentBox/HabitsHBox/ControlsHBox/NewButton

func _ready() -> void:
	SignalBus.pop_rename_habit.connect(pop_rename_habit)
	SignalBus.pop_manage_habit.connect(pop_remove_habit)
	SignalBus.hide_pop_up.connect(hide_pop_up)

	SignalBus.new_habit.connect(new_habit)
	SignalBus.rename_habit.connect(rename_habit)
	SignalBus.disable_habit.connect(disable_habit)
	SignalBus.delete_habit.connect(delete_habit)

	SignalBus.refresh_ui.connect(refresh_ui)

	populate_ui()


# Manage Habits
func rename_habit(_title: String, _parent: ColorRect) -> void:
	hide_pop_up($RenameHabitPopUp)

func new_habit(habit: String) -> void:
	hide_pop_up($NewHabitPopUp)

	if habit != "":
		var new_id = uuid_util.v4()
		var habit_data = DataManager.new_habit_data(new_id, habit)
		# TODO: Confirm population works on new habit
		populate_row(habit_data)
		# var habit_row = HabitRow.new(habit_data)
		# habit_row.populate_habit()
		# habit_rows.push_back(habit_row)
		# %HabitsHBox.add_child(habit_row)

	refresh_ui()

func disable_habit(row: HabitRow) -> void:
	hide_pop_up($RemoveHabitPopUp)

	var index = habit_rows.find(row)
	var habit_id = habit_rows[index].habit_data["id"]

	Globals.all_habits_data["inactive"].push_back(habit_id)
	Globals.all_habits_data["active"].erase(habit_id)
	DataManager.save_all_habits()
	habit_rows[index].queue_free()
	habit_rows.remove_at(index)

	refresh_ui()

func delete_habit(row: HabitRow) -> void:
	hide_pop_up($RemoveHabitPopUp)

	var index = habit_rows.find(row)
	var habit_id = habit_rows[index].habit_data["id"]
	DataManager.delete_habit_data(habit_id)
	habit_rows.remove_at(index)


# Manage UI
func populate_ui() -> void:
	header_row = HabitRow.new()
	header_row.populate_header()
	%HabitsHBox.add_child(header_row)

	DataManager.load_all_habits()
	for habit in Globals.all_habits_data["active"]:
		var habit_data = DataManager.load_habit_data(habit)
		populate_row(habit_data)

	refresh_ui()

func populate_row(habit_data: Dictionary) -> void:
	var habit_row = HabitRow.new(habit_data)
	habit_row.populate_habit()
	habit_rows.push_back(habit_row)
	%HabitsHBox.add_child(habit_row)

func refresh_ui() -> void:
	new_button_check()
	apply_theme()

func new_button_check() -> void:
	if Globals.all_habits_data["active"].size() < 6:
		$ParentBox/HabitsHBox/ControlsHBox/NewButton.disabled = false
		$ParentBox/HabitsHBox/ControlsHBox/NewButton.visible = true
	else:
		$ParentBox/HabitsHBox/ControlsHBox/NewButton.disabled = true
		$ParentBox/HabitsHBox/ControlsHBox/NewButton.visible = false

func apply_theme() -> void:
	var text_objects = get_tree().get_nodes_in_group("TextObjects")
	for obj in text_objects:
		obj.add_theme_font_override("font", Globals.font)
		obj.add_theme_font_size_override("font_size", 20)

	var background = get_tree().get_nodes_in_group("Background")
	# var header = get_tree().get_nodes_in_group("Header")

	# assign background colors
	for n in background:
		n.color = Globals.background_color

	# header colours
	header_row.color = Globals.header_color
	header_row.habit_label.add_theme_color_override("font_color", Globals.header_text)

	for i in len(habit_rows):
		var h_row = habit_rows[i]
		if i % 2 == 0:
			h_row.color = Globals.even_row_color
			h_row.habit_label.add_theme_color_override("font_color", Globals.even_row_text)
		else:
			h_row.color = Globals.odd_row_color
			h_row.habit_label.add_theme_color_override("font_color", Globals.odd_row_text)


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
