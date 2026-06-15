extends TextureRect # Ou Panel, selon le type de ton nœud planche

# Référence vers le GridContainer qui est enfant de la planche
@onready var planche_grid: GridContainer = $PlancheGrid

# Limite maximum d'items sur la planche
const MAX_ITEMS = 4

func _ready() -> void:
	# On s'assure que la planche détecte bien la souris
	mouse_filter = Control.MOUSE_FILTER_PASS

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# On vérifie : 
	# 1. Est-ce que c'est de la nourriture (TextureRect) ?
	# 2. Est-ce qu'il y a de la place (moins de 4 items) ?
	if data is TextureRect and planche_grid.get_child_count() < MAX_ITEMS:
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# 1. On détache l'item de son ancien slot d'inventaire
	var old_slot = data.get_parent()
	if old_slot and old_slot.has_method("remove_item"):
		old_slot.remove_item()
	
	if data.get_parent():
		data.get_parent().remove_child(data)
	
	# 2. On l'ajoute dans le GridContainer de la planche
	planche_grid.add_child(data)
	
	# 3. ASTUCE : On force l'item à se mettre au TOUT DÉBUT (index 0)
	planche_grid.move_child(data, 0)
	
	# 4. On réinitialise sa position pour le container
	data.position = Vector2.ZERO
