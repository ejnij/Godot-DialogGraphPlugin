extends Node

export (String, FILE, "*.json") var dialog_file = null

var nodes = {}
var conversations = {}
var default_conversation = null
var current

signal new_speech(speech_codes)
signal new_choice(choices)
signal dialog_finished()

func _ready():
	parse_dialog_data()

func parse_dialog_data():
	var file = File.new()
	file.open(dialog_file, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	for graph_node in data["nodes"]:
		#var instance = load("res://addons/dialog_graph/" + data["nodes"][graph_node]["type"]).instance()
		match data["nodes"][graph_node]["type"]:
			"Conversation": create_conversation(data, graph_node)
			"Speech": create_speech(data, graph_node)
			"Choice": create_choice(data, graph_node)
			"Condition": create_condition(data, graph_node)
			"Mux": create_mux(data, graph_node)
			"Jump": create_jump(data, graph_node)

func start_dialog(conversation = default_conversation):
	current = conversations[conversation]
	process_conversation()

func continue_dialog():
	process()

func process():
	if current:
		match nodes[current]["type"]:
				"Conversation": process_conversation()
				"Speech": process_speech()
				"Choice": process_choice()
				"Condition": process_condition()
				"Mux": process_mux()
				"Jump": process_jump()
	else:
		emit_signal("dialog_finished")

func create_conversation(data, graph_node):
	var next = null
	if data["sc"].has(graph_node):
		next = data["sc"][graph_node]["0"]["to"]
	nodes[graph_node] = {"type": "Conversation", "next": next}
	conversations[data["nodes"][graph_node]["Line0"]] = graph_node
	if data["default_conversation"] == graph_node:
		default_conversation = data["nodes"][graph_node]["Line0"]

func process_conversation():
	current = nodes[current]["next"]
	process()

func create_speech(data, graph_node):
	var next = null
	var size = data["nodes"][graph_node]["Size"]
	if data["sc"].has(graph_node):
		next = data["sc"][graph_node]["0"]["to"]
	nodes[graph_node] = {"type": "Speech", "next": next, "size": size}
	var speech = []
	for i in range(size):
		#nodes[graph_node]["speech" + String(i)] = data["nodes"][graph_node]["Line" + String(i)]
		speech.append(data["nodes"][graph_node]["Line" + String(i)])
	nodes[graph_node]["speech"] = speech

func process_speech():
	emit_signal("new_speech", nodes[current]["speech"])
	current = nodes[current]["next"]

func create_choice(data, graph_node):
	var size = data["nodes"][graph_node]["Size"]
	nodes[graph_node] = {"type": "Choice", "size": size}
	if data["sc"].has(graph_node):
		var next = []
		for i in range(size):
			if data["sc"][graph_node].has(String(i)):
				next.append(data["sc"][graph_node][String(i)]["to"])
			else:
				next.append(null)
		nodes[graph_node]["next"] = next
	var choice = []
	for i in range(size):
		#nodes[graph_node]["choice" + String(i)] = data["nodes"][graph_node]["Line" + String(i)]
		choice.append(data["nodes"][graph_node]["Line" + String(i)])
	nodes[graph_node]["choice"] = choice

func process_choice():
	emit_signal("new_choice", nodes[current]["choice"])

func choice_picked(choice):
	current = nodes[current]["next"][choice]
	process()

func create_condition(data, graph_node):
	var next_true = null
	var next_false = null
	if data["sc"].has(graph_node):
		next_true = data["sc"][graph_node]["0"]["to"]
		next_false = data["sc"][graph_node]["1"]["to"]
	nodes[graph_node] = {"type": "Condition", "next_true": next_true, "next_false": next_false}
	var full_path = data["nodes"][graph_node]["Line0"]
	var split = full_path.find_last("/")
	var path = full_path.substr(0,split)
	var property = full_path.substr(split+1, full_path.length() - 1 - split)
	nodes[graph_node]["path"] = path
	nodes[graph_node]["property"] = property

func process_condition():
	var condition = get_parent().get_node(nodes[current]["path"]).get(nodes[current]["property"])
	if condition:
		current = nodes[current]["next_true"]
	else:
		current = nodes[current]["next_false"]
	process()

func create_mux(data, graph_node):
	var next = null
	if data["sc"].has(graph_node):
		next = data["sc"][graph_node]["0"]["to"]
	nodes[graph_node] = {"type": "Mux", "next": next}

func process_mux():
	current = nodes[current]["next"]
	process()

func create_jump(data, graph_node):
	var next = data["nodes"][graph_node]["Line0"]
	nodes[graph_node] = {"type": "Jump", "to": next}

func process_jump():
	current = conversations[nodes[current]["to"]]
	process_conversation()
	
