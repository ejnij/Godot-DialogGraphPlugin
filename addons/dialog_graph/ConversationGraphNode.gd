tool
extends "res://addons/dialog_graph/GraphNode.gd"

func set_node_line(node_line):
	node_line.set_label("Name:")

func turn_off():
	$DefaultButton.pressed = false

func turn_on():
	$DefaultButton.pressed = true

func _on_DefaultButton_toggled(button_pressed):
	if button_pressed:
		get_parent().replace_default_conversation(self)
	else:
		get_parent().replace_default_conversation(null)
