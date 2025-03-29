extends ColorRect
class_name RemoveHabitPopUp

var habit_row: HabitRow

func _on_delete_button_pressed() -> void:
	SignalBus.delete_habit.emit(habit_row)

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		SignalBus.hide_pop_up.emit(self)

func _on_disable_button_pressed() -> void:
	SignalBus.disable_habit.emit(habit_row)

func _on_cancel_button_pressed() -> void:
	SignalBus.hide_pop_up.emit(self)

func populate(title: String, parent: Object):
	%HabitLabel.text = title
	habit_row = parent

func _on_visibility_changed() -> void:
	if visible == true:
		position = Vector2(get_window().size / 2) - (size /2 )
