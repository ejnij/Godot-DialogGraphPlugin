tool
extends EditorPlugin

var editor
var manager = preload("DialogManager.gd")
var button
var selection

func _enter_tree():
	editor = preload("DialogGraphEditor.tscn").instance()
	button = add_control_to_bottom_panel(editor, "Dialog Graph Editor")
	button.visible = false
	add_custom_type("DialogManager", "Node", manager, preload("icon.png"))
	selection = get_editor_interface().get_selection()
	selection.connect("selection_changed", self, "_on_EditorInterface_selection_changed")
	_on_EditorInterface_selection_changed()

func _on_EditorInterface_selection_changed():
	button.visible = false
	for node in selection.get_transformable_selected_nodes():
		if node.get_script() and (node.get_script() == manager or node.get_script().get_base_script() == manager):
			editor.load_data(node.dialog_file)
			button.visible = true
			break

func _exit_tree():
	if selection != null:
		selection.disconnect("selection_changed", self, "_on_EditorInterface_selection_changed")
		selection = null
	button.visible = true
	remove_control_from_bottom_panel(editor)
	remove_custom_type("DialogManager")
	editor.free()
