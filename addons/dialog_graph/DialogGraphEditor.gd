tool
extends Control

var conversation_node = preload("ConversationGraphNode.tscn")
var speech_node = preload("SpeechGraphNode.tscn")
var choice_node = preload("ChoiceGraphNode.tscn")
var condition_node = preload("ConditionGraphNode.tscn")
var mux_node = preload("MuxGraphNode.tscn")
var jump_node = preload("JumpGraphNode.tscn")
var graph = null

# Called when the node enters the scene tree for the first time.
func _ready():
	graph = $Panel/Margin/VBox/DialogGraph

func _on_Conversation_pressed():
	graph.create_node(conversation_node)

func _on_Speech_pressed():
	graph.create_node(speech_node)

func _on_Choice_pressed():
	graph.create_node(choice_node)

func _on_Condition_pressed():
	graph.create_node(condition_node)

func _on_Mux_pressed():
	graph.create_node(mux_node)

func _on_Jump_pressed():
	graph.create_node(jump_node)

func get_data():
	var data = {}
	data["connections"] = graph.get_connection_list()
	data["sc"] = graph.connections
	if graph.default_conversation:
		data["default_conversation"] = graph.default_conversation.get_name()
	data["nodes"] = {}
	for child in graph.nodes:
		data["nodes"][child.get_name()] = child.get_data()
	return data

func get_export_data():
	var data = {}
	data["sc"] = graph.connections
	data["default_conversation"] = graph.default_conversation.get_name()
	data["nodes"] = {}
	for child in graph.nodes:
		data["nodes"][child.get_name()] = child.get_export_data()
	return data

func load_data(file_name):
	graph.clear_graph()
	var file = File.new()
	file.open(file_name, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	set_data(data)

func set_data(data):
	for node in data["nodes"]:
		var node_type
		match data["nodes"][node]["type"]:
			"Conversation": node_type = conversation_node
			"Speech": node_type = speech_node
			"Choice": node_type = choice_node
			"Condition": node_type = condition_node
			"Mux": node_type = mux_node
			"Jump": node_type = jump_node
		var instance = graph.create_node(node_type, int(node.replace("Node", "")))
		instance.set_data(data["nodes"][node])
	for connection in data["connections"]:
		graph._on_DialogGraph_connection_request(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
	if data.has("default_conversation"):
		var default = null
		var i = 0
		while !graph.default_conversation:
			if data["default_conversation"] == graph.nodes[i].get_name():
				graph.default_conversation = graph.nodes[i]
			else:
				i += 1
		graph.default_conversation.turn_on()

func _on_Save_pressed():
	$SaveWindow.popup()

func _on_SaveWindow_confirmed():
	var file_name = $SaveWindow.current_file
	var file = File.new()
	file.open(file_name, File.WRITE)
	file.store_string(to_json(get_data()))
	file.close()
	$SaveWindow.hide()

func _on_Export_pressed():
	if graph.default_conversation:
		$ExportWindow.popup()
	else:
		$DefaultWindow.popup()

func _on_ExportWindow_confirmed():
	var file_name = $ExportWindow.current_file
	var file = File.new()
	file.open(file_name, File.WRITE)
	file.store_string(to_json(get_export_data()))
	file.close()
	$ExportWindow.hide()

func _on_Load_pressed():
	$LoadWindow.popup()

func _on_LoadWindow_file_selected(file_name):
	load_data(file_name)
	$LoadWindow.hide()

func _on_Clear_pressed():
	$ClearWindow.popup()

func _on_ClearWindow_confirmed():
	graph.clear_graph()
	$ClearWindow.hide()
