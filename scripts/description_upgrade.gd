extends PanelContainer

@export var panels: Array[UpgradePanel] = []

# Nom lisible de chaque stat, pour ne pas montrer au joueur le nom brut de la
# variable du GameManager (ex: "max_energy").
const NOMS_DES_STATS := {
    "max_energy": "STAT_MAX_ENERGY",
    "order_speed": "STAT_ORDER_SPEED",
    "speed_customers": "STAT_SPEED_CUSTOMERS",
    "tips": "STAT_TIPS",
}

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
        titre_label.text = tr(hovered_panel.titre)

        var cle_de_la_stat = NOMS_DES_STATS.get(hovered_panel.valeur_a_changer, hovered_panel.valeur_a_changer)

        description_label.text = tr("UPGRADE_DESC") % [
            tr(cle_de_la_stat),
            hovered_panel.value,
            hovered_panel.get_next_value()
        ]