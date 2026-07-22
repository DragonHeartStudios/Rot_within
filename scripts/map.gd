extends Control


func _on_close_map_pressed() -> void:
	visible = false



func _on_appartement_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/appartement.tscn")


func _on_resto_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/resto/resto.tscn")
