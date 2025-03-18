extends Node

var all_habits: String

func _init() -> void:
	all_habits = str(Globals.user_dir, "onrepeat.json")

func load_habit_data(file_id: String) -> Dictionary:
	var file_name: String = str(Globals.user_dir, file_id, ".json")
	var file = FileAccess.open(file_name, FileAccess.READ)
	var habit_data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	return habit_data

func new_habit_data(file_id: String, habit_title: String) -> void:
	var file_name: String = str(Globals.user_dir, file_id, ".json")
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	var save_data: Dictionary = {
		"title": habit_title,
		"id": file_id,
		str(Globals.today["year"]): {}
	}
	file.store_string(JSON.stringify(save_data))

	Globals.all_habits_data["active"].push_back(file_id)
	save_all_habits()

func save_habit_data(habit_data: Dictionary) -> void:
	var file_name: String = str(Globals.user_dir, habit_data["id"], ".json")
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(JSON.stringify(habit_data))
	file.close()

func load_all_habits() -> void:
	if FileAccess.file_exists(all_habits):
		var file = FileAccess.open(all_habits, FileAccess.READ)
		Globals.all_habits_data = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		Globals.all_habits_data = { "active": [], "inactive": [] }
		save_all_habits()

func save_all_habits() -> void:
	var file = FileAccess.open(all_habits, FileAccess.WRITE)
	file.store_string(JSON.stringify(Globals.all_habits_data))
	file.close()

func delete_habit_data(id: String) -> void:
	var file_name: String = str(Globals.user_dir, id, ".json")
	DirAccess.remove_absolute(file_name)
