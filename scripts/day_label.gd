extends Label
class_name DayLabel

var _label_text: String

var font_size: int = 20
var min_size: Vector2 = Vector2(25, 20)

func _init(label_text: String) -> void:
	_label_text = label_text

func populate() -> void:
	add_theme_font_override("font", Globals.font)
	add_theme_font_size_override("font_size", font_size)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text = _label_text
	custom_minimum_size = min_size
