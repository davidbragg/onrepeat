extends Label
class_name DayLabel

var _label_text: String

func _init(label_text: String) -> void:
	_label_text = label_text
	
func populate() -> void:
	var f = load("res://assets/Stacked pixel.ttf")
	add_theme_font_override("font", f)
	add_theme_font_size_override("font_size", 20)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text = _label_text
	custom_minimum_size = Vector2(25, 20)
