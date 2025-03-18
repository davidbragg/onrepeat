extends Node

signal box_toggle(parent: Control)

signal new_habit(title: String)
signal pop_rename_habit(title: String, parent: Object)
signal pop_manage_habit(title: String, parent: Object)

signal rename_habit(title: String, old_title: String)
signal disable_habit(parent: Object)
signal delete_habit(parent: Object)
