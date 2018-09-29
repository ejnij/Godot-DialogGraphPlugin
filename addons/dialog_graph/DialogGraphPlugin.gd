tool
extends EditorPlugin

var editor

func _enter_tree():
	editor = preload("res://addons/dialog_graph/DialogGraphEditor.tscn").instance()
	add_control_to_bottom_panel(editor, "Dialog Graph Editor")
	add_custom_type("DialogManager", "Node", preload("res://addons/dialog_graph/DialogManager.gd"), preload("res://icon.png"))
	#add_custom_type("GraphManager", "Node", preload("res://addons/dialog_graph/GraphManager.gd"), preload("res://icon.png"))
	#print("Plugin path - " + get_path())

func _exit_tree():
	remove_control_from_bottom_panel(editor)
	remove_custom_type("DialogManager")
	#remove_custom_type("GraphManager")
	editor.free()