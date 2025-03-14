extends Control

@onready var curr_date: Dictionary = Time.get_date_dict_from_system()
var end_of_month: int

# TODO: load this from local storage along with history information
var habit_names = ["onrepeat", "Godot Dev", "Music Production", "Code Study", "Fifth Thing"]

func _ready() -> void:
	calc_last_day_of_month()
	#populate_header()

	# populate habit HBoxes
	for n in habit_names:
		var habit_hbox = HabitHBox.new(n, curr_date["day"], end_of_month)
		habit_hbox.populate()
		$VBoxContainer.add_child(habit_hbox)

func calc_last_day_of_month() -> void:
	var eom: Dictionary = curr_date.duplicate()
	eom["month"] += 1
	eom["day"] = 1
	var eomUnix = (Time.get_unix_time_from_datetime_dict(eom)) - 1000
	end_of_month = (Time.get_date_dict_from_unix_time(eomUnix))["day"]

# TODO: populate header with days of the month that match the existing layout
#func populate_header() -> void:
	#var hLabel1 = Label.new()
	#hLabel1.text = "Shimmy"
	#$VBoxContainer/HeaderHBox.add_child(hLabel1)
	#for i in end_of_month:
		#var dateLabel = Label.new()
		#dateLabel.text = str(i)
		#$VBoxContainer/HeaderHBox.add_child(dateLabel)
