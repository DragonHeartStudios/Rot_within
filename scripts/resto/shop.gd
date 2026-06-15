extends Button

# Chemin vers la grille de ton frigo (le GridContainer qui contient les slots)
@onready var frigo_grid: GridContainer = %inventaire
@onready var resto: Control = $"../../../../.."

# --- VARIABLES EXPORTÉES ---
@export var prix : float = 10.0
# Permet de choisir quel ingrédient ce bouton va acheter (sélectionne le fichier .tscn dans l'inspecteur)
@export var item_a_ajouter : PackedScene 

func _ready() -> void:
	text = str("-",prix,"$")

func _on_pressed() -> void:
	# 1. SÉCURITÉ : On vérifie si le joueur a assez d'argent
	if resto.argent < prix:
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
		# On vérifie si le slot est vide (grâce à sa variable current_item qu'on a créée avant)
		if "current_item" in slot and slot.current_item == null:
			slot_libre = slot
			break # On a trouvé une case vide ! On arrête la recherche (la boucle for) ici.
			
	# 4. SI LE FRIGO EST PLEIN
	if slot_libre == null:
		print("Le frigo est plein ! Impossible d'acheter un autre ingrédient. 🛑")
		return
		
	# 5. ACHAT ET APPARITION DE L'ITEM
	# Le joueur paie
	resto.argent -= prix
	
	# On crée l'ingrédient choisi
	var nouvel_item = item_a_ajouter.instantiate()
	
	# On l'ajoute dans le slot libre trouvé
	slot_libre.add_child(nouvel_item)
	
	# On applique ta formule de centrage automatique (en attendant un micro-frame pour la sécurité des tailles)
	await get_tree().process_frame
	nouvel_item.position = (slot_libre.size - nouvel_item.size) / 2
	
	# On dit au slot qu'il est maintenant occupé par cet item
	slot_libre.current_item = nouvel_item
	
	print("Item acheté avec succès et rangé dans le frigo ! 🛒")
