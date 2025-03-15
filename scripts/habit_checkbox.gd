extends CheckBox
class_name HabitCheckBox

func _toggled(_toggled_on: bool) -> void:
	SignalBus.box_toggle.emit(get_parent())
