tool
extends GraphEdit

var nodes = []
var connections = {}
var starters = []
var ids = []

var default_conversation = null

func _ready():
	pass

func replace_default_conversation(new_default):
	if default_conversation:
		default_conversation.turn_off()
	default_conversation = new_default

func create_node(type, id = 0):
	var node = type.instance()
	add_child(node)
	while ids.has(id):
		id += 1
	ids.append(id)
	node.name = "Node" + String(id)
	nodes.append(node)
	node.offset = scroll_offset + Vector2(200,100)
	return node

func clear_graph():
	clear_connections()
	connections.clear()
	for node in nodes:
		remove_child(node)
		node.queue_free()
	nodes.clear()
	default_conversation = null
	ids.clear()
		

func remove_node(node):	
	ids.erase(int(node.get_name().replace("Node","")))
	for c in get_connection_list():
		if c["from"] == node.get_name() or c["to"] == node.get_name():
			_on_DialogGraph_disconnection_request(c["from"], c["from_port"], c["to"], c["to_port"])
	nodes.erase(node)
	if default_conversation == node:
		default_conversation = null

func clear_left_node_connection(to, to_slot):
	for c in get_connection_list():
		if c["to"] == to and c["to_port"] == to_slot:
			disconnect_node(c["from"], c["from_port"], c["to"], c["to_port"])
			connections[c["from"]].erase(c["from_port"])
			if connections[c["from"]].empty():
				connections.erase(c["from"])

func clear_right_node_connection(from, from_slot):
	for c in get_connection_list():
		if c["from"] == from and c["from_port"] == from_slot:
			disconnect_node(c["from"], c["from_port"], c["to"], c["to_port"])
			from_slot = String(from_slot)
			connections[from].erase(from_slot)
			if connections[from].empty():
				connections.erase(from)
			
func _on_DialogGraph_connection_request(from, from_slot, to, to_slot):
	if !is_node_connected(from, from_slot, to, to_slot):
		clear_right_node_connection(from, from_slot)
		clear_left_node_connection(to, to_slot)
		connect_node(from, from_slot, to, to_slot)
		from_slot = String(from_slot)
		if !connections.has(from):
			connections[from] = {from_slot: {"to": to,"to_slot": to_slot}}
		elif !connections[from].has(from_slot):
			connections[from][from_slot] = {"to": to, "to_slot": to_slot}
		else:
			connections[from][from_slot]["to"] = to
			connections[from][from_slot]["to_slot"] = to_slot

func _on_DialogGraph_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	from_slot = String(from_slot)
	connections[from].erase(String(from_slot))
	if connections[from].empty():
				connections.erase(from)
	
	