tool
extends EditorPlugin

var editor
var manager = preload("DialogManager.gd")
var button
var selection

func _enter_tree():
	editor = preload("DialogGraphEditor.tscn").instance()
	add_custom_type("DialogManager", "Node", manager, preload("icon.png"))
	selection = get_editor_interface().get_selection()
	selection.connect("selection_changed", self, "_on_EditorInterface_selection_changed")

func _on_EditorInterface_selection_changed():
	for node in selection.get_transformable_selected_nodes():
		if node.get_script() and (node.get_script() == manager or node.get_script().get_base_script() == manager):
			show_graph()
			return
	hide_graph()

func show_graph() -> void:
	button = add_control_to_bottom_panel(editor, "Dialog Graph Editor")

func hide_graph() -> void:
	remove_control_from_bottom_panel(editor)

func _exit_tree():
	hide_graph()
	selection.disconnect("selection_changed", self, "_on_EditorInterface_selection_changed")
	remove_custom_type("DialogManager")
	editor.free()
