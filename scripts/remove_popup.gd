extends ColorRect
class_name RemoveHabitPopUp

var hbox_parent: Object

func _on_delete_button_pressed() -> void:
	pass
	# TODO:
	# SignalBus.delete_habit.emit(hbox_parent)


func _on_disable_button_pressed() -> void:
	SignalBus.disable_habit.emit(hbox_parent)


func _on_cancel_button_pressed() -> void:
	SignalBus.disable_habit.emit(null)

func populate(title: String, parent: Object):
	%HabitLabel.text = title
	hbox_parent = parent
