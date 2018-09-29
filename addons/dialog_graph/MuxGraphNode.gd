tool
extends "res://addons/dialog_graph/GraphNode.gd"

func set_node_line(node_line):
	node_line.set_label("Input " + String(node_lines.size()))
	node_line.hide_line()
	set_slot(node_lines.size(), true, 0, slot_color, false, 0, slot_color)