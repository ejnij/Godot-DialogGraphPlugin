tool
extends "res://addons/dialog_graph/GraphNode.gd"

func set_node_line(node_line):
	node_line.set_first_label("Speech Code " + String(node_lines.size()) + ":")
	node_line.set_second_label("Translation " + String(node_lines.size()) + ":")

#func update_translation_hint(new_text):
#	if TranslationServer.get_locale() != "en":
#		TranslationServer.set_locale("en")
#	$Margin/VBox/HBox2/LineEdit.text = tr(new_text)
