extends Label
class_name HabitLabel

var _label_text: String

var min_size: Vector2 = Vector2(200, 20)

func _init(label_text: String) -> void:
	_label_text = label_text

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	add_to_group("TextObjects")

func populate() -> void:
	horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text = _label_text
	custom_minimum_size = min_size

func _gui_input(_event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_label_text = text
		SignalBus.pop_rename_habit.emit(_label_text, self.get_parent())
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		SignalBus.pop_manage_habit.emit(text, self.get_parent())
