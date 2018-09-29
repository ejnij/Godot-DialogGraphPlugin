tool
extends "res://addons/dialog_graph/GraphNode.gd"

func set_node_line(node_line):
	node_line.set_label("Condition Variable")
	set_slot(node_lines.size(), false, 0, slot_color, true, 0, slot_color)