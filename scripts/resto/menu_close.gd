extends Button

@export var node : Control

func _on_pressed() -> void:
	node.visible = false
