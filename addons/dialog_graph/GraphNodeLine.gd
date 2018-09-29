tool
extends MarginContainer

signal line_entered(new_line)
signal line_changed(new_line)

func _ready():
	pass

func get_data():
	return get_line()

func get_export_data():
	return get_data()

func set_data(data):
	set_line(data)

func is_line_visible():
	return $HBox/LineEdit.visible

func hide_line():
	$HBox/LineEdit.visible = false

func show_line():
	$HBox/LineEdit.visible = true

func is_label_visible():
	return $HBox/Label.visible

func hide_label():
	$HBox/Label.visible = false

func show_label():
	$HBox/Label.visible = true

func get_line():
	return $HBox/LineEdit.text
	
func set_line(text):
	$HBox/LineEdit.clear()
	$HBox/LineEdit.text = text

func get_label():
	return $HBox/Label.text

func set_label(text):
	$HBox/Label.text = text

func _on_LineEdit_text_entered(new_text):
	emit_signal("line_entered", new_text)


func _on_LineEdit_text_changed(new_text):
	if get_parent() is GraphNode:
		get_parent().rect_size.x = get_parent().rect_min_size.x
	else:
		emit_signal("line_changed", new_text)
