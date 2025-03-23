extends ColorRect
class_name RenameHabitPopUp

var _parent: Object

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		SignalBus.rename_habit.emit("", _parent)

func _on_cancel_button_pressed() -> void:
	SignalBus.rename_habit.emit("", _parent)

func _on_ok_button_pressed() -> void:
	submit_habit()

func _on_habit_title_text_submitted(_new_text: String) -> void:
	submit_habit()

func submit_habit() -> void:
	SignalBus.rename_habit.emit(%HabitTitle.text, _parent)


func _on_visibility_changed() -> void:
	if visible == true:
		# center pop up in the app
		position = Vector2(get_window().size / 2) - (size /2 )
		%HabitTitle.grab_focus()

func populate(title: String, parent: Object) -> void:
	_parent = parent
	%HabitTitle.text = ""
	%HabitTitle.placeholder_text = title
