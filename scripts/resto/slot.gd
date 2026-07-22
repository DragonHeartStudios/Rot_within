extends Panel

# Variable pour suivre l'item actuellement dans CE slot
var current_item: TextureRect = null

func _ready() -> void:
	# Indispensable pour que la planche puisse renvoyer les objets ici automatiquement
	add_to_group("slots_frigo")
	
	# --- 1. CHARGEMENT DEPUIS LE GAMEMANAGER ---
	if GameManager.slots_du_frigo.has(name) and GameManager.slots_du_frigo[name] != "vide":
		var chemin_scene = GameManager.slots_du_frigo[name]
		
		var item_scene = load(chemin_scene)
		var item_instance = item_scene.instantiate()
		
		# On utilise notre nouvelle fonction pour l'installer et le sauvegarder
		set_item(item_instance)
	
	# --- 2. DÉTECTION SI UN ITEM EST DÉJÀ LÀ AU DÉMARRAGE DANS L'ÉDITEUR ---
	elif get_child_count() > 0:
		var item_de_base = get_child(0)
		if item_de_base is TextureRect:
			set_item(item_de_base)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is TextureRect and current_item == null

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var old_slot = data.get_parent()
	if old_slot and old_slot.has_method("remove_item"):
		old_slot.remove_item()
	
	if data.get_parent():
		data.get_parent().remove_child(data)
	
	# On utilise notre fonction magique ici aussi !
	set_item(data)

# FONCTION UNIQUE POUR AJOUTER UN OBJET ET LE SAUVEGARDER
func set_item(new_item: TextureRect) -> void:
	current_item = new_item
	
	if new_item.get_parent() != self:
		add_child(new_item)
	
	await get_tree().process_frame
	if is_instance_valid(new_item):
		new_item.position = (size - new_item.size) / 2
		
		# --- Connexion propre ---
		# On déconnecte TOUT avant de reconnecter pour éviter les doublons
		if new_item.gui_input.is_connected(_on_item_gui_input_frigo):
			new_item.gui_input.disconnect(_on_item_gui_input_frigo)
		new_item.gui_input.connect(_on_item_gui_input_frigo.bind(new_item))
		
		# --- LE RETOUR DE LA SAUVEGARDE AUTOMATIQUE ---
		# On enregistre le chemin de la scène de l'ingrédient dans le dictionnaire du GameManager
		GameManager.slots_du_frigo[name] = new_item.scene_file_path

func _on_item_gui_input_frigo(event: InputEvent, item: TextureRect) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Input.is_key_pressed(KEY_SHIFT):
			
			# On localise la planche grâce au groupe "planche_travail"
			var noeud_planche = get_tree().get_first_node_in_group("planche_travail")
			
			if noeud_planche and noeud_planche.has_node("PlancheGrid"):
				var grid = noeud_planche.get_node("PlancheGrid")
				
				# On applique ta limite personnalisée (MAX_ITEMS = 4)
				if grid.get_child_count() < 4:
					# 1. On nettoie et libère ce slot du frigo
					remove_item()
					if item.get_parent():
						item.get_parent().remove_child(item)
					
					# 2. On l'injecte directement dans le GridContainer enfant de la planche
					grid.add_child(item)
					grid.move_child(item, 0)
					item.position = Vector2.ZERO
					
					# 3. On coupe cette fonction pour que le script de la planche prenne le relais
					if item.gui_input.is_connected(_on_item_gui_input_frigo):
						item.gui_input.disconnect(_on_item_gui_input_frigo)
						
					print("Ingrédient téléporté sur le GridContainer de la planche !")
				else:
					print("La planche est pleine ! (Déjà 4 ingrédients)")

# Fonction appelée pour vider le slot
func remove_item() -> void:
	current_item = null
	# Remplacement de l'ancien test .has(name) par une affectation directe plus sûre
	GameManager.slots_du_frigo[name] = "vide"
