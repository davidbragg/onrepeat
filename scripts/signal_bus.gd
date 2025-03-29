extends Node

signal check_box_toggle(parent: Control)

signal trigger_habit_manager(title: String, emitter: HabitLabel, pop_up_type: int)

signal new_habit(title: String)

signal pop_rename_habit(title: String, parent: ColorRect)
signal pop_manage_habit(title: String, parent: Object)
signal hide_pop_up(pop_up: Object)

signal rename_habit(title: String, old_title: String)
signal disable_habit(parent: Object)
signal delete_habit(parent: Object)

signal refresh_ui()