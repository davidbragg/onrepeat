extends Control

const uuid_util = preload('res://addons/uuid/uuid.gd')

var rect_min_size: Vector2 = Vector2(1132, 20)
var double_row: bool = false

@onready var new_button: Button = $ParentBox/HabitsHBox/ControlsHBox/NewButton

func _ready() -> void:
	SignalBus.new_habit.connect(new_habit)
	SignalBus.rename_habit.connect(rename_habit)
	SignalBus.update_habit.connect(update_habit)

	populate_header()

	DataManager.load_all_habits()
	for habit in Globals.all_habits_data["active"]:
		populate_habit(habit)

	set_font()
	button_check()

func set_font() -> void:
	var text_objects = get_tree().get_nodes_in_group("TextObjects")
	for obj in text_objects:
		obj.add_theme_font_override("font", Globals.font)
		obj.add_theme_font_size_override("font_size", 20)

func new_habit(habit: String) -> void:
	$NewHabitPopUp.visible = false
	$ParentBox.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_PASS])

	if habit != "":
		var new_id = uuid_util.v4()
		DataManager.new_habit_data(new_id, habit)
		populate_habit(new_id)

	if Globals.all_habits_data["active"].size() >= 6:
		$ParentBox/HabitsHBox/ControlsHBox/NewButton.disabled = true

func rename_habit(title: String, parent: Object) -> void:
	$ParentBox.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	$RenameHabitPopUp.visible = true
	$RenameHabitPopUp.populate(title, parent)

func update_habit(title: String, parent: Object) -> void:
	$RenameHabitPopUp.visible = false
	$ParentBox.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_PASS])
	if title != "":
		parent.update_habit_title(title)


func populate_habit(habit_id: String) -> void:
	var habit_data = DataManager.load_habit_data(habit_id)

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
	%HabitsHBox.add_child(row_rect)
	set_font()


func populate_header() -> void:
	var header_rect = ColorRect.new()
	header_rect.color = Color.NAVY_BLUE
	header_rect.custom_minimum_size = rect_min_size

	var header_hbox = HabitHBox.new({"title": Globals.header_date})
	header_hbox.populate_header()
	header_rect.add_child(header_hbox)
	%HabitsHBox.add_child(header_rect)


func _on_new_button_pressed() -> void:
	$ParentBox.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	$NewHabitPopUp.visible = true


func button_check() -> void:
	if Globals.all_habits_data["active"].size() >= 6:
		new_button.disabled = true
		new_button.visible = false
