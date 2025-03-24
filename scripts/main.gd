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
	apply_theme()
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
	apply_theme()

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
	habit_rows.remove_at(index)

	new_button_check()
	apply_theme()

func delete_habit(row: Object) -> void:
	hide_pop_up($RemoveHabitPopUp)

	var index = habit_rows.find(row)
	var hbox = habit_rows[index].get_child(0)
	var habit_id = hbox._habit_data["id"]
	DataManager.delete_habit_data(habit_id)
	habit_rows[index].queue_free()
	habit_rows.remove_at(index)
	new_button_check()
	apply_theme()


# Populate UI
func populate_habit(habit_id: String) -> void:
	var habit_data = DataManager.load_habit_data(habit_id)

	var row_rect = ColorRect.new()
	habit_rows.push_back(row_rect)

	if double_row:
		row_rect.add_to_group("EvenRow")
	else:
		row_rect.add_to_group("OddRow")
	double_row = !double_row
	row_rect.custom_minimum_size = rect_min_size

	var habit_hbox = HabitHBox.new(habit_data)
	habit_hbox.populate_habit()

	row_rect.add_child(habit_hbox)
	%HabitsHBox.add_child(row_rect)
	apply_font()


func populate_header() -> void:
	var header_rect = ColorRect.new()
	header_rect.add_to_group("Header")
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

func apply_theme() -> void:
	var background = get_tree().get_nodes_in_group("Background")
	var header = get_tree().get_nodes_in_group("Header")

	# assign background colors
	for n in background:
		n.color = Globals.background_color

	# header colours
	header[0].color = Globals.header_color
	var header_label = header[0].get_children()[0].get_children()[0]
	header_label.add_theme_color_override("font_color", Globals.header_text)

	for i in len(habit_rows):
		var h_row = habit_rows[i]
		if i % 2 == 0:
			h_row.color = Globals.even_row_color
			var habit_label = h_row.get_children()[0].get_children()[0]
			habit_label.add_theme_color_override("font_color", Globals.even_row_text)
		else:
			h_row.color = Globals.odd_row_color
			var habit_label = h_row.get_children()[0].get_children()[0]
			habit_label.add_theme_color_override("font_color", Globals.odd_row_text)


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
