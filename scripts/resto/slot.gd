extends Panel

# Variable pour suivre l'item actuellement dans CE slot
var current_item: TextureRect = null

func _ready() -> void:
	# Au démarrage, on regarde si on a déjà un enfant (comme tomate5 dans Panel1)
	if get_child_count() > 0:
		current_item = get_child(0)
		
		# --- LE CODE DE CENTRAGE AU DÉMARRAGE ---
		# On s'assure que l'enfant est bien un Control (comme TextureRect) pour avoir accès à .size
		if current_item is Control:
			# On applique la même formule magique : (Taille Slot - Taille Item) / 2
			current_item.position = (size - current_item.size) / 2

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# On accepte si c'est un TextureRect ET que le slot est vide
	return data is TextureRect and current_item == null

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# 1. On trouve l'ancien panel (le parent actuel de la tomate)
	var old_slot = data.get_parent()
	
	# 2. On force l'ancien panel à se vider
	if old_slot and old_slot.has_method("remove_item"):
		old_slot.remove_item()
	
	# 3. TRÈS IMPORTANT : On détache physiquement la tomate de l'ancien panel
	if data.get_parent():
		data.get_parent().remove_child(data)
	
	# 4. On attache la tomate à CE nouveau panel
	add_child(data)
	current_item = data
	
	# 5. On réinitialise sa position pour qu'elle se centre dans le nouveau carré
	data.position = (size - data.size) / 2
	
	
# Fonction appelée par le nouveau slot pour vider l'ancien
func remove_item() -> void:
	current_item = null
