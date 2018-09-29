tool
extends VBoxContainer

export (int) var max_translation_length = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_data():
	return {"Dialog": $NodeLine1.get_data(), "Translation": $NodeLine2.get_data()}

func get_export_data():
	return $NodeLine1.get_export_data()

func set_data(data):
	$NodeLine1.set_data(data["Dialog"])
	$NodeLine2.set_data(data["Translation"])

func is_line_visible():
	return true

func get_first_line():
	return $NodeLine1.get_line()

func get_second_line():
	return $NodeLine2.get_line()

func get_first_label():
	return $NodeLine1.get_label()

func get_second_label():
	return $NodeLine2.get_label()

func set_first_line(text):
	$NodeLine1.set_line(text)

func set_second_line(text):
	$NodeLine2.set_line(text)
	
func set_first_label(text):
	$NodeLine1.set_label(text)

func set_second_label(text):
	$NodeLine2.set_label(text)

func _on_NodeLine1_line_changed(new_line):
	get_parent().rect_size.x = get_parent().rect_min_size.x

func _on_NodeLine1_line_entered(new_line):
	var translation = tr(new_line)
	if translation.length() > max_translation_length:
		translation = translation.substr(0,max_translation_length-1) + "..."
	set_second_line(translation)
	#get_parent().rect_size.x = get_parent().rect_min_size.x


func _on_NodeLine2_line_changed(new_line):
	get_parent().rect_size.x = get_parent().rect_min_size.x
