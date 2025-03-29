extends Label
class_name HabitLabel

var min_size: Vector2 = Vector2(200, 20)

func _init(label_text: String) -> void:
	text = label_text
	horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	custom_minimum_size = min_size

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	add_to_group("TextObjects")
	add_to_group("HabitLabel")

func update_text(label_text: String) -> void:
	text = label_text

func _gui_input(_event: InputEvent) -> void:
	var pop_up_type
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pop_up_type = Globals.popups.RENAME
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		pop_up_type = Globals.popups.MANAGE

	SignalBus.trigger_habit_manager.emit(text, self, pop_up_type)

