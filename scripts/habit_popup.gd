extends ColorRect

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		SignalBus.new_habit.emit("")

func _on_ok_button_pressed() -> void:
	submit_habit()

func _on_cancel_button_pressed() -> void:
	SignalBus.new_habit.emit("")

func _on_habit_title_text_submitted(_new_text: String) -> void:
	submit_habit()

func submit_habit() -> void:
	if %HabitTitle.text != "":
		SignalBus.new_habit.emit(%HabitTitle.text)
		%HabitTitle.clear()


func _on_visibility_changed() -> void:
	if visible == true:
		# position the popup in the center of the window
		# center = window().size / 2
		# offset by popup size / 2
		%HabitTitle.grab_focus()
