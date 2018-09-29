tool
extends MarginContainer

func _ready():
	pass # Replace with function body.

func set_count(count):
	$HBox/LineEdit.text = String(count)