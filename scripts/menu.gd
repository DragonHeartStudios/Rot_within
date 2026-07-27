extends Control

@onready var langue: OptionButton = $langue


func _ready() -> void:
	# On remplit la liste avec les langues gérées (chacune écrite dans sa propre
	# langue) et on présélectionne celle qui est active.
	langue.clear()

	for i in Localization.LANGUES.size():
		var infos: Dictionary = Localization.LANGUES[i]
		langue.add_item(infos["nom"], i)

		if infos["code"] == Localization.code_actuel():
			langue.select(i)


func _on_langue_item_selected(index: int) -> void:
	Localization.changer_la_langue(Localization.LANGUES[index]["code"])


func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/appartement.tscn")
