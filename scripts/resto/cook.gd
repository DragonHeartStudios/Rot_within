extends Button

# Référance vers la grille de la planche
@onready var planche_grid: GridContainer = $"../planche/PlancheGrid"

# --- LE COIN DES RECETTES ---
# Ingrédients TOUJOURS dans l'ordre alphabétique à gauche !
const RECETTES = {
	# --- 3 Ingrédients ---
	["concombre", "salade", "tomate"]: "res://scenes/resto/plat/salade_concombre_tomates.tscn",
	
	# --- 4 Ingrédients ---
	["fromage", "pain_burger", "salade", "viande_cuite"]: "res://scenes/resto/plat/burger.tscn",
	["baguette", "fromage", "salade", "tomate"]: "res://scenes/resto/plat/sandwich.tscn",
	["fromage", "oeuf"]: "res://scenes/resto/plat/omelette_fromage.tscn",
}

func _on_pressed() -> void:
	var ingredients = planche_grid.get_children()
	if ingredients.size() == 0:
		print("La planche est vide !")
		return

	# 1. On liste les groupes des ingrédients présents sur la planche
	var sur_la_planche = []
	for item in ingredients:
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
			planche_grid.add_child(nouveau_plat)
			planche_grid.move_child(nouveau_plat, 0)
			print("Plat préparé avec succès ! 🎉")
	else:
		print("Recette inconnue pour ces groupes : ", sur_la_planche)
