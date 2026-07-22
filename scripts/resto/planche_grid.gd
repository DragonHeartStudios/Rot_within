extends Control

# Référence vers le GridContainer qui est enfant de la planche
@onready var planche_grid: GridContainer = $PlancheGrid
const MAX_ITEMS = 4

func _ready() -> void:
	# Indispensable pour que le frigo puisse trouver cette planche
	add_to_group("planche_travail")
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	# On surveille automatiquement tout nouvel arrivant
	planche_grid.child_entered_tree.connect(_on_ingredient_ajoute)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is TextureRect and planche_grid.get_child_count() < MAX_ITEMS

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var old_slot = data.get_parent()
	if old_slot and old_slot.has_method("remove_item"):
		old_slot.remove_item()
	
	if data.get_parent():
		data.get_parent().remove_child(data)
	
	planche_grid.add_child(data)
	planche_grid.move_child(data, 0)
	data.position = Vector2.ZERO

# Quand un item arrive sur la planche
func _on_ingredient_ajoute(node: Node) -> void:
	if node is TextureRect:
		# --- CORRECTION DU CENTRAGE DANS LE GRID CONTAINER ---
		# On force l'ingrédient à s'étendre et à se centrer à l'intérieur de sa cellule de grille
		node.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		node.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		# On connecte le signal resized pour recalculer le centrage s'il bouge ou change de taille
		if not node.resized.is_connected(_forcer_position_grille.bind(node)):
			node.resized.connect(_forcer_position_grille.bind(node))
		
		# Sécurité : on attend une frame pour que l'objet soit bien initialisé dans la grille
		await get_tree().process_frame
		
		# 1. On s'assure que le clic ne soit pas "consommé" par la grille
		node.mouse_filter = Control.MOUSE_FILTER_STOP 
		
		# 2. Nettoyage des anciennes connexions (important !)
		for conn in node.gui_input.get_connections():
			node.gui_input.disconnect(conn["callable"])
			
		# 3. Connexion au retour frigo
		node.gui_input.connect(_on_item_gui_input_retour.bind(node))

# Petite fonction de sécurité pour forcer le repositionnement dans le Container
func _forcer_position_grille(item: TextureRect) -> void:
	if is_instance_valid(item):
		item.position = Vector2.ZERO # Les conteneurs gèrent le décalage via les size_flags

func _on_item_gui_input_retour(event: InputEvent, item: TextureRect) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Input.is_key_pressed(KEY_SHIFT):
			
			# On cherche un slot avant de modifier la structure
			var slot_libre = _trouver_un_slot_frigo_vide()
			if slot_libre:
				# Déconnexion du signal de centrage de la planche avant le départ au frigo
				if item.resized.is_connected(_forcer_position_grille.bind(item)):
					item.resized.disconnect(_forcer_position_grille.bind(item))
				
				# --- ÉVITEMENT DU SAUT ---
				# On désactive temporairement la mise en page de la grille
				planche_grid.set_deferred("sort_children", false) 
				
				# On détache l'objet proprement
				if item.get_parent(): 
					item.get_parent().remove_child(item)
				
				# On envoie au frigo
				slot_libre.set_item(item)
				
				# On réactive la mise à jour de la grille après un court délai
				await get_tree().process_frame
				planche_grid.set_deferred("sort_children", true)
			else:
				print("Frigo plein !")

func _trouver_un_slot_frigo_vide():
	# Cherche dans les slots ayant le groupe "slots_frigo"
	for slot in get_tree().get_nodes_in_group("slots_frigo"):
		# On vérifie que le slot est vide (get_child_count == 0)
		if slot.has_method("set_item") and slot.get_child_count() == 0:
			return slot
	return null
