extends Node
class_name DataManager

var all_habits: String

func _init() -> void:
	all_habits = str(Globals.user_dir, "onrepeat.json")

func load_habit_data(file_id: String) -> Dictionary:
	var file_name: String = str(Globals.user_dir, file_id, ".json")
	var file = FileAccess.open(file_name, FileAccess.READ)
	var habit_data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	return habit_data

func save_habit_data() -> void:
	pass

func load_all_habits() -> void:
	if FileAccess.file_exists(all_habits):
		var file = FileAccess.open(all_habits, FileAccess.READ)
		Globals.all_habits_data = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		Globals.all_habits_data = { "active": [], "inactive": [] }
		save_all_habits(Globals.all_habits_data)

func save_all_habits(save_data: Dictionary) -> void:
	var file = FileAccess.open(all_habits, FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	file.store_string(json_string)
	file.close()
