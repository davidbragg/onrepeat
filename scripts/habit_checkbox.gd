extends CheckBox
class_name HabitCheckBox

func _toggled(_toggled_on: bool) -> void:
	if button_pressed:
		self_modulate = Globals.darkish_pink
	SignalBus.box_toggle.emit(get_parent())
