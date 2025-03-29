extends ColorRect
class_name HabitRow

var min_size: Vector2 = Vector2(1132, 20)

var habit_data: Dictionary
var habit_hbox: HabitHBox
var habit_label: HabitLabel
var checkboxes: Array[HabitCheckBox]

func _init(data: Dictionary = {"title": Globals.header_date}) -> void:
	custom_minimum_size = min_size
	habit_data = data

func _ready() -> void:
	SignalBus.trigger_habit_manager.connect(pop_up_manager)

	SignalBus.rename_habit.connect(rename_habit)
	SignalBus.delete_habit.connect(remove_row)
	SignalBus.disable_habit.connect(remove_row)


func populate_habit() -> void:
	habit_hbox = HabitHBox.new(habit_data)
	var row_data = habit_hbox.populate_habit()
	habit_label = row_data["label"]
	checkboxes = row_data["checkboxes"]
	add_child(habit_hbox)

func populate_header() -> void:
	habit_hbox = HabitHBox.new(habit_data)
	habit_label = habit_hbox.populate_header()
	add_child(habit_hbox)

func pop_up_manager(habit_name: String, label_node: HabitLabel, pop_up_type) -> void:
	if label_node != habit_label:
		return

	match pop_up_type:
		Globals.popups.NEW:
			pass
		Globals.popups.RENAME:
			SignalBus.pop_rename_habit.emit(habit_name, self)
		Globals.popups.MANAGE:
			SignalBus.pop_manage_habit.emit(habit_name, self)

# Manage Row Data
func rename_habit(habit_name: String, parent: ColorRect) -> void:
	if parent == self && habit_name != "" && habit_name != habit_data["title"]:
		habit_data["title"] = habit_name
		habit_label.update_text(habit_name)
		DataManager.save_habit_data(habit_data)


func remove_row(parent: HabitRow) -> void:
	if parent == self:
		queue_free()
		SignalBus.refresh_ui.emit()
