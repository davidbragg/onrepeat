extends Node

signal box_toggle(parent: Control)
signal new_habit(title: String)
signal rename_habit(title: String, parent: Object)
signal update_habit(title: String, old_title: String)
signal remove_habit(title: String, parent: Object)
signal disable_habit(parent: Object)
signal delete_habit(parent: Object)
