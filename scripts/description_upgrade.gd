extends PanelContainer

@export var panels: Array[UpgradePanel] = []

@onready var titre_label: Label = $MarginContainer/titre_Label
@onready var description_label: Label = $MarginContainer/description_Label

func get_hovered_panel() -> UpgradePanel:
	var mouse_pos = get_viewport().get_mouse_position()

	for panel in panels:
		if panel.visible and panel.get_global_rect().has_point(mouse_pos):
			return panel

	return null

func _process(_delta: float) -> void:
	var hovered_panel = get_hovered_panel()

	if hovered_panel:
		titre_label.text = hovered_panel.titre
		
		description_label.text = "You will upgrade your %s from %d to %d" % [
			hovered_panel.valeur_a_changer,
			hovered_panel.value,
			hovered_panel.get_next_value()
		]
