extends Label
class_name HabitLabel

var _label_text: String

var min_size: Vector2 = Vector2(200, 20)

func _init(label_text: String) -> void:
	_label_text = label_text

func _ready() -> void:
	add_to_group("TextObjects")

func populate() -> void:
	horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text = _label_text
	custom_minimum_size = min_size
