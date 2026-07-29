extends Button

# Chemin vers la grille de ton frigo (le GridContainer qui contient les slots)
@onready var frigo_grid: GridContainer = %inventaire
@onready var audio_stream_player: AudioStreamPlayer = %buy_sound

# --- VARIABLES EXPORTÉES ---
@export var prix : float = 10.0
# Permet de choisir quel ingrédient ce bouton va acheter (sélectionne le fichier .tscn dans l'inspecteur)
@export var item_a_ajouter : PackedScene 
@export var radioactive := false
func _ready() -> void:
	text = str("-", prix, "$")

func _on_pressed() -> void:
	# 1. SÉCURITÉ : On vérifie si le joueur a assez d'argent
	if GameManager.argent < prix:
		print("Vous n'avez pas assez d'argent ! 💸")
		return
		
	# 2. SÉCURITÉ 2 : On vérifie si l'utilisateur a bien mis une scène dans l'inspecteur
	if item_a_ajouter == null:
		print("Erreur : Aucune scène d'ingrédient n'a été assignée à ce bouton dans l'inspecteur !")
		return
	
	# 3. RECHERCHE DE LA PREMIÈRE CASE LIBRE
	var slots = frigo_grid.get_children()
	var slot_libre: Panel = null
	
	for slot in slots:
		# On vérifie si le slot est vide (grâce à sa variable current_item)
		if "current_item" in slot and slot.current_item == null:
			slot_libre = slot
			break # On a trouvé une case vide ! On arrête la recherche ici.
			
	# 4. SI LE FRIGO EST PLEIN
	if slot_libre == null:
		print("Le frigo est plein ! Impossible d'acheter un autre ingrédient. 🛑")
		return
		
	# 5. ACHAT ET ENREGISTREMENT DE L'ITEM
	# Le joueur paie
	GameManager.argent -= prix
	GameManager.prix_des_ingredient -= prix
	
	# On crée l'ingrédient choisi
	var nouvel_item = item_a_ajouter.instantiate()
	
	if radioactive == true:
		nouvel_item.add_to_group("Radioactive")
	# --- LA CORRECTION EST ICI ---
	# Au lieu de faire add_child et le calcul de position à la main, 
	# on appelle la fonction magique du slot. Elle va l'ajouter, le centrer ET le sauvegarder !
	if slot_libre.has_method("set_item"):
		slot_libre.set_item(nouvel_item)
	else:
		# Sécurité au cas où le slot n'a pas le script mis à jour
		slot_libre.add_child(nouvel_item)
		slot_libre.current_item = nouvel_item
	
	audio_stream_player.play()
	print("Item acheté avec succès, centré et sauvegardé dans le frigo ! 🛒")
