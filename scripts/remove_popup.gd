extends ColorRect
class_name RemoveHabitPopUp

var hbox_parent: Object

func _on_delete_button_pressed() -> void:
	SignalBus.delete_habit.emit(hbox_parent.get_parent())

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		SignalBus.disable_habit.emit(null)

func _on_disable_button_pressed() -> void:
	SignalBus.disable_habit.emit(hbox_parent.get_parent())

func _on_cancel_button_pressed() -> void:
	SignalBus.disable_habit.emit(null)

func populate(title: String, parent: Object):
	%HabitLabel.text = title
	hbox_parent = parent
