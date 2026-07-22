extends Button

# Référence vers la grille de la planche
@onready var planche_grid: GridContainer = $"../planche/PlancheGrid"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# --- LE COIN DES RECETTES ---
# Ingrédients TOUJOURS dans l'ordre alphabétique à gauche !
const RECETTES = {
	# --- 3 Ingrédients ---
	["cucumber", "lettuce", "tomato"]: "res://scenes/resto/plat/salade_concombre_tomates.tscn",
	
	# --- 4 Ingrédients ---
	["buns", "cheese", "cooked patty", "lettuce"]: "res://scenes/resto/plat/burger.tscn",
	["baguette", "cheese", "lettuce", "tomato"]: "res://scenes/resto/plat/sandwich.tscn",
	["cheese", "egg"]: "res://scenes/resto/plat/omelette_fromage.tscn",
}

func _on_pressed() -> void:
	var ingredients = planche_grid.get_children()
	if ingredients.size() == 0:
		print("La planche est vide !")
		return

	# Variable pour savoir si la recette contient de la radioactivité
	var est_radioactif: bool = false

	# 1. On liste les groupes des ingrédients présents sur la planche
	var sur_la_planche = []
	for item in ingredients:
		# --- NOUVEAU : On vérifie si cet ingrédient précis est radioactif ---
		if item.is_in_group("Radioactive"):
			est_radioactif = true
		
		# On liste tous les groupes du nœud (ex: ["tomate"])
		var groupes_de_l_item = item.get_groups()
		
		if groupes_de_l_item.size() > 0:
			# On prend le premier groupe trouvé (en minuscules pour éviter les erreurs)
			var nom_groupe = groupes_de_l_item[0].to_lower()
			sur_la_planche.append(nom_groupe)
		else:
			# Sécurité : si tu as oublié de mettre un groupe, on prend le nom du nœud
			sur_la_planche.append(item.name.to_lower())

	# 2. On trie par ordre alphabétique pour correspondre au dictionnaire
	sur_la_planche.sort()

	# 3. On vérifie si la combinaison existe dans ton dictionnaire RECETTES
	if sur_la_planche in RECETTES:
		var chemin_du_plat = RECETTES[sur_la_planche]
		
		# A. On supprime les ingrédients usés
		for item in ingredients:
			item.queue_free()
		
		# B. On charge et instancie le plat fini
		var scene_du_plat = load(chemin_du_plat)
		if scene_du_plat:
			var nouveau_plat = scene_du_plat.instantiate()
			if est_radioactif:
				nouveau_plat.add_to_group("Radioactive")
			planche_grid.add_child(nouveau_plat)
			planche_grid.move_child(nouveau_plat, 0)
			audio_stream_player.play()
			
			# --- NOUVEAU : Si un ingrédient l'était, le plat devient radioactif ! ---
			if est_radioactif:
				print("Plat préparé avec succès... et il brille dans le noir ! ☢️🎉")
			else:
				print("Plat préparé avec succès ! 🎉")
			
	else:
		print("Recette inconnue pour ces groupes : ", sur_la_planche)
