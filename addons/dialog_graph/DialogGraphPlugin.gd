tool
extends EditorPlugin

var editor

func _enter_tree():
	editor = preload("DialogGraphEditor.tscn").instance()
	add_control_to_bottom_panel(editor, "Dialog Graph Editor")
	add_custom_type("DialogManager", "Node", preload("DialogManager.gd"), preload("icon.png"))

func _exit_tree():
	remove_control_from_bottom_panel(editor)
	remove_custom_type("DialogManager")
	editor.free()